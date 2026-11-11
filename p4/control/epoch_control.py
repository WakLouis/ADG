"""BFRT installation and packed-state queries for epoch_tofino (SDE Python 3.5)."""
import math

import bfrt_grpc.client as gc


class EpochControl:
    def __init__(self, info, rules, clock, layout='direct', pipe_id=0):
        self.info = info
        self.rules = rules
        self.clock = clock
        self.pipe_id = pipe_id
        self.numeric = 'Ig' if layout == 'direct' else 'Eg'
        self.encoder = 'Eg' if layout == 'direct' else 'Ig'
        self.age_top = clock['time_bits']-1 if layout == 'direct' else 15
        self.target = gc.Target(device_id=0, pipe_id=0xffff)

    def add(self, table_name, records):
        table = self.info.table_get(table_name)
        table.entry_del(self.target)
        keys, data = [], []
        for fields, action, values in records:
            keys.append(table.make_key(fields))
            data.append(table.make_data([gc.DataTuple(k, v) for k, v in values.items()], action))
        table.entry_add(self.target, keys, data)
        return len(keys)

    def install(self):
        installed = {}
        bits = self.clock['quantum_bits']
        time_bits = self.clock['time_bits']
        for row in range(2):
            p = 'lane'+str(row)+'_'
            h = 'h.r'+str(row)+'.'
            for name in ('locate', 'normalize', 'interval'):
                records = []
                for rule in self.rules['encoder']:
                    fields = [gc.KeyTuple(h+'target', rule['profile']),
                              gc.KeyTuple(h+'value_hi', rule['value_hi'], rule['mask_hi']),
                              gc.KeyTuple(h+'value_lo', rule['value_lo'], rule['mask_lo']),
                              gc.KeyTuple('$MATCH_PRIORITY', 1)]
                    if name == 'locate':
                        action = 'prepare_zero' if rule['zero'] else 'prepare_normal'
                        values = {} if rule['zero'] else dict(shift=rule['shift'])
                    elif name == 'normalize':
                        action = 'normalize_cap' if rule['cap'] else 'normalize_value'
                        values = {} if rule['cap'] else dict(negative_base=(-rule['base']) & 0xffffffff)
                    else:
                        action = 'interval_cap' if rule['cap'] else 'interval_value'
                        values = {} if rule['cap'] else dict(start=rule['start'], upper=rule['upper'])
                    records.append((fields, self.encoder+'.'+p+action, values))
                name = 'pipe.'+self.encoder+'.'+p+name
                installed[name] = self.add(name, records)
            for name in ('decode_shift', 'decode_add', 'time', 'exponent', 'scale'):
                records = []
                rows = self.rules['decode'] if name.startswith('decode_') else self.rules[name]
                for record in rows:
                    if name.startswith('decode_'):
                        fields = [gc.KeyTuple(h+'source', record['profile']),
                                  gc.KeyTuple(h+'state[15:0]', record['state'], record['mask']),
                                  gc.KeyTuple('$MATCH_PRIORITY', 1)]
                        age_key = h+'age['+str(time_bits-1)+':0]'
                        if name == 'decode_add' and age_key in self.info.table_get('pipe.'+self.numeric+'.'+p+name).info.key_field_name_list_get():
                            fields.append(gc.KeyTuple(age_key,low=0,high=self.clock['retention_ticks']-1))
                        action = 'decode_'+str(record['shift']) if name == 'decode_shift' else 'decode_offset'
                        values = {(p+'exponent' if self.numeric=='Ig' else 'exponent'):record['exponent'] & 255} if name == 'decode_shift' else dict(intercept=record['intercept'])
                    elif name == 'time':
                        fields = [gc.KeyTuple(h+'age[7:0]', record['fraction'])]
                        action = 'time_parameters'
                        values = {'s'+str(i):record['shifts'][i] for i in range(5)}
                        for i, pair in enumerate(record['pairs']):
                            values['p'+str(i)] = int(pair['subtract'])+2*int(pair['add_back'])
                    elif name == 'exponent':
                        if record['whole'] >= 1 << (self.age_top-7):
                            continue
                        fields = [gc.KeyTuple(h+'age['+str(self.age_top)+':8]', record['whole'])]
                        action = 'adjust_exponent'
                        values = dict(negative_age=record['negative_age'])
                    elif name == 'scale':
                        fields = [gc.KeyTuple('m.'+p+'n_final_exponent', record['exponent'])]
                        action = 'scale_masks'
                        values = dict(mask_lo=record['mask_lo'], mask_hi=record['mask_hi'])
                    else:
                        fields = [gc.KeyTuple(h+'inject', 1),
                                  gc.KeyTuple(h+'phase['+str(bits-1)+':0]', record['phase'], record['mask']),
                                  gc.KeyTuple('$MATCH_PRIORITY', 1)]
                        action = 'phase_add'
                        values = dict(increment=record['increment'])
                    records.append((fields, self.numeric+'.'+p+action, values))
                name = 'pipe.'+self.numeric+'.'+p+name
                installed[name] = self.add(name, records)
        records = []
        for profile, shift, end in ((0,6,32768),(1,8,16384),(2,10,8192)):
            for row in self.rules['phase']:
                weight = row['increment'] >> 10
                delta = weight >> shift
                threshold = (weight & ((1 << shift)-1)) << (16-shift)
                fields = [gc.KeyTuple('m.target', profile),
                          gc.KeyTuple('m.now['+str(bits-1)+':0]', row['phase'], row['mask']),
                          gc.KeyTuple('$MATCH_PRIORITY', 1)]
                records.append((fields, 'Ig.phase_weight', dict(delta=delta, limit=end-delta, threshold=threshold,weight=row['increment'])))
        installed['pipe.Ig.fast_phase'] = self.add('pipe.Ig.fast_phase', records)
        return installed

    def configure(self, active, profiles, session=1):
        table = self.info.table_get('pipe.Ig.configuration')
        data = table.make_data([gc.DataTuple('active', active), gc.DataTuple('p0', profiles[0]),
                                gc.DataTuple('p1', profiles[1]), gc.DataTuple('session', session)], 'Ig.configure')
        table.default_entry_set(self.target, data)

    def words(self, indices):
        result = []
        for row, index in enumerate(indices):
            table = self.info.table_get('pipe.Ig.row'+str(row))
            key = table.make_key([gc.KeyTuple('$REGISTER_INDEX', index)])
            data, _ = next(table.entry_get(gc.Target(device_id=0, pipe_id=self.pipe_id), [key], {'from_hw':True}))
            value = [v for k, v in data.to_dict().items() if k.endswith('.f1')][0]
            result.append(value[0] if isinstance(value, list) else value)
        return result

    def query(self, indices, now, profiles, grids):
        estimates = []
        for word in self.words(indices):
            state = word & 65535
            age = ((now >> self.clock['quantum_bits'])-(word >> 16)) & ((1 << self.clock['time_bits'])-1)
            if not state or age >= self.clock['retention_ticks']:
                estimates.append(0.)
            else:
                slot = (word >> (16+self.clock['time_bits'])) & 1
                elapsed = (age << self.clock['quantum_bits'])+(now & ((1 << self.clock['quantum_bits'])-1))
                estimates.append(grids[profiles[slot]][state]/1024.*math.exp(-elapsed/self.clock['tau_ns']))
        return min(estimates)
