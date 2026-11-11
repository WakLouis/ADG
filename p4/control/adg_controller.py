"""ADG BFRT installation, queries, slot configuration, and maintenance."""
import argparse
import json
from pathlib import Path
import socket
import struct

ROOT = Path(__file__).resolve().parents[1]


def grids():
    records = json.loads((ROOT.parent/'config/grids.json').read_text())['grids']
    result = []
    for record in records:
        segments = record['segments']; index = 0; values = []
        for code in range(65536):
            while index+1 < len(segments) and segments[index+1][0] <= code:
                index += 1
            start, base, shift = segments[index]
            values.append(base+((code-start) << shift))
        result.append(values)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['install', 'configure', 'words', 'query', 'sweep'])
    parser.add_argument('--clock', choices=['long', 'short'], default='long')
    parser.add_argument('--grpc', default='localhost:50052')
    parser.add_argument('--pipe', type=int, default=0)
    parser.add_argument('--client-id', type=int, default=1)
    parser.add_argument('--egress-port', type=int)
    parser.add_argument('--return-port', type=int)
    parser.add_argument('--install-port', action='store_true')
    parser.add_argument('--session', type=int, default=1)
    parser.add_argument('--active', type=int, choices=[0, 1], default=0)
    parser.add_argument('--profiles', nargs=2, type=int, choices=[0, 1, 2], default=[0, 1])
    parser.add_argument('--indices', nargs=2, type=int)
    parser.add_argument('--now-ns', type=int)
    parser.add_argument('--interface')
    args = parser.parse_args()
    if args.action == 'sweep':
        if args.interface is None or args.now_ns is None:
            parser.error('sweep requires --interface and --now-ns')
        with socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x88b9)) as channel:
            channel.bind((args.interface, 0))
            ethernet = bytes.fromhex('02000000000202000000000188b9')
            for index in range(65536):
                payload = struct.pack('!BB6sHHIIHH', 2, 0, args.now_ns.to_bytes(6, 'big'),
                                      index, index, 0, 0, 0, 0)
                channel.send((ethernet+payload).ljust(64, b'\0'))
        print(json.dumps(dict(maintenance_packets=65536, rows=2)))
        return
    import bfrt_grpc.client as gc
    from epoch_control import EpochControl
    interface = gc.ClientInterface(grpc_addr=args.grpc, client_id=args.client_id, device_id=0)
    name = 'epoch_tofino2_'+args.clock
    interface.bind_pipeline_config(name)
    try:
        info = interface.bfrt_info_get(name)
        config = ROOT/'config'/args.clock
        control = EpochControl(info, json.loads((config/'rules.json').read_text()),
                               json.loads((config/'clock.json').read_text()), 'direct', args.pipe)
        target = gc.Target(device_id=0, pipe_id=0xffff)
        if args.action == 'install':
            if args.egress_port is None or args.return_port is None:
                parser.error('install requires --egress-port and --return-port')
            result = control.install()
            control.configure(args.active, args.profiles, args.session)
            forward = info.table_get('pipe.Ig.forwarding')
            forward.default_entry_set(target, forward.make_data([gc.DataTuple('port', args.egress_port)], 'Ig.forward'))
            mirror = info.table_get('$mirror.cfg')
            mirror.entry_add(target, [mirror.make_key([gc.KeyTuple('$sid', args.session)])],
                [mirror.make_data([gc.DataTuple('$direction', str_val='EGRESS'),
                    gc.DataTuple('$ucast_egress_port', args.return_port),
                    gc.DataTuple('$ucast_egress_port_valid', bool_val=True),
                    gc.DataTuple('$session_enable', bool_val=True), gc.DataTuple('$max_pkt_len', 256)], '$normal')])
            if args.install_port:
                ports = info.table_get('$PORT')
                ports.entry_add(target, [ports.make_key([gc.KeyTuple('$DEV_PORT', args.egress_port)])],
                    [ports.make_data([gc.DataTuple('$SPEED', str_val='BF_SPEED_100G'),
                        gc.DataTuple('$FEC', str_val='BF_FEC_TYP_REED_SOLOMON'),
                        gc.DataTuple('$PORT_ENABLE', bool_val=True)])])
        elif args.action == 'configure':
            control.configure(args.active, args.profiles, args.session)
            result = dict(active=args.active, profiles=args.profiles)
        else:
            if args.indices is None:
                parser.error('words and query require --indices')
            if args.action == 'words':
                result = dict(words=control.words(args.indices))
            else:
                if args.now_ns is None:
                    parser.error('query requires --now-ns')
                result = dict(estimate=control.query(args.indices, args.now_ns, args.profiles, grids()))
        print(json.dumps(result))
    finally:
        interface.tear_down_stream()


if __name__ == '__main__':
    main()
