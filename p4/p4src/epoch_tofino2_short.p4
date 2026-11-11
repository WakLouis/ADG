#include <core.p4>
#include <t2na.p4>
#ifndef NENT
#define NENT 65536
#endif
#ifndef ENABLE_FAST
#define ENABLE_FAST 1
#endif
#define RECIRC_PORT 6
header ethernet_t {bit<48> dst;bit<48> src;bit<16> type;}
header ipv4_t {bit<4> version;bit<4> ihl;bit<8> diffserv;bit<16> len;bit<16> id;
 bit<3> flags;bit<13> offset;bit<8> ttl;bit<8> protocol;bit<16> checksum;bit<32> src;bit<32> dst;}
header ports_t {bit<16> src;bit<16> dst;}
header event_t {bit<8> op;bit<8> mask;bit<48> now;bit<16> i0;bit<16> i1;bit<32> w0;bit<32> w1;bit<16> random_word;bit<16> serial;}
header writeback_t {bit<8> marker;bit<8> mask;bit<16> i0;bit<16> i1;bit<16> pad0;bit<32> w0;bit<32> w1;}
header bridge_t {bit<8> mask;bit<8> kind;bit<16> expected;bit<16> i0;bit<16> i1;bit<16> limit;MirrorId_t session;bit<8> pad;bit<8> profile0;bit<8> profile1;bit<16> pad2;bit<32> weight;}
header request_t {
    bit<8> target; bit<8> pad; bit<32> word; bit<32> value_hi; bit<32> value_lo;
    bit<32> low; bit<32> high; bit<32> threshold; bit<32> result; bit<16> serial; bit<16> reserved;bit<8> source;bit<8> inject;bit<16> age;bit<32> state;bit<32> phase;
}
struct numeric_t {
    bit<32> scaled; bit<32> scaled_hi;
    bit<32> normal; bit<32> quotient; bit<32> raw; bit<32> rounded; bit<32> coin_delta; bit<8> shift;
    bit<32> n_unbased;bit<32> n_mantissa;bit<32> n_term0;bit<32> n_term1;bit<32> n_term2;bit<32> n_term3;bit<32> n_term4;bit<32> n_base;bit<32> n_pair0;bit<32> n_pair1;bit<32> n_accumulator;bit<32> n_decayed;bit<32> n_aligned;bit<32> n_rotated;bit<32> n_scaled_lo;bit<32> n_scaled_hi;bit<8> n_exponent;bit<8> n_final_exponent;bit<8> n_shift0;bit<8> n_shift1;bit<8> n_shift2;bit<8> n_shift3;bit<8> n_shift4;bit<8> n_mode0;bit<8> n_mode1;bit<16> n_age_delta;
}
struct bucket_t {bit<16> value;bit<16> tag;}
header source_t {bit<32> state;bit<32> phase;bit<32> word;bit<8> target;bit<8> inject;bit<16> pad;}
struct headers_t {ethernet_t eth;ipv4_t ip;ports_t ports;event_t event;
 writeback_t wb;writeback_t replica;bridge_t bridge;source_t c0;source_t c1;request_t r0;request_t r1;}
@pa_container_size("egress", "m.lane0_scaled", 32)
@pa_container_size("egress", "m.lane0_scaled_hi", 32)
@pa_container_size("egress", "m.lane0_normal", 32)
@pa_container_size("egress", "m.lane0_quotient", 32)
@pa_container_size("egress", "m.lane0_raw", 32)
@pa_container_size("egress", "m.lane0_rounded", 32)
@pa_container_size("egress", "m.lane0_coin_delta", 32)
@pa_container_size("ingress", "m.lane0_n_mantissa", 32)
@pa_container_size("ingress", "m.lane0_n_term0", 32)
@pa_container_size("ingress", "m.lane0_n_term1", 32)
@pa_container_size("ingress", "m.lane0_n_term2", 32)
@pa_container_size("ingress", "m.lane0_n_term3", 32)
@pa_container_size("ingress", "m.lane0_n_term4", 32)
@pa_container_size("ingress", "m.lane0_n_accumulator", 32)
@pa_container_size("ingress", "m.lane0_n_pair0", 32)
@pa_container_size("ingress", "m.lane0_n_pair1", 32)
@pa_container_size("egress", "m.lane1_scaled", 32)
@pa_container_size("egress", "m.lane1_scaled_hi", 32)
@pa_container_size("egress", "m.lane1_normal", 32)
@pa_container_size("egress", "m.lane1_quotient", 32)
@pa_container_size("egress", "m.lane1_raw", 32)
@pa_container_size("egress", "m.lane1_rounded", 32)
@pa_container_size("egress", "m.lane1_coin_delta", 32)
@pa_container_size("ingress", "m.lane1_n_mantissa", 32)
@pa_container_size("ingress", "m.lane1_n_term0", 32)
@pa_container_size("ingress", "m.lane1_n_term1", 32)
@pa_container_size("ingress", "m.lane1_n_term2", 32)
@pa_container_size("ingress", "m.lane1_n_term3", 32)
@pa_container_size("ingress", "m.lane1_n_term4", 32)
@pa_container_size("ingress", "m.lane1_n_accumulator", 32)
@pa_container_size("ingress", "m.lane1_n_pair0", 32)
@pa_container_size("ingress", "m.lane1_n_pair1", 32)
@pa_container_size("egress", "h.r0.word", 32)
@pa_container_size("ingress", "h.r0.value_hi", 32)
@pa_container_size("egress", "h.r0.value_hi", 32)
@pa_container_size("ingress", "h.r0.value_lo", 32)
@pa_container_size("egress", "h.r0.value_lo", 32)
@pa_container_size("ingress", "h.r0.state", 32)
@pa_container_size("ingress", "h.r0.age", 16)
@pa_container_size("egress", "h.r1.word", 32)
@pa_container_size("ingress", "h.r1.value_hi", 32)
@pa_container_size("egress", "h.r1.value_hi", 32)
@pa_container_size("ingress", "h.r1.value_lo", 32)
@pa_container_size("egress", "h.r1.value_lo", 32)
@pa_container_size("ingress", "h.r1.state", 32)
@pa_container_size("ingress", "h.r1.age", 16)
@pa_container_size("ingress", "h.bridge.expected", 16)
@pa_container_size("ingress", "h.c0.state", 32)
@pa_container_size("ingress", "h.c0.phase", 32)
@pa_container_size("ingress", "h.c1.state", 32)
@pa_container_size("ingress", "h.c1.phase", 32)
struct metadata_t {bit<8> stat_index;bit<8> lower_ok0;bit<8> lower_ok1;bit<32> salu_word0;bit<8> access0;bit<32> salu_word1;bit<8> access1;bit<8> access;bit<8> slow0;bit<8> slow1;bit<8> live0;bit<8> empty0;bit<8> same0;bit<8> live1;bit<8> empty1;bit<8> same1;
    bit<32> lane0_scaled; bit<32> lane0_scaled_hi;
    bit<32> lane0_normal; bit<32> lane0_quotient; bit<32> lane0_raw; bit<32> lane0_rounded; bit<32> lane0_coin_delta; bit<8> lane0_shift;
    bit<32> lane0_n_unbased;bit<32> lane0_n_mantissa;bit<32> lane0_n_term0;bit<32> lane0_n_term1;bit<32> lane0_n_term2;bit<32> lane0_n_term3;bit<32> lane0_n_term4;bit<32> lane0_n_base;bit<32> lane0_n_pair0;bit<32> lane0_n_pair1;bit<32> lane0_n_accumulator;bit<32> lane0_n_decayed;bit<32> lane0_n_aligned;bit<32> lane0_n_rotated;bit<32> lane0_n_scaled_lo;bit<32> lane0_n_scaled_hi;bit<8> lane0_n_exponent;bit<8> lane0_n_final_exponent;bit<8> lane0_n_shift0;bit<8> lane0_n_shift1;bit<8> lane0_n_shift2;bit<8> lane0_n_shift3;bit<8> lane0_n_shift4;bit<8> lane0_n_mode0;bit<8> lane0_n_mode1;bit<16> lane0_n_age_delta;


    bit<32> lane1_scaled; bit<32> lane1_scaled_hi;
    bit<32> lane1_normal; bit<32> lane1_quotient; bit<32> lane1_raw; bit<32> lane1_rounded; bit<32> lane1_coin_delta; bit<8> lane1_shift;
    bit<32> lane1_n_unbased;bit<32> lane1_n_mantissa;bit<32> lane1_n_term0;bit<32> lane1_n_term1;bit<32> lane1_n_term2;bit<32> lane1_n_term3;bit<32> lane1_n_term4;bit<32> lane1_n_base;bit<32> lane1_n_pair0;bit<32> lane1_n_pair1;bit<32> lane1_n_accumulator;bit<32> lane1_n_decayed;bit<32> lane1_n_aligned;bit<32> lane1_n_rotated;bit<32> lane1_n_scaled_lo;bit<32> lane1_n_scaled_hi;bit<8> lane1_n_exponent;bit<8> lane1_n_final_exponent;bit<8> lane1_n_shift0;bit<8> lane1_n_shift1;bit<8> lane1_n_shift2;bit<8> lane1_n_shift3;bit<8> lane1_n_shift4;bit<8> lane1_n_mode0;bit<8> lane1_n_mode1;bit<16> lane1_n_age_delta;
bit<48> now;bit<16> word;bit<32> hash;
 bit<8> active;bit<8> profile0;bit<8> profile1;bit<8> target;
 bit<32> weight;bit<32> coin;bit<32> threshold;bit<32> operands;bit<16> limit;bit<32> delta;bit<32> old0;bit<32> old1;bit<32> lower;bit<32> upper;}

parser Ip(packet_in pkt,out headers_t h,out metadata_t m,out ingress_intrinsic_metadata_t im) {
 state start {pkt.extract(im);pkt.advance(PORT_METADATA_SIZE);m.active=0;m.profile0=0;m.profile1=1;transition select(im.ingress_port[6:0]){RECIRC_PORT:writeback;default:ethernet;}}
 state writeback {pkt.extract(h.wb);transition accept;}
 state ethernet {pkt.extract(h.eth);transition select(h.eth.type){0x88b9:event;0x0800:ipv4;default:accept;}}
 state event {pkt.extract(h.event);transition accept;}
 state ipv4 {pkt.extract(h.ip);transition select(h.ip.ihl,h.ip.protocol,h.ip.offset){(5,6,0):ports;(5,17,0):ports;default:accept;}}
 state ports {pkt.extract(h.ports);transition accept;}
}
control Ig(inout headers_t h,inout metadata_t m,in ingress_intrinsic_metadata_t im,
 in ingress_intrinsic_metadata_from_parser_t pm,inout ingress_intrinsic_metadata_for_deparser_t dm,
 inout ingress_intrinsic_metadata_for_tm_t tm) {
Counter<bit<64>,bit<8>>(4,CounterType_t.PACKETS_AND_BYTES) hardware_traffic;
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) bound_source;
action set_lower0(){m.lower_ok0=1;}
 action clear_lower0(){m.lower_ok0=0;}
 table lower_compare0{key={m.delta:exact;m.old0[15:0]:range;}actions={set_lower0;clear_lower0;}
 size=8;const default_action=clear_lower0();const entries={(32w64,16w64 .. 16w65535):set_lower0();(32w65,16w65 .. 16w65535):set_lower0();(32w256,16w256 .. 16w65535):set_lower0();(32w257,16w257 .. 16w65535):set_lower0();(32w1024,16w1024 .. 16w65535):set_lower0();(32w1025,16w1025 .. 16w65535):set_lower0();(32w1026,16w1026 .. 16w65535):set_lower0();(32w1027,16w1027 .. 16w65535):set_lower0();}}

action set_lower1(){m.lower_ok1=1;}
 action clear_lower1(){m.lower_ok1=0;}
 table lower_compare1{key={m.delta:exact;m.old1[15:0]:range;}actions={set_lower1;clear_lower1;}
 size=8;const default_action=clear_lower1();const entries={(32w64,16w64 .. 16w65535):set_lower1();(32w65,16w65 .. 16w65535):set_lower1();(32w256,16w256 .. 16w65535):set_lower1();(32w257,16w257 .. 16w65535):set_lower1();(32w1024,16w1024 .. 16w65535):set_lower1();(32w1025,16w1025 .. 16w65535):set_lower1();(32w1026,16w1026 .. 16w65535):set_lower1();(32w1027,16w1027 .. 16w65535):set_lower1();}}
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) state_copy1;
 action project_state1(){h.r1.state=state_copy1.get({(bit<32>)m.old1[15:0]});}
 table state_projection1{key={m.target:exact;}actions={project_state1;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:project_state1();8w1:project_state1();8w2:project_state1();}}
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) state_copy0;
 action project_state0(){h.r0.state=state_copy0.get({(bit<32>)m.old0[15:0]});}
 table state_projection0{key={m.target:exact;}actions={project_state0;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:project_state0();8w1:project_state0();8w2:project_state0();}}

 Register<bit<32>,bit<16>>(NENT) row0;
 Register<bit<32>,bit<16>>(NENT) row1;
 Random<bit<16>>() random_source;
 CRCPolynomial<bit<32>>(32w0x04c11db7,false,false,false,32w0,32w0) key_polynomial;
 Hash<bit<32>>(HashAlgorithm_t.CUSTOM,key_polynomial) hash_source;


 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) bridge_word0;
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) bridge_phase0;

 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) bridge_word1;
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) bridge_phase1;

action random_word0(){h.r0.word=bridge_word0.get({m.word,1w0});}
 table random_bridge0{key={m.target:exact;}actions={random_word0;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:random_word0();8w1:random_word0();8w2:random_word0();}}
action random_word1(){h.r1.word=bridge_word1.get({m.word,1w0});}
 table random_bridge1{key={m.target:exact;}actions={random_word1;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:random_word1();8w1:random_word1();8w2:random_word1();}}
Hash<bit<8>>(HashAlgorithm_t.IDENTITY) mask_source;
 action make_return_mask(){h.bridge.mask=mask_source.get({6w0,m.slow1[0:0],m.slow0[0:0]});}
 table return_mask_table{key={m.target:exact;}actions={make_return_mask;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:make_return_mask();8w1:make_return_mask();8w2:make_return_mask();}}
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) fast_coin_source;
 action configure(bit<8> active,bit<8> p0,bit<8> p1,MirrorId_t session){m.active=active;m.profile0=p0;m.profile1=p1;h.bridge.session=session;h.bridge.profile0=p0;h.bridge.profile1=p1;}
 table configuration {actions={configure;}size=1;default_action=configure(0,0,1,1);}
 action forward(PortId_t port){tm.ucast_egress_port=port;}
 table forwarding {key={im.ingress_port:exact;}actions={forward;}size=32;default_action=forward(8);}
 action choose_time(){m.now=pm.global_tstamp;m.word=random_source.get();}
 table clock_table {actions={choose_time;}size=1;default_action=choose_time();}
 Hash<bit<16>>(HashAlgorithm_t.IDENTITY) tag_hash;
 action prepare_tag(){h.bridge.expected=tag_hash.get({m.now[29:15]});}
 table tag_table{key={m.active:exact;}actions={prepare_tag;NoAction;}size=2;const default_action=NoAction();const entries={8w0:prepare_tag();8w1:prepare_tag();}}
 action add_slot(){h.bridge.expected=h.bridge.expected|16w32768;}
 table slot_table {actions={add_slot;}size=1;default_action=add_slot();}
 action hash_key(){m.hash=hash_source.get({h.ip.src,h.ip.dst,h.ip.protocol,h.ports.src,h.ports.dst});}
 table hash_table{key={h.ip.protocol:exact;}actions={hash_key;NoAction;}size=2;const default_action=NoAction();const entries={8w6:hash_key();8w17:hash_key();}}
 action phase_weight(bit<32> delta,bit<16> limit,bit<32> threshold,bit<32> weight){m.delta=delta;m.limit=limit;m.threshold=threshold;m.weight=weight;}
 table fast_phase{key={m.target:exact;m.now[14:0]:ternary;}actions={phase_weight;}
 size=8192;default_action=phase_weight(1024,31744,0,67108864);}

 action fast_coin(){m.coin=fast_coin_source.get({16w0,m.word})-m.threshold;}
 table fast_compare{key={m.target:exact;}actions={fast_coin;NoAction;}size=3;const default_action=NoAction();const entries={8w0:fast_coin();8w1:fast_coin();8w2:fast_coin();}}
 action fast_up(){m.delta=m.delta+1;m.limit=m.limit-1;}
 table fast_round{actions={fast_up;}size=1;default_action=fast_up();}
 action pack_operands(){m.operands=bound_source.get({h.bridge.expected,m.delta[15:0]});m.lower=h.bridge.expected ++ 16w0;m.salu_word0=h.bridge.expected ++ m.limit;m.salu_word1=h.bridge.expected ++ m.limit;}
 table pack_table{key={m.target:exact;}actions={pack_operands;NoAction;}size=3;const default_action=NoAction();const entries={8w0:pack_operands();8w1:pack_operands();8w2:pack_operands();}}
 action age0(){h.r0.age=h.bridge.expected-h.r0.age;}
 action age1(){h.r1.age=h.bridge.expected-h.r1.age;}
 table ages0{actions={age0;}size=1;default_action=age0();}
 table ages1{actions={age1;}size=1;default_action=age1();}
 action mask_age0(){h.r0.age=h.r0.age & 32767;}
 action mask_age1(){h.r1.age=h.r1.age & 32767;}
 table mask0{actions={mask_age0;}size=1;default_action=mask_age0();}
 table mask1{actions={mask_age1;}size=1;default_action=mask_age1();}
 RegisterAction<bit<32>,bit<16>,bit<32>>(row0) update0={
 void apply(inout bit<32> value,out bit<32> old){old=value;
 if(value>=m.operands&&value<=m.salu_word0){value=value+32w1024;}
 } };
 RegisterAction<bit<32>,bit<16>,bit<32>>(row0) read0={
 void apply(inout bit<32> value,out bit<32> old){old=value;} };
 RegisterAction<bit<32>,bit<16>,bit<32>>(row0) write0={
 void apply(inout bit<32> value,out bit<32> old){old=value;value=m.salu_word0;} };


 RegisterAction<bit<32>,bit<16>,bit<32>>(row1) update1={
 void apply(inout bit<32> value,out bit<32> old){old=value;
 if(value>=m.operands&&value<=m.salu_word1){value=value+32w1024;}
 } };
 RegisterAction<bit<32>,bit<16>,bit<32>>(row1) read1={
 void apply(inout bit<32> value,out bit<32> old){old=value;} };
 RegisterAction<bit<32>,bit<16>,bit<32>>(row1) write1={
 void apply(inout bit<32> value,out bit<32> old){old=value;value=m.salu_word1;} };





    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane0_n_hash_base;
    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane0_n_hash_pair0;
    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane0_n_hash_pair1;




    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane0_n_hash_scale;
    action lane0_decode_8(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 8;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_9(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 9;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_10(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 10;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_11(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 11;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_12(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 12;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_13(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 13;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_14(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 14;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_15(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 15;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_16(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 16;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_17(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 17;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_18(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 18;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_19(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 19;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_20(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 20;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_21(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 21;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_22(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 22;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_23(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 23;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_24(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 24;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_25(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 25;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_26(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 26;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_27(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 27;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_28(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 28;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_29(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 29;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_30(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 30;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_31(bit<8> lane0_exponent) { m.lane0_n_mantissa=h.r0.state << 31;m.lane0_n_exponent=lane0_exponent; }
    action lane0_decode_zero() { m.lane0_n_mantissa=0;m.lane0_n_exponent=0; }
    table lane0_decode_shift { key={h.r0.source:exact;h.r0.state[15:0]:ternary;} actions={lane0_decode_8;lane0_decode_9;lane0_decode_10;lane0_decode_11;lane0_decode_12;lane0_decode_13;lane0_decode_14;lane0_decode_15;lane0_decode_16;lane0_decode_17;lane0_decode_18;lane0_decode_19;lane0_decode_20;lane0_decode_21;lane0_decode_22;lane0_decode_23;lane0_decode_24;lane0_decode_25;lane0_decode_26;lane0_decode_27;lane0_decode_28;lane0_decode_29;lane0_decode_30;lane0_decode_31;lane0_decode_zero;} size=1108;default_action=lane0_decode_zero(); }
    action lane0_decode_offset(bit<32> intercept) { m.lane0_n_mantissa=m.lane0_n_mantissa+intercept; }
    action lane0_decode_empty() { m.lane0_n_mantissa=0; }
    table lane0_decode_add { key={h.r0.source:exact;h.r0.state[15:0]:ternary;} actions={lane0_decode_offset;lane0_decode_empty;}size=1108;default_action=lane0_decode_empty(); }
    action lane0_age_difference() { m.lane0_n_age_delta=h.r0.age+16w56840; }
    table lane0_age_gate { actions={lane0_age_difference;}size=1;default_action=lane0_age_difference(); }
    action lane0_time_parameters(bit<8> s0,bit<8> s1,bit<8> s2,bit<8> s3,bit<8> s4,bit<8> p0,bit<8> p1) { m.lane0_n_shift0=s0;m.lane0_n_shift1=s1;m.lane0_n_shift2=s2;m.lane0_n_shift3=s3;m.lane0_n_shift4=s4;m.lane0_n_mode0=p0;m.lane0_n_mode1=p1; }
    table lane0_time { key={h.r0.age[7:0]:exact;}actions={lane0_time_parameters;}size=256;default_action=lane0_time_parameters(32,32,32,32,32,0,0); }
    action lane0_adjust_exponent(bit<8> negative_age) { m.lane0_n_final_exponent=m.lane0_n_exponent+negative_age; }
    table lane0_exponent { key={h.r0.age[14:8]:exact;}actions={lane0_adjust_exponent;}size=128;default_action=lane0_adjust_exponent(0); }
action lane0_term_0_1(){m.lane0_n_term0=m.lane0_n_mantissa >> 1;}
action lane0_term_0_2(){m.lane0_n_term0=m.lane0_n_mantissa >> 2;}
action lane0_term_0_3(){m.lane0_n_term0=m.lane0_n_mantissa >> 3;}
action lane0_term_0_4(){m.lane0_n_term0=m.lane0_n_mantissa >> 4;}
action lane0_term_0_5(){m.lane0_n_term0=m.lane0_n_mantissa >> 5;}
action lane0_term_0_6(){m.lane0_n_term0=m.lane0_n_mantissa >> 6;}
action lane0_term_0_7(){m.lane0_n_term0=m.lane0_n_mantissa >> 7;}
action lane0_term_0_8(){m.lane0_n_term0=m.lane0_n_mantissa >> 8;}
action lane0_term_0_9(){m.lane0_n_term0=m.lane0_n_mantissa >> 9;}
action lane0_term_0_32(){m.lane0_n_term0=32w0;}
@stage(12) table lane0_term_table_0{key={m.lane0_n_shift0:exact;}actions={lane0_term_0_1;lane0_term_0_2;lane0_term_0_3;lane0_term_0_4;lane0_term_0_5;lane0_term_0_6;lane0_term_0_7;lane0_term_0_8;lane0_term_0_9;lane0_term_0_32;}size=10;const default_action=lane0_term_0_32();const entries={8w1:lane0_term_0_1();8w2:lane0_term_0_2();8w3:lane0_term_0_3();8w4:lane0_term_0_4();8w5:lane0_term_0_5();8w6:lane0_term_0_6();8w7:lane0_term_0_7();8w8:lane0_term_0_8();8w9:lane0_term_0_9();8w32:lane0_term_0_32();}}
action lane0_term_1_3(){m.lane0_n_term1=m.lane0_n_mantissa >> 3;}
action lane0_term_1_4(){m.lane0_n_term1=m.lane0_n_mantissa >> 4;}
action lane0_term_1_5(){m.lane0_n_term1=m.lane0_n_mantissa >> 5;}
action lane0_term_1_6(){m.lane0_n_term1=m.lane0_n_mantissa >> 6;}
action lane0_term_1_7(){m.lane0_n_term1=m.lane0_n_mantissa >> 7;}
action lane0_term_1_8(){m.lane0_n_term1=m.lane0_n_mantissa >> 8;}
action lane0_term_1_9(){m.lane0_n_term1=m.lane0_n_mantissa >> 9;}
action lane0_term_1_10(){m.lane0_n_term1=m.lane0_n_mantissa >> 10;}
action lane0_term_1_11(){m.lane0_n_term1=m.lane0_n_mantissa >> 11;}
action lane0_term_1_12(){m.lane0_n_term1=m.lane0_n_mantissa >> 12;}
action lane0_term_1_32(){m.lane0_n_term1=32w0;}
@stage(12) table lane0_term_table_1{key={m.lane0_n_shift1:exact;}actions={lane0_term_1_3;lane0_term_1_4;lane0_term_1_5;lane0_term_1_6;lane0_term_1_7;lane0_term_1_8;lane0_term_1_9;lane0_term_1_10;lane0_term_1_11;lane0_term_1_12;lane0_term_1_32;}size=11;const default_action=lane0_term_1_32();const entries={8w3:lane0_term_1_3();8w4:lane0_term_1_4();8w5:lane0_term_1_5();8w6:lane0_term_1_6();8w7:lane0_term_1_7();8w8:lane0_term_1_8();8w9:lane0_term_1_9();8w10:lane0_term_1_10();8w11:lane0_term_1_11();8w12:lane0_term_1_12();8w32:lane0_term_1_32();}}
action lane0_term_2_5(){m.lane0_n_term2=m.lane0_n_mantissa >> 5;}
action lane0_term_2_6(){m.lane0_n_term2=m.lane0_n_mantissa >> 6;}
action lane0_term_2_7(){m.lane0_n_term2=m.lane0_n_mantissa >> 7;}
action lane0_term_2_8(){m.lane0_n_term2=m.lane0_n_mantissa >> 8;}
action lane0_term_2_9(){m.lane0_n_term2=m.lane0_n_mantissa >> 9;}
action lane0_term_2_10(){m.lane0_n_term2=m.lane0_n_mantissa >> 10;}
action lane0_term_2_11(){m.lane0_n_term2=m.lane0_n_mantissa >> 11;}
action lane0_term_2_12(){m.lane0_n_term2=m.lane0_n_mantissa >> 12;}
action lane0_term_2_13(){m.lane0_n_term2=m.lane0_n_mantissa >> 13;}
action lane0_term_2_14(){m.lane0_n_term2=m.lane0_n_mantissa >> 14;}
action lane0_term_2_15(){m.lane0_n_term2=m.lane0_n_mantissa >> 15;}
action lane0_term_2_16(){m.lane0_n_term2=m.lane0_n_mantissa >> 16;}
action lane0_term_2_20(){m.lane0_n_term2=m.lane0_n_mantissa >> 20;}
action lane0_term_2_32(){m.lane0_n_term2=32w0;}
@stage(13) table lane0_term_table_2{key={m.lane0_n_shift2:exact;}actions={lane0_term_2_5;lane0_term_2_6;lane0_term_2_7;lane0_term_2_8;lane0_term_2_9;lane0_term_2_10;lane0_term_2_11;lane0_term_2_12;lane0_term_2_13;lane0_term_2_14;lane0_term_2_15;lane0_term_2_16;lane0_term_2_20;lane0_term_2_32;}size=14;const default_action=lane0_term_2_32();const entries={8w5:lane0_term_2_5();8w6:lane0_term_2_6();8w7:lane0_term_2_7();8w8:lane0_term_2_8();8w9:lane0_term_2_9();8w10:lane0_term_2_10();8w11:lane0_term_2_11();8w12:lane0_term_2_12();8w13:lane0_term_2_13();8w14:lane0_term_2_14();8w15:lane0_term_2_15();8w16:lane0_term_2_16();8w20:lane0_term_2_20();8w32:lane0_term_2_32();}}
action lane0_term_3_7(){m.lane0_n_term3=m.lane0_n_mantissa >> 7;}
action lane0_term_3_8(){m.lane0_n_term3=m.lane0_n_mantissa >> 8;}
action lane0_term_3_9(){m.lane0_n_term3=m.lane0_n_mantissa >> 9;}
action lane0_term_3_10(){m.lane0_n_term3=m.lane0_n_mantissa >> 10;}
action lane0_term_3_11(){m.lane0_n_term3=m.lane0_n_mantissa >> 11;}
action lane0_term_3_12(){m.lane0_n_term3=m.lane0_n_mantissa >> 12;}
action lane0_term_3_13(){m.lane0_n_term3=m.lane0_n_mantissa >> 13;}
action lane0_term_3_14(){m.lane0_n_term3=m.lane0_n_mantissa >> 14;}
action lane0_term_3_15(){m.lane0_n_term3=m.lane0_n_mantissa >> 15;}
action lane0_term_3_16(){m.lane0_n_term3=m.lane0_n_mantissa >> 16;}
action lane0_term_3_17(){m.lane0_n_term3=m.lane0_n_mantissa >> 17;}
action lane0_term_3_18(){m.lane0_n_term3=m.lane0_n_mantissa >> 18;}
action lane0_term_3_19(){m.lane0_n_term3=m.lane0_n_mantissa >> 19;}
action lane0_term_3_20(){m.lane0_n_term3=m.lane0_n_mantissa >> 20;}
action lane0_term_3_23(){m.lane0_n_term3=m.lane0_n_mantissa >> 23;}
action lane0_term_3_32(){m.lane0_n_term3=32w0;}
@stage(13) table lane0_term_table_3{key={m.lane0_n_shift3:exact;}actions={lane0_term_3_7;lane0_term_3_8;lane0_term_3_9;lane0_term_3_10;lane0_term_3_11;lane0_term_3_12;lane0_term_3_13;lane0_term_3_14;lane0_term_3_15;lane0_term_3_16;lane0_term_3_17;lane0_term_3_18;lane0_term_3_19;lane0_term_3_20;lane0_term_3_23;lane0_term_3_32;}size=16;const default_action=lane0_term_3_32();const entries={8w7:lane0_term_3_7();8w8:lane0_term_3_8();8w9:lane0_term_3_9();8w10:lane0_term_3_10();8w11:lane0_term_3_11();8w12:lane0_term_3_12();8w13:lane0_term_3_13();8w14:lane0_term_3_14();8w15:lane0_term_3_15();8w16:lane0_term_3_16();8w17:lane0_term_3_17();8w18:lane0_term_3_18();8w19:lane0_term_3_19();8w20:lane0_term_3_20();8w23:lane0_term_3_23();8w32:lane0_term_3_32();}}
action lane0_term_4_9(){m.lane0_n_term4=m.lane0_n_mantissa >> 9;}
action lane0_term_4_10(){m.lane0_n_term4=m.lane0_n_mantissa >> 10;}
action lane0_term_4_11(){m.lane0_n_term4=m.lane0_n_mantissa >> 11;}
action lane0_term_4_12(){m.lane0_n_term4=m.lane0_n_mantissa >> 12;}
action lane0_term_4_13(){m.lane0_n_term4=m.lane0_n_mantissa >> 13;}
action lane0_term_4_14(){m.lane0_n_term4=m.lane0_n_mantissa >> 14;}
action lane0_term_4_15(){m.lane0_n_term4=m.lane0_n_mantissa >> 15;}
action lane0_term_4_16(){m.lane0_n_term4=m.lane0_n_mantissa >> 16;}
action lane0_term_4_17(){m.lane0_n_term4=m.lane0_n_mantissa >> 17;}
action lane0_term_4_18(){m.lane0_n_term4=m.lane0_n_mantissa >> 18;}
action lane0_term_4_19(){m.lane0_n_term4=m.lane0_n_mantissa >> 19;}
action lane0_term_4_20(){m.lane0_n_term4=m.lane0_n_mantissa >> 20;}
action lane0_term_4_21(){m.lane0_n_term4=m.lane0_n_mantissa >> 21;}
action lane0_term_4_22(){m.lane0_n_term4=m.lane0_n_mantissa >> 22;}
action lane0_term_4_25(){m.lane0_n_term4=m.lane0_n_mantissa >> 25;}
action lane0_term_4_26(){m.lane0_n_term4=m.lane0_n_mantissa >> 26;}
action lane0_term_4_32(){m.lane0_n_term4=32w0;}
@stage(14) table lane0_term_table_4{key={m.lane0_n_shift4:exact;}actions={lane0_term_4_9;lane0_term_4_10;lane0_term_4_11;lane0_term_4_12;lane0_term_4_13;lane0_term_4_14;lane0_term_4_15;lane0_term_4_16;lane0_term_4_17;lane0_term_4_18;lane0_term_4_19;lane0_term_4_20;lane0_term_4_21;lane0_term_4_22;lane0_term_4_25;lane0_term_4_26;lane0_term_4_32;}size=17;const default_action=lane0_term_4_32();const entries={8w9:lane0_term_4_9();8w10:lane0_term_4_10();8w11:lane0_term_4_11();8w12:lane0_term_4_12();8w13:lane0_term_4_13();8w14:lane0_term_4_14();8w15:lane0_term_4_15();8w16:lane0_term_4_16();8w17:lane0_term_4_17();8w18:lane0_term_4_18();8w19:lane0_term_4_19();8w20:lane0_term_4_20();8w21:lane0_term_4_21();8w22:lane0_term_4_22();8w25:lane0_term_4_25();8w26:lane0_term_4_26();8w32:lane0_term_4_32();}}
    action lane0_partial_base() { m.lane0_n_accumulator=lane0_n_hash_base.get({m.lane0_n_mantissa})-m.lane0_n_term0; }
    table lane0_base { key={h.r0.source:exact;}actions={lane0_partial_base;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane0_partial_base();8w1:lane0_partial_base();8w2:lane0_partial_base();} }
    action lane0_pair_0_add() { m.lane0_n_pair0=lane0_n_hash_pair0.get({m.lane0_n_term1})+ m.lane0_n_term2; }
    action lane0_pair_0_subtract() { m.lane0_n_pair0=lane0_n_hash_pair0.get({m.lane0_n_term1})- m.lane0_n_term2; }
    table lane0_pair_table_0 { key={m.lane0_n_mode0[0:0]:exact;}actions={lane0_pair_0_add;lane0_pair_0_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane0_pair_0_add();1w1:lane0_pair_0_subtract();} }
    action lane0_combine_0_add() { m.lane0_n_accumulator=m.lane0_n_accumulator+ m.lane0_n_pair0; }
    action lane0_combine_0_subtract() { m.lane0_n_accumulator=m.lane0_n_accumulator- m.lane0_n_pair0; }
    table lane0_combine_table_0 { key={m.lane0_n_mode0[1:1]:exact;}actions={lane0_combine_0_add;lane0_combine_0_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane0_combine_0_subtract();1w1:lane0_combine_0_add();} }
    action lane0_pair_1_add() { m.lane0_n_pair1=lane0_n_hash_pair1.get({m.lane0_n_term3})+ m.lane0_n_term4; }
    action lane0_pair_1_subtract() { m.lane0_n_pair1=lane0_n_hash_pair1.get({m.lane0_n_term3})- m.lane0_n_term4; }
    table lane0_pair_table_1 { key={m.lane0_n_mode1[0:0]:exact;}actions={lane0_pair_1_add;lane0_pair_1_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane0_pair_1_add();1w1:lane0_pair_1_subtract();} }
    action lane0_combine_1_add() { m.lane0_n_accumulator=m.lane0_n_accumulator+ m.lane0_n_pair1; }
    action lane0_combine_1_subtract() { m.lane0_n_accumulator=m.lane0_n_accumulator- m.lane0_n_pair1; }
    table lane0_combine_table_1 { key={m.lane0_n_mode1[1:1]:exact;}actions={lane0_combine_1_add;lane0_combine_1_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane0_combine_1_subtract();1w1:lane0_combine_1_add();} }
    action lane0_align_value() { m.lane0_n_accumulator=lane0_n_hash_scale.get({m.lane0_n_accumulator}); }
    table lane0_align { key={h.r0.source:exact;}actions={lane0_align_value;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane0_align_value();8w1:lane0_align_value();8w2:lane0_align_value();} }
    action lane0_rotate_0() { m.lane0_n_mantissa=m.lane0_n_accumulator; }
    action lane0_rotate_1() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 1); }
    action lane0_rotate_2() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 2); }
    action lane0_rotate_3() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 3); }
    action lane0_rotate_4() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 4); }
    action lane0_rotate_5() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 5); }
    action lane0_rotate_6() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 6); }
    action lane0_rotate_7() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 7); }
    action lane0_rotate_8() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 8); }
    action lane0_rotate_9() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 9); }
    action lane0_rotate_10() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 10); }
    action lane0_rotate_11() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 11); }
    action lane0_rotate_12() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 12); }
    action lane0_rotate_13() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 13); }
    action lane0_rotate_14() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 14); }
    action lane0_rotate_15() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 15); }
    action lane0_rotate_16() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 16); }
    action lane0_rotate_17() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 17); }
    action lane0_rotate_18() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 18); }
    action lane0_rotate_19() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 19); }
    action lane0_rotate_20() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 20); }
    action lane0_rotate_21() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 21); }
    action lane0_rotate_22() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 22); }
    action lane0_rotate_23() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 23); }
    action lane0_rotate_24() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 24); }
    action lane0_rotate_25() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 25); }
    action lane0_rotate_26() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 26); }
    action lane0_rotate_27() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 27); }
    action lane0_rotate_28() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 28); }
    action lane0_rotate_29() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 29); }
    action lane0_rotate_30() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 30); }
    action lane0_rotate_31() { m.lane0_n_mantissa=(bit<32>)((m.lane0_n_accumulator ++ m.lane0_n_accumulator) >> 31); }
    @stage(18) table lane0_rotate { key={m.lane0_n_final_exponent:exact;}actions={lane0_rotate_0;lane0_rotate_1;lane0_rotate_2;lane0_rotate_3;lane0_rotate_4;lane0_rotate_5;lane0_rotate_6;lane0_rotate_7;lane0_rotate_8;lane0_rotate_9;lane0_rotate_10;lane0_rotate_11;lane0_rotate_12;lane0_rotate_13;lane0_rotate_14;lane0_rotate_15;lane0_rotate_16;lane0_rotate_17;lane0_rotate_18;lane0_rotate_19;lane0_rotate_20;lane0_rotate_21;lane0_rotate_22;lane0_rotate_23;lane0_rotate_24;lane0_rotate_25;lane0_rotate_26;lane0_rotate_27;lane0_rotate_28;lane0_rotate_29;lane0_rotate_30;lane0_rotate_31;}size=51;const default_action=lane0_rotate_0();const entries={8w225:lane0_rotate_31();8w226:lane0_rotate_30();8w227:lane0_rotate_29();8w228:lane0_rotate_28();8w229:lane0_rotate_27();8w230:lane0_rotate_26();8w231:lane0_rotate_25();8w232:lane0_rotate_24();8w233:lane0_rotate_23();8w234:lane0_rotate_22();8w235:lane0_rotate_21();8w236:lane0_rotate_20();8w237:lane0_rotate_19();8w238:lane0_rotate_18();8w239:lane0_rotate_17();8w240:lane0_rotate_16();8w241:lane0_rotate_15();8w242:lane0_rotate_14();8w243:lane0_rotate_13();8w244:lane0_rotate_12();8w245:lane0_rotate_11();8w246:lane0_rotate_10();8w247:lane0_rotate_9();8w248:lane0_rotate_8();8w249:lane0_rotate_7();8w250:lane0_rotate_6();8w251:lane0_rotate_5();8w252:lane0_rotate_4();8w253:lane0_rotate_3();8w254:lane0_rotate_2();8w255:lane0_rotate_1();8w0:lane0_rotate_0();8w1:lane0_rotate_31();8w2:lane0_rotate_30();8w3:lane0_rotate_29();8w4:lane0_rotate_28();8w5:lane0_rotate_27();8w6:lane0_rotate_26();8w7:lane0_rotate_25();8w8:lane0_rotate_24();8w9:lane0_rotate_23();8w10:lane0_rotate_22();8w11:lane0_rotate_21();8w12:lane0_rotate_20();8w13:lane0_rotate_19();8w14:lane0_rotate_18();8w15:lane0_rotate_17();8w16:lane0_rotate_16();8w17:lane0_rotate_15();8w18:lane0_rotate_14();8w19:lane0_rotate_13();} }
    action lane0_scale_masks(bit<32> mask_lo,bit<32> mask_hi) { h.c0.state=m.lane0_n_mantissa & mask_lo;h.c0.phase=m.lane0_n_mantissa & mask_hi; }
    table lane0_scale { key={m.lane0_n_final_exponent:exact;}actions={lane0_scale_masks;}size=51;default_action=lane0_scale_masks(0,0); }
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) phase_word0;
action lane0_phase_add(){h.r0.value_lo=m.lane0_n_accumulator+phase_word0.get({m.weight});h.c0.phase=h.c0.phase;}
 action lane0_phase_zero(){h.r0.value_lo=m.lane0_n_accumulator;h.c0.phase=h.c0.phase;}
 table lane0_phase{key={h.r0.inject:exact;}actions={lane0_phase_add;lane0_phase_zero;}
 size=2;const default_action=lane0_phase_zero();const entries={8w0:lane0_phase_zero();8w1:lane0_phase_add();}}

    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane1_n_hash_base;
    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane1_n_hash_pair0;
    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane1_n_hash_pair1;




    Hash<bit<32>>(HashAlgorithm_t.IDENTITY) lane1_n_hash_scale;
    action lane1_decode_8(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 8;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_9(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 9;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_10(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 10;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_11(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 11;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_12(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 12;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_13(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 13;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_14(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 14;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_15(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 15;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_16(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 16;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_17(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 17;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_18(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 18;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_19(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 19;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_20(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 20;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_21(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 21;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_22(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 22;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_23(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 23;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_24(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 24;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_25(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 25;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_26(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 26;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_27(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 27;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_28(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 28;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_29(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 29;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_30(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 30;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_31(bit<8> lane1_exponent) { m.lane1_n_mantissa=h.r1.state << 31;m.lane1_n_exponent=lane1_exponent; }
    action lane1_decode_zero() { m.lane1_n_mantissa=0;m.lane1_n_exponent=0; }
    table lane1_decode_shift { key={h.r1.source:exact;h.r1.state[15:0]:ternary;} actions={lane1_decode_8;lane1_decode_9;lane1_decode_10;lane1_decode_11;lane1_decode_12;lane1_decode_13;lane1_decode_14;lane1_decode_15;lane1_decode_16;lane1_decode_17;lane1_decode_18;lane1_decode_19;lane1_decode_20;lane1_decode_21;lane1_decode_22;lane1_decode_23;lane1_decode_24;lane1_decode_25;lane1_decode_26;lane1_decode_27;lane1_decode_28;lane1_decode_29;lane1_decode_30;lane1_decode_31;lane1_decode_zero;} size=1108;default_action=lane1_decode_zero(); }
    action lane1_decode_offset(bit<32> intercept) { m.lane1_n_mantissa=m.lane1_n_mantissa+intercept; }
    action lane1_decode_empty() { m.lane1_n_mantissa=0; }
    table lane1_decode_add { key={h.r1.source:exact;h.r1.state[15:0]:ternary;} actions={lane1_decode_offset;lane1_decode_empty;}size=1108;default_action=lane1_decode_empty(); }
    action lane1_age_difference() { m.lane1_n_age_delta=h.r1.age+16w56840; }
    table lane1_age_gate { actions={lane1_age_difference;}size=1;default_action=lane1_age_difference(); }
    action lane1_time_parameters(bit<8> s0,bit<8> s1,bit<8> s2,bit<8> s3,bit<8> s4,bit<8> p0,bit<8> p1) { m.lane1_n_shift0=s0;m.lane1_n_shift1=s1;m.lane1_n_shift2=s2;m.lane1_n_shift3=s3;m.lane1_n_shift4=s4;m.lane1_n_mode0=p0;m.lane1_n_mode1=p1; }
    table lane1_time { key={h.r1.age[7:0]:exact;}actions={lane1_time_parameters;}size=256;default_action=lane1_time_parameters(32,32,32,32,32,0,0); }
    action lane1_adjust_exponent(bit<8> negative_age) { m.lane1_n_final_exponent=m.lane1_n_exponent+negative_age; }
    table lane1_exponent { key={h.r1.age[14:8]:exact;}actions={lane1_adjust_exponent;}size=128;default_action=lane1_adjust_exponent(0); }
action lane1_term_0_1(){m.lane1_n_term0=m.lane1_n_mantissa >> 1;}
action lane1_term_0_2(){m.lane1_n_term0=m.lane1_n_mantissa >> 2;}
action lane1_term_0_3(){m.lane1_n_term0=m.lane1_n_mantissa >> 3;}
action lane1_term_0_4(){m.lane1_n_term0=m.lane1_n_mantissa >> 4;}
action lane1_term_0_5(){m.lane1_n_term0=m.lane1_n_mantissa >> 5;}
action lane1_term_0_6(){m.lane1_n_term0=m.lane1_n_mantissa >> 6;}
action lane1_term_0_7(){m.lane1_n_term0=m.lane1_n_mantissa >> 7;}
action lane1_term_0_8(){m.lane1_n_term0=m.lane1_n_mantissa >> 8;}
action lane1_term_0_9(){m.lane1_n_term0=m.lane1_n_mantissa >> 9;}
action lane1_term_0_32(){m.lane1_n_term0=32w0;}
@stage(12) table lane1_term_table_0{key={m.lane1_n_shift0:exact;}actions={lane1_term_0_1;lane1_term_0_2;lane1_term_0_3;lane1_term_0_4;lane1_term_0_5;lane1_term_0_6;lane1_term_0_7;lane1_term_0_8;lane1_term_0_9;lane1_term_0_32;}size=10;const default_action=lane1_term_0_32();const entries={8w1:lane1_term_0_1();8w2:lane1_term_0_2();8w3:lane1_term_0_3();8w4:lane1_term_0_4();8w5:lane1_term_0_5();8w6:lane1_term_0_6();8w7:lane1_term_0_7();8w8:lane1_term_0_8();8w9:lane1_term_0_9();8w32:lane1_term_0_32();}}
action lane1_term_1_3(){m.lane1_n_term1=m.lane1_n_mantissa >> 3;}
action lane1_term_1_4(){m.lane1_n_term1=m.lane1_n_mantissa >> 4;}
action lane1_term_1_5(){m.lane1_n_term1=m.lane1_n_mantissa >> 5;}
action lane1_term_1_6(){m.lane1_n_term1=m.lane1_n_mantissa >> 6;}
action lane1_term_1_7(){m.lane1_n_term1=m.lane1_n_mantissa >> 7;}
action lane1_term_1_8(){m.lane1_n_term1=m.lane1_n_mantissa >> 8;}
action lane1_term_1_9(){m.lane1_n_term1=m.lane1_n_mantissa >> 9;}
action lane1_term_1_10(){m.lane1_n_term1=m.lane1_n_mantissa >> 10;}
action lane1_term_1_11(){m.lane1_n_term1=m.lane1_n_mantissa >> 11;}
action lane1_term_1_12(){m.lane1_n_term1=m.lane1_n_mantissa >> 12;}
action lane1_term_1_32(){m.lane1_n_term1=32w0;}
@stage(12) table lane1_term_table_1{key={m.lane1_n_shift1:exact;}actions={lane1_term_1_3;lane1_term_1_4;lane1_term_1_5;lane1_term_1_6;lane1_term_1_7;lane1_term_1_8;lane1_term_1_9;lane1_term_1_10;lane1_term_1_11;lane1_term_1_12;lane1_term_1_32;}size=11;const default_action=lane1_term_1_32();const entries={8w3:lane1_term_1_3();8w4:lane1_term_1_4();8w5:lane1_term_1_5();8w6:lane1_term_1_6();8w7:lane1_term_1_7();8w8:lane1_term_1_8();8w9:lane1_term_1_9();8w10:lane1_term_1_10();8w11:lane1_term_1_11();8w12:lane1_term_1_12();8w32:lane1_term_1_32();}}
action lane1_term_2_5(){m.lane1_n_term2=m.lane1_n_mantissa >> 5;}
action lane1_term_2_6(){m.lane1_n_term2=m.lane1_n_mantissa >> 6;}
action lane1_term_2_7(){m.lane1_n_term2=m.lane1_n_mantissa >> 7;}
action lane1_term_2_8(){m.lane1_n_term2=m.lane1_n_mantissa >> 8;}
action lane1_term_2_9(){m.lane1_n_term2=m.lane1_n_mantissa >> 9;}
action lane1_term_2_10(){m.lane1_n_term2=m.lane1_n_mantissa >> 10;}
action lane1_term_2_11(){m.lane1_n_term2=m.lane1_n_mantissa >> 11;}
action lane1_term_2_12(){m.lane1_n_term2=m.lane1_n_mantissa >> 12;}
action lane1_term_2_13(){m.lane1_n_term2=m.lane1_n_mantissa >> 13;}
action lane1_term_2_14(){m.lane1_n_term2=m.lane1_n_mantissa >> 14;}
action lane1_term_2_15(){m.lane1_n_term2=m.lane1_n_mantissa >> 15;}
action lane1_term_2_16(){m.lane1_n_term2=m.lane1_n_mantissa >> 16;}
action lane1_term_2_20(){m.lane1_n_term2=m.lane1_n_mantissa >> 20;}
action lane1_term_2_32(){m.lane1_n_term2=32w0;}
@stage(13) table lane1_term_table_2{key={m.lane1_n_shift2:exact;}actions={lane1_term_2_5;lane1_term_2_6;lane1_term_2_7;lane1_term_2_8;lane1_term_2_9;lane1_term_2_10;lane1_term_2_11;lane1_term_2_12;lane1_term_2_13;lane1_term_2_14;lane1_term_2_15;lane1_term_2_16;lane1_term_2_20;lane1_term_2_32;}size=14;const default_action=lane1_term_2_32();const entries={8w5:lane1_term_2_5();8w6:lane1_term_2_6();8w7:lane1_term_2_7();8w8:lane1_term_2_8();8w9:lane1_term_2_9();8w10:lane1_term_2_10();8w11:lane1_term_2_11();8w12:lane1_term_2_12();8w13:lane1_term_2_13();8w14:lane1_term_2_14();8w15:lane1_term_2_15();8w16:lane1_term_2_16();8w20:lane1_term_2_20();8w32:lane1_term_2_32();}}
action lane1_term_3_7(){m.lane1_n_term3=m.lane1_n_mantissa >> 7;}
action lane1_term_3_8(){m.lane1_n_term3=m.lane1_n_mantissa >> 8;}
action lane1_term_3_9(){m.lane1_n_term3=m.lane1_n_mantissa >> 9;}
action lane1_term_3_10(){m.lane1_n_term3=m.lane1_n_mantissa >> 10;}
action lane1_term_3_11(){m.lane1_n_term3=m.lane1_n_mantissa >> 11;}
action lane1_term_3_12(){m.lane1_n_term3=m.lane1_n_mantissa >> 12;}
action lane1_term_3_13(){m.lane1_n_term3=m.lane1_n_mantissa >> 13;}
action lane1_term_3_14(){m.lane1_n_term3=m.lane1_n_mantissa >> 14;}
action lane1_term_3_15(){m.lane1_n_term3=m.lane1_n_mantissa >> 15;}
action lane1_term_3_16(){m.lane1_n_term3=m.lane1_n_mantissa >> 16;}
action lane1_term_3_17(){m.lane1_n_term3=m.lane1_n_mantissa >> 17;}
action lane1_term_3_18(){m.lane1_n_term3=m.lane1_n_mantissa >> 18;}
action lane1_term_3_19(){m.lane1_n_term3=m.lane1_n_mantissa >> 19;}
action lane1_term_3_20(){m.lane1_n_term3=m.lane1_n_mantissa >> 20;}
action lane1_term_3_23(){m.lane1_n_term3=m.lane1_n_mantissa >> 23;}
action lane1_term_3_32(){m.lane1_n_term3=32w0;}
@stage(13) table lane1_term_table_3{key={m.lane1_n_shift3:exact;}actions={lane1_term_3_7;lane1_term_3_8;lane1_term_3_9;lane1_term_3_10;lane1_term_3_11;lane1_term_3_12;lane1_term_3_13;lane1_term_3_14;lane1_term_3_15;lane1_term_3_16;lane1_term_3_17;lane1_term_3_18;lane1_term_3_19;lane1_term_3_20;lane1_term_3_23;lane1_term_3_32;}size=16;const default_action=lane1_term_3_32();const entries={8w7:lane1_term_3_7();8w8:lane1_term_3_8();8w9:lane1_term_3_9();8w10:lane1_term_3_10();8w11:lane1_term_3_11();8w12:lane1_term_3_12();8w13:lane1_term_3_13();8w14:lane1_term_3_14();8w15:lane1_term_3_15();8w16:lane1_term_3_16();8w17:lane1_term_3_17();8w18:lane1_term_3_18();8w19:lane1_term_3_19();8w20:lane1_term_3_20();8w23:lane1_term_3_23();8w32:lane1_term_3_32();}}
action lane1_term_4_9(){m.lane1_n_term4=m.lane1_n_mantissa >> 9;}
action lane1_term_4_10(){m.lane1_n_term4=m.lane1_n_mantissa >> 10;}
action lane1_term_4_11(){m.lane1_n_term4=m.lane1_n_mantissa >> 11;}
action lane1_term_4_12(){m.lane1_n_term4=m.lane1_n_mantissa >> 12;}
action lane1_term_4_13(){m.lane1_n_term4=m.lane1_n_mantissa >> 13;}
action lane1_term_4_14(){m.lane1_n_term4=m.lane1_n_mantissa >> 14;}
action lane1_term_4_15(){m.lane1_n_term4=m.lane1_n_mantissa >> 15;}
action lane1_term_4_16(){m.lane1_n_term4=m.lane1_n_mantissa >> 16;}
action lane1_term_4_17(){m.lane1_n_term4=m.lane1_n_mantissa >> 17;}
action lane1_term_4_18(){m.lane1_n_term4=m.lane1_n_mantissa >> 18;}
action lane1_term_4_19(){m.lane1_n_term4=m.lane1_n_mantissa >> 19;}
action lane1_term_4_20(){m.lane1_n_term4=m.lane1_n_mantissa >> 20;}
action lane1_term_4_21(){m.lane1_n_term4=m.lane1_n_mantissa >> 21;}
action lane1_term_4_22(){m.lane1_n_term4=m.lane1_n_mantissa >> 22;}
action lane1_term_4_25(){m.lane1_n_term4=m.lane1_n_mantissa >> 25;}
action lane1_term_4_26(){m.lane1_n_term4=m.lane1_n_mantissa >> 26;}
action lane1_term_4_32(){m.lane1_n_term4=32w0;}
@stage(14) table lane1_term_table_4{key={m.lane1_n_shift4:exact;}actions={lane1_term_4_9;lane1_term_4_10;lane1_term_4_11;lane1_term_4_12;lane1_term_4_13;lane1_term_4_14;lane1_term_4_15;lane1_term_4_16;lane1_term_4_17;lane1_term_4_18;lane1_term_4_19;lane1_term_4_20;lane1_term_4_21;lane1_term_4_22;lane1_term_4_25;lane1_term_4_26;lane1_term_4_32;}size=17;const default_action=lane1_term_4_32();const entries={8w9:lane1_term_4_9();8w10:lane1_term_4_10();8w11:lane1_term_4_11();8w12:lane1_term_4_12();8w13:lane1_term_4_13();8w14:lane1_term_4_14();8w15:lane1_term_4_15();8w16:lane1_term_4_16();8w17:lane1_term_4_17();8w18:lane1_term_4_18();8w19:lane1_term_4_19();8w20:lane1_term_4_20();8w21:lane1_term_4_21();8w22:lane1_term_4_22();8w25:lane1_term_4_25();8w26:lane1_term_4_26();8w32:lane1_term_4_32();}}
    action lane1_partial_base() { m.lane1_n_accumulator=lane1_n_hash_base.get({m.lane1_n_mantissa})-m.lane1_n_term0; }
    table lane1_base { key={h.r1.source:exact;}actions={lane1_partial_base;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane1_partial_base();8w1:lane1_partial_base();8w2:lane1_partial_base();} }
    action lane1_pair_0_add() { m.lane1_n_pair0=lane1_n_hash_pair0.get({m.lane1_n_term1})+ m.lane1_n_term2; }
    action lane1_pair_0_subtract() { m.lane1_n_pair0=lane1_n_hash_pair0.get({m.lane1_n_term1})- m.lane1_n_term2; }
    table lane1_pair_table_0 { key={m.lane1_n_mode0[0:0]:exact;}actions={lane1_pair_0_add;lane1_pair_0_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane1_pair_0_add();1w1:lane1_pair_0_subtract();} }
    action lane1_combine_0_add() { m.lane1_n_accumulator=m.lane1_n_accumulator+ m.lane1_n_pair0; }
    action lane1_combine_0_subtract() { m.lane1_n_accumulator=m.lane1_n_accumulator- m.lane1_n_pair0; }
    table lane1_combine_table_0 { key={m.lane1_n_mode0[1:1]:exact;}actions={lane1_combine_0_add;lane1_combine_0_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane1_combine_0_subtract();1w1:lane1_combine_0_add();} }
    action lane1_pair_1_add() { m.lane1_n_pair1=lane1_n_hash_pair1.get({m.lane1_n_term3})+ m.lane1_n_term4; }
    action lane1_pair_1_subtract() { m.lane1_n_pair1=lane1_n_hash_pair1.get({m.lane1_n_term3})- m.lane1_n_term4; }
    table lane1_pair_table_1 { key={m.lane1_n_mode1[0:0]:exact;}actions={lane1_pair_1_add;lane1_pair_1_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane1_pair_1_add();1w1:lane1_pair_1_subtract();} }
    action lane1_combine_1_add() { m.lane1_n_accumulator=m.lane1_n_accumulator+ m.lane1_n_pair1; }
    action lane1_combine_1_subtract() { m.lane1_n_accumulator=m.lane1_n_accumulator- m.lane1_n_pair1; }
    table lane1_combine_table_1 { key={m.lane1_n_mode1[1:1]:exact;}actions={lane1_combine_1_add;lane1_combine_1_subtract;NoAction;}size=2;const default_action=NoAction();const entries={1w0:lane1_combine_1_subtract();1w1:lane1_combine_1_add();} }
    action lane1_align_value() { m.lane1_n_accumulator=lane1_n_hash_scale.get({m.lane1_n_accumulator}); }
    table lane1_align { key={h.r1.source:exact;}actions={lane1_align_value;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane1_align_value();8w1:lane1_align_value();8w2:lane1_align_value();} }
    action lane1_rotate_0() { m.lane1_n_mantissa=m.lane1_n_accumulator; }
    action lane1_rotate_1() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 1); }
    action lane1_rotate_2() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 2); }
    action lane1_rotate_3() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 3); }
    action lane1_rotate_4() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 4); }
    action lane1_rotate_5() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 5); }
    action lane1_rotate_6() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 6); }
    action lane1_rotate_7() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 7); }
    action lane1_rotate_8() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 8); }
    action lane1_rotate_9() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 9); }
    action lane1_rotate_10() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 10); }
    action lane1_rotate_11() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 11); }
    action lane1_rotate_12() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 12); }
    action lane1_rotate_13() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 13); }
    action lane1_rotate_14() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 14); }
    action lane1_rotate_15() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 15); }
    action lane1_rotate_16() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 16); }
    action lane1_rotate_17() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 17); }
    action lane1_rotate_18() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 18); }
    action lane1_rotate_19() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 19); }
    action lane1_rotate_20() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 20); }
    action lane1_rotate_21() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 21); }
    action lane1_rotate_22() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 22); }
    action lane1_rotate_23() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 23); }
    action lane1_rotate_24() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 24); }
    action lane1_rotate_25() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 25); }
    action lane1_rotate_26() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 26); }
    action lane1_rotate_27() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 27); }
    action lane1_rotate_28() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 28); }
    action lane1_rotate_29() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 29); }
    action lane1_rotate_30() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 30); }
    action lane1_rotate_31() { m.lane1_n_mantissa=(bit<32>)((m.lane1_n_accumulator ++ m.lane1_n_accumulator) >> 31); }
    @stage(17) table lane1_rotate { key={m.lane1_n_final_exponent:exact;}actions={lane1_rotate_0;lane1_rotate_1;lane1_rotate_2;lane1_rotate_3;lane1_rotate_4;lane1_rotate_5;lane1_rotate_6;lane1_rotate_7;lane1_rotate_8;lane1_rotate_9;lane1_rotate_10;lane1_rotate_11;lane1_rotate_12;lane1_rotate_13;lane1_rotate_14;lane1_rotate_15;lane1_rotate_16;lane1_rotate_17;lane1_rotate_18;lane1_rotate_19;lane1_rotate_20;lane1_rotate_21;lane1_rotate_22;lane1_rotate_23;lane1_rotate_24;lane1_rotate_25;lane1_rotate_26;lane1_rotate_27;lane1_rotate_28;lane1_rotate_29;lane1_rotate_30;lane1_rotate_31;}size=51;const default_action=lane1_rotate_0();const entries={8w225:lane1_rotate_31();8w226:lane1_rotate_30();8w227:lane1_rotate_29();8w228:lane1_rotate_28();8w229:lane1_rotate_27();8w230:lane1_rotate_26();8w231:lane1_rotate_25();8w232:lane1_rotate_24();8w233:lane1_rotate_23();8w234:lane1_rotate_22();8w235:lane1_rotate_21();8w236:lane1_rotate_20();8w237:lane1_rotate_19();8w238:lane1_rotate_18();8w239:lane1_rotate_17();8w240:lane1_rotate_16();8w241:lane1_rotate_15();8w242:lane1_rotate_14();8w243:lane1_rotate_13();8w244:lane1_rotate_12();8w245:lane1_rotate_11();8w246:lane1_rotate_10();8w247:lane1_rotate_9();8w248:lane1_rotate_8();8w249:lane1_rotate_7();8w250:lane1_rotate_6();8w251:lane1_rotate_5();8w252:lane1_rotate_4();8w253:lane1_rotate_3();8w254:lane1_rotate_2();8w255:lane1_rotate_1();8w0:lane1_rotate_0();8w1:lane1_rotate_31();8w2:lane1_rotate_30();8w3:lane1_rotate_29();8w4:lane1_rotate_28();8w5:lane1_rotate_27();8w6:lane1_rotate_26();8w7:lane1_rotate_25();8w8:lane1_rotate_24();8w9:lane1_rotate_23();8w10:lane1_rotate_22();8w11:lane1_rotate_21();8w12:lane1_rotate_20();8w13:lane1_rotate_19();8w14:lane1_rotate_18();8w15:lane1_rotate_17();8w16:lane1_rotate_16();8w17:lane1_rotate_15();8w18:lane1_rotate_14();8w19:lane1_rotate_13();} }
    action lane1_scale_masks(bit<32> mask_lo,bit<32> mask_hi) { h.c1.state=m.lane1_n_mantissa & mask_lo;h.c1.phase=m.lane1_n_mantissa & mask_hi; }
    table lane1_scale { key={m.lane1_n_final_exponent:exact;}actions={lane1_scale_masks;}size=51;default_action=lane1_scale_masks(0,0); }
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) phase_word1;
action lane1_phase_add(){h.r1.value_lo=m.lane1_n_accumulator+phase_word1.get({m.weight});h.c1.phase=h.c1.phase;}
 action lane1_phase_zero(){h.r1.value_lo=m.lane1_n_accumulator;h.c1.phase=h.c1.phase;}
 table lane1_phase{key={h.r1.inject:exact;}actions={lane1_phase_add;lane1_phase_zero;}
 size=2;const default_action=lane1_phase_zero();const entries={8w0:lane1_phase_zero();8w1:lane1_phase_add();}}

action eg_age0(){h.r0.age=h.bridge.expected-h.r0.age;}
 table eg_ages0{actions={eg_age0;}size=1;default_action=eg_age0();}
 action eg_mask0(){h.r0.age=h.r0.age & 16w32767;}
 table eg_masks0{actions={eg_mask0;}size=1;default_action=eg_mask0();}
action eg_age1(){h.r1.age=h.bridge.expected-h.r1.age;}
 table eg_ages1{actions={eg_age1;}size=1;default_action=eg_age1();}
 action eg_mask1(){h.r1.age=h.r1.age & 16w32767;}
 table eg_masks1{actions={eg_mask1;}size=1;default_action=eg_mask1();}
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) compare_limit0;
 action eg_compare0(){m.lane0_n_accumulator=compare_limit0.get({h.bridge.limit})-h.r0.state;}
 table eg_comparison0{key={h.r0.target:exact;}actions={eg_compare0;NoAction;}size=3;const default_action=NoAction();const entries={8w0:eg_compare0();8w1:eg_compare0();8w2:eg_compare0();}}
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) compare_limit1;
 action eg_compare1(){m.lane1_n_accumulator=compare_limit1.get({h.bridge.limit})-h.r1.state;}
 table eg_comparison1{key={h.r1.target:exact;}actions={eg_compare1;NoAction;}size=3;const default_action=NoAction();const entries={8w0:eg_compare1();8w1:eg_compare1();8w2:eg_compare1();}}


action set_live0(){m.live0=1;}
 action clear_live0(){m.live0=0;}
action set_empty0(){m.empty0=1;}
 action clear_empty0(){m.empty0=0;}
action set_same0(){m.same0=1;}
 action clear_same0(){m.same0=0;}
table empty_fact0{key={m.old0[15:0]:exact;}actions={set_empty0;clear_empty0;}
 size=1;const default_action=clear_empty0();const entries={16w0:set_empty0();}}
 table live_fact0{key={h.r0.age[14:0]:range;}actions={set_live0;clear_live0;}
 size=1;const default_action=clear_live0();const entries={15w0 .. 15w8695:set_live0();}}
 table same_fact0{key={m.old0[31:31]:exact;h.bridge.expected[15:15]:exact;}
 actions={set_same0;clear_same0;}size=2;const default_action=clear_same0();
 const entries={(1w0,1w0):set_same0();(1w1,1w1):set_same0();}}


action set_live1(){m.live1=1;}
 action clear_live1(){m.live1=0;}
action set_empty1(){m.empty1=1;}
 action clear_empty1(){m.empty1=0;}
action set_same1(){m.same1=1;}
 action clear_same1(){m.same1=0;}
table empty_fact1{key={m.old1[15:0]:exact;}actions={set_empty1;clear_empty1;}
 size=1;const default_action=clear_empty1();const entries={16w0:set_empty1();}}
 table live_fact1{key={h.r1.age[14:0]:range;}actions={set_live1;clear_live1;}
 size=1;const default_action=clear_live1();const entries={15w0 .. 15w8695:set_live1();}}
 table same_fact1{key={m.old1[31:31]:exact;h.bridge.expected[15:15]:exact;}
 actions={set_same1;clear_same1;}size=2;const default_action=clear_same1();
 const entries={(1w0,1w0):set_same1();(1w1,1w1):set_same1();}}

action access_update0(){m.old0=update0.execute(h.bridge.i0);}
action access_read0(){m.old0=read0.execute(h.bridge.i0);}
action access_write0(){m.old0=write0.execute(h.bridge.i0);}
action access_load0(){m.old0=write0.execute(h.bridge.i0);}
 table access_row0{key={m.access0:exact;m.delta:ternary;}
 actions={access_update0;access_read0;access_write0;access_load0;NoAction;}size=5;
 const default_action=NoAction();const entries={(8w0,32w1024 &&& 32w0xffffffff):access_update0();(8w0,32w0 &&& 32w0):access_read0();(8w1,32w0 &&& 32w0):access_read0();(8w2,32w0 &&& 32w0):access_write0();(8w3,32w0 &&& 32w0):access_load0();}}

action access_update1(){m.old1=update1.execute(h.bridge.i1);}
action access_read1(){m.old1=read1.execute(h.bridge.i1);}
action access_write1(){m.old1=write1.execute(h.bridge.i1);}
action access_load1(){m.old1=write1.execute(h.bridge.i1);}
 table access_row1{key={m.access1:exact;m.delta:ternary;}
 actions={access_update1;access_read1;access_write1;access_load1;NoAction;}size=5;
 const default_action=NoAction();const entries={(8w0,32w1024 &&& 32w0xffffffff):access_update1();(8w0,32w0 &&& 32w0):access_read1();(8w1,32w0 &&& 32w0):access_read1();(8w2,32w0 &&& 32w0):access_write1();(8w3,32w0 &&& 32w0):access_load1();}}

 apply {
 m.stat_index=2;
 if(h.event.isValid()||(h.ip.isValid()&&h.ports.isValid())){m.stat_index=0;}
 if(h.wb.isValid()){m.stat_index=1;}
 hardware_traffic.count(m.stat_index);
 if(h.wb.isValid()){
   m.access=2;h.bridge.i0=h.wb.i0;h.bridge.i1=h.wb.i1;dm.drop_ctl=1;
 }else if(h.event.isValid()||(h.ip.isValid()&&h.ports.isValid())){
     h.bridge.setValid();h.bridge.mask=0;h.bridge.kind=0;
     configuration.apply();clock_table.apply();
     if(h.event.isValid()){m.now=h.event.now;m.word=h.event.random_word;h.bridge.kind=h.event.op;h.bridge.i0=h.event.i0;h.bridge.i1=h.event.i1;}
     else {hash_table.apply();h.bridge.i0=m.hash[31:16]&(bit<16>)(NENT-1);h.bridge.i1=m.hash[15:0]&(bit<16>)(NENT-1);}
     tag_table.apply();if(m.active==1){slot_table.apply();}m.target=m.profile0;if(m.active==1){m.target=m.profile1;}
     fast_phase.apply();fast_compare.apply();if(m.coin[31:31]==1){fast_round.apply();}pack_table.apply();
m.access=1;if(h.bridge.kind==0){m.access=0;}if(h.bridge.kind==3){m.access=3;}
 }
 if(h.wb.isValid()||h.event.isValid()||(h.ip.isValid()&&h.ports.isValid())){
m.access0=m.access;
 if(h.wb.isValid()){m.salu_word0=h.wb.w0;if(h.wb.mask[0:0]==0){m.access0=1;}}
 else if(h.bridge.kind==3){m.salu_word0=h.event.w0;}
m.access1=m.access;
 if(h.wb.isValid()){m.salu_word1=h.wb.w1;if(h.wb.mask[1:1]==0){m.access1=1;}}
 else if(h.bridge.kind==3){m.salu_word1=h.event.w1;}
access_row0.apply();access_row1.apply();
 }
 if(!h.wb.isValid()&&(h.event.isValid()||(h.ip.isValid()&&h.ports.isValid()))){
 if(h.bridge.kind!=3){
       h.bridge.mask=3;h.bridge.limit=m.limit;h.r0.setValid();h.r1.setValid();
       h.r0.target=m.target;h.r1.target=m.target;
       random_bridge0.apply();random_bridge1.apply();
       h.r0.phase=bridge_phase0.get({m.now[14:0]});h.r1.phase=bridge_phase1.get({m.now[14:0]});
       h.r0.inject=1;h.r1.inject=1;if(h.bridge.kind==2){h.r0.inject=0;h.r1.inject=0;}
h.event.w0=m.old0;h.event.w1=m.old1;m.slow0=1;m.slow1=1;h.bridge.weight=m.weight;

state_projection0.apply();lower_compare0.apply();eg_comparison0.apply();h.r0.age=m.old0[31:16];eg_ages0.apply();
 h.r0.source=h.bridge.profile0;if(m.old0[31:31]==1){h.r0.source=h.bridge.profile1;}
 if(h.bridge.kind==1||h.bridge.kind==3){m.slow0=0;}
 if(h.bridge.kind==0&&m.delta==1024){
   if(m.old0[31:16]==h.bridge.expected){
     if(m.lane0_n_accumulator[31:31]==0){if(m.lower_ok0==1){m.slow0=0;}}
   }
 }
m.live0=0;m.empty0=0;m.same0=0;
 if(h.bridge.kind==2){
 empty_fact0.apply();live_fact0.apply();same_fact0.apply();
 if(m.empty0==1||(m.live0==1&&m.same0==1)){m.slow0=0;}
 }
 state_projection1.apply();lower_compare1.apply();eg_comparison1.apply();h.r1.age=m.old1[31:16];eg_ages1.apply();
 h.r1.source=h.bridge.profile0;if(m.old1[31:31]==1){h.r1.source=h.bridge.profile1;}
 if(h.bridge.kind==1||h.bridge.kind==3){m.slow1=0;}
 if(h.bridge.kind==0&&m.delta==1024){
   if(m.old1[31:16]==h.bridge.expected){
     if(m.lane1_n_accumulator[31:31]==0){if(m.lower_ok1==1){m.slow1=0;}}
   }
 }
m.live1=0;m.empty1=0;m.same1=0;
 if(h.bridge.kind==2){
 empty_fact1.apply();live_fact1.apply();same_fact1.apply();
 if(m.empty1==1||(m.live1==1&&m.same1==1)){m.slow1=0;}
 }
 
return_mask_table.apply();{lane0_time.apply();lane0_decode_shift.apply();if(h.r0.age[14:0]<15w8696){lane0_decode_add.apply();}else{m.lane0_n_mantissa=0;}
            lane0_exponent.apply();
            lane0_term_table_0.apply();lane0_term_table_1.apply();lane0_term_table_2.apply();lane0_term_table_3.apply();lane0_term_table_4.apply();
            lane0_base.apply();lane0_pair_table_0.apply();lane0_pair_table_1.apply();
            lane0_combine_table_0.apply();lane0_combine_table_1.apply();lane0_rotate.apply();lane0_scale.apply();
            h.r0.reserved=m.lane0_n_exponent ++ m.lane0_n_final_exponent;
        }{lane1_time.apply();lane1_decode_shift.apply();if(h.r1.age[14:0]<15w8696){lane1_decode_add.apply();}else{m.lane1_n_mantissa=0;}
            lane1_exponent.apply();
            lane1_term_table_0.apply();lane1_term_table_1.apply();lane1_term_table_2.apply();lane1_term_table_3.apply();lane1_term_table_4.apply();
            lane1_base.apply();lane1_pair_table_0.apply();lane1_pair_table_1.apply();
            lane1_combine_table_0.apply();lane1_combine_table_1.apply();lane1_rotate.apply();lane1_scale.apply();
            h.r1.reserved=m.lane1_n_exponent ++ m.lane1_n_final_exponent;
        }if(m.slow0==1){h.c0.setValid();
 h.c0.word=h.r0.word;h.c0.target=h.r0.target;h.c0.inject=h.r0.inject;h.c0.pad=0;}
if(m.slow1==1){h.c1.setValid();
 h.c1.word=h.r1.word;h.c1.target=h.r1.target;h.c1.inject=h.r1.inject;h.c1.pad=0;}
 }
 forwarding.apply();
   } else {h.bridge.setValid();h.bridge.mask=0;h.bridge.kind=1;forwarding.apply();}
 }
}
control Id(packet_out pkt,inout headers_t h,in metadata_t m,in ingress_intrinsic_metadata_for_deparser_t dm){
 apply{pkt.emit(h.bridge);pkt.emit(h.c0);pkt.emit(h.c1);pkt.emit(h.eth);pkt.emit(h.ip);pkt.emit(h.ports);pkt.emit(h.event);}}
parser Ep(packet_in pkt,out headers_t h,out metadata_t m,out egress_intrinsic_metadata_t im){
 state start {pkt.extract(im);m.active=0;m.profile0=0;m.profile1=1;transition select(pkt.lookahead<bit<8>>()){8w165:mirror_writeback;default:bridge;}}
 state mirror_writeback {pkt.extract(h.replica);transition accept;}
 state bridge {pkt.extract(h.bridge);transition select(h.bridge.mask){0:ethernet;1:row0;2:row1;default:both0;}}
 state row0{pkt.extract(h.c0);h.r0.setValid();h.r0.value_hi=h.c0.phase;h.r0.value_lo=h.c0.state;h.r0.word=h.c0.word;h.r0.target=h.c0.target;h.r0.inject=h.c0.inject;transition ethernet;}state row1{pkt.extract(h.c1);h.r1.setValid();h.r1.value_hi=h.c1.phase;h.r1.value_lo=h.c1.state;h.r1.word=h.c1.word;h.r1.target=h.c1.target;h.r1.inject=h.c1.inject;transition ethernet;}
 state both0{pkt.extract(h.c0);h.r0.setValid();h.r0.value_hi=h.c0.phase;h.r0.value_lo=h.c0.state;h.r0.word=h.c0.word;h.r0.target=h.c0.target;h.r0.inject=h.c0.inject;transition row1;}
 state ethernet{pkt.extract(h.eth);transition select(h.eth.type){0x88b9:event;0x0800:ipv4;default:accept;}}
 state event{pkt.extract(h.event);transition accept;}state ipv4{pkt.extract(h.ip);transition select(h.ip.ihl,h.ip.protocol,h.ip.offset){(5,6,0):ports;(5,17,0):ports;default:accept;}}
 state ports{pkt.extract(h.ports);transition accept;}
}
control Eg(inout headers_t h,inout metadata_t m,in egress_intrinsic_metadata_t im,
 in egress_intrinsic_metadata_from_parser_t pm,inout egress_intrinsic_metadata_for_deparser_t dm,
 inout egress_intrinsic_metadata_for_output_port_t om){    action lane0_prepare_normal(bit<8> shift) {
        m.lane0_scaled=h.r0.value_lo; m.lane0_scaled_hi=h.r0.value_hi;
        m.lane0_shift=shift;
    }
    action lane0_prepare_zero() {
        m.lane0_scaled=h.r0.value_lo << 1; m.lane0_scaled_hi=0; m.lane0_shift=0;
    }
    table lane0_locate {
        key={h.r0.target:exact;h.r0.value_hi:ternary;h.r0.value_lo:ternary;}
        actions={lane0_prepare_normal;lane0_prepare_zero;} size=986; default_action=lane0_prepare_zero();
    }
 action lane0_barrel_1(){m.lane0_scaled=(bit<32>)((m.lane0_scaled_hi ++ m.lane0_scaled) >> 1);
 m.lane0_scaled_hi=m.lane0_scaled_hi >> 1;}
 table lane0_barrel_1_table{actions={lane0_barrel_1;}size=1;default_action=lane0_barrel_1();}
action lane0_barrel_2(){m.lane0_scaled=(bit<32>)((m.lane0_scaled_hi ++ m.lane0_scaled) >> 2);
 m.lane0_scaled_hi=m.lane0_scaled_hi >> 2;}
 table lane0_barrel_2_table{actions={lane0_barrel_2;}size=1;default_action=lane0_barrel_2();}
action lane0_barrel_4(){m.lane0_scaled=(bit<32>)((m.lane0_scaled_hi ++ m.lane0_scaled) >> 4);
 m.lane0_scaled_hi=m.lane0_scaled_hi >> 4;}
 table lane0_barrel_4_table{actions={lane0_barrel_4;}size=1;default_action=lane0_barrel_4();}
action lane0_barrel_8(){m.lane0_scaled=(bit<32>)((m.lane0_scaled_hi ++ m.lane0_scaled) >> 8);
 m.lane0_scaled_hi=m.lane0_scaled_hi >> 8;}
 table lane0_barrel_8_table{actions={lane0_barrel_8;}size=1;default_action=lane0_barrel_8();}
action lane0_barrel_16(){m.lane0_scaled=(bit<32>)((m.lane0_scaled_hi ++ m.lane0_scaled) >> 16);
 m.lane0_scaled_hi=m.lane0_scaled_hi >> 16;}
 table lane0_barrel_16_table{actions={lane0_barrel_16;}size=1;default_action=lane0_barrel_16();}
action lane0_normalize_value(bit<32> negative_base) { m.lane0_normal=m.lane0_scaled+negative_base; }
    action lane0_normalize_cap() { m.lane0_normal=0; }
    table lane0_normalize {
        key={h.r0.target:exact;h.r0.value_hi:ternary;h.r0.value_lo:ternary;}
        actions={lane0_normalize_value;lane0_normalize_cap;} size=986; default_action=lane0_normalize_cap();
    }
    action lane0_split_value() { m.lane0_quotient=m.lane0_normal >> 17; m.lane0_raw=m.lane0_normal & 32w131071; }
    table lane0_split { actions={lane0_split_value;} size=1; default_action=lane0_split_value(); }
    action lane0_interval_value(bit<32> start, bit<32> upper) {
        h.r0.low=m.lane0_quotient+start; h.r0.high=m.lane0_quotient+upper;
    }
    action lane0_interval_cap() { h.r0.low=65535; h.r0.high=65535; }
    table lane0_interval {
        key={h.r0.target:exact;h.r0.value_hi:ternary;h.r0.value_lo:ternary;}
        actions={lane0_interval_value;lane0_interval_cap;} size=986; default_action=lane0_interval_cap();
    }
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) choice_word0;
    action lane0_prepare_choice() { m.lane0_coin_delta=choice_word0.get({h.r0.word})-m.lane0_raw; m.lane0_rounded=m.lane0_raw+1; }
    table lane0_choice{key={h.r0.target:exact;}actions={lane0_prepare_choice;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane0_prepare_choice();8w1:lane0_prepare_choice();8w2:lane0_prepare_choice();}}
    action lane0_report_threshold() { h.r0.threshold=m.lane0_rounded >> 1; }
    table lane0_threshold { actions={lane0_report_threshold;} size=1; default_action=lane0_report_threshold(); }

    action lane1_prepare_normal(bit<8> shift) {
        m.lane1_scaled=h.r1.value_lo; m.lane1_scaled_hi=h.r1.value_hi;
        m.lane1_shift=shift;
    }
    action lane1_prepare_zero() {
        m.lane1_scaled=h.r1.value_lo << 1; m.lane1_scaled_hi=0; m.lane1_shift=0;
    }
    table lane1_locate {
        key={h.r1.target:exact;h.r1.value_hi:ternary;h.r1.value_lo:ternary;}
        actions={lane1_prepare_normal;lane1_prepare_zero;} size=986; default_action=lane1_prepare_zero();
    }
 action lane1_barrel_1(){m.lane1_scaled=(bit<32>)((m.lane1_scaled_hi ++ m.lane1_scaled) >> 1);
 m.lane1_scaled_hi=m.lane1_scaled_hi >> 1;}
 table lane1_barrel_1_table{actions={lane1_barrel_1;}size=1;default_action=lane1_barrel_1();}
action lane1_barrel_2(){m.lane1_scaled=(bit<32>)((m.lane1_scaled_hi ++ m.lane1_scaled) >> 2);
 m.lane1_scaled_hi=m.lane1_scaled_hi >> 2;}
 table lane1_barrel_2_table{actions={lane1_barrel_2;}size=1;default_action=lane1_barrel_2();}
action lane1_barrel_4(){m.lane1_scaled=(bit<32>)((m.lane1_scaled_hi ++ m.lane1_scaled) >> 4);
 m.lane1_scaled_hi=m.lane1_scaled_hi >> 4;}
 table lane1_barrel_4_table{actions={lane1_barrel_4;}size=1;default_action=lane1_barrel_4();}
action lane1_barrel_8(){m.lane1_scaled=(bit<32>)((m.lane1_scaled_hi ++ m.lane1_scaled) >> 8);
 m.lane1_scaled_hi=m.lane1_scaled_hi >> 8;}
 table lane1_barrel_8_table{actions={lane1_barrel_8;}size=1;default_action=lane1_barrel_8();}
action lane1_barrel_16(){m.lane1_scaled=(bit<32>)((m.lane1_scaled_hi ++ m.lane1_scaled) >> 16);
 m.lane1_scaled_hi=m.lane1_scaled_hi >> 16;}
 table lane1_barrel_16_table{actions={lane1_barrel_16;}size=1;default_action=lane1_barrel_16();}
action lane1_normalize_value(bit<32> negative_base) { m.lane1_normal=m.lane1_scaled+negative_base; }
    action lane1_normalize_cap() { m.lane1_normal=0; }
    table lane1_normalize {
        key={h.r1.target:exact;h.r1.value_hi:ternary;h.r1.value_lo:ternary;}
        actions={lane1_normalize_value;lane1_normalize_cap;} size=986; default_action=lane1_normalize_cap();
    }
    action lane1_split_value() { m.lane1_quotient=m.lane1_normal >> 17; m.lane1_raw=m.lane1_normal & 32w131071; }
    table lane1_split { actions={lane1_split_value;} size=1; default_action=lane1_split_value(); }
    action lane1_interval_value(bit<32> start, bit<32> upper) {
        h.r1.low=m.lane1_quotient+start; h.r1.high=m.lane1_quotient+upper;
    }
    action lane1_interval_cap() { h.r1.low=65535; h.r1.high=65535; }
    table lane1_interval {
        key={h.r1.target:exact;h.r1.value_hi:ternary;h.r1.value_lo:ternary;}
        actions={lane1_interval_value;lane1_interval_cap;} size=986; default_action=lane1_interval_cap();
    }
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) choice_word1;
    action lane1_prepare_choice() { m.lane1_coin_delta=choice_word1.get({h.r1.word})-m.lane1_raw; m.lane1_rounded=m.lane1_raw+1; }
    table lane1_choice{key={h.r1.target:exact;}actions={lane1_prepare_choice;NoAction;}size=3;const default_action=NoAction();const entries={8w0:lane1_prepare_choice();8w1:lane1_prepare_choice();8w2:lane1_prepare_choice();}}
    action lane1_report_threshold() { h.r1.threshold=m.lane1_rounded >> 1; }
    table lane1_threshold { actions={lane1_report_threshold;} size=1; default_action=lane1_report_threshold(); }

Hash<bit<32>>(HashAlgorithm_t.IDENTITY) injection_word0;
 Hash<bit<8>>(HashAlgorithm_t.IDENTITY) carry_bit0;
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) writeback_tag0;
 action pack_word0(){h.wb.w0=writeback_tag0.get({h.bridge.expected,16w0})+h.r0.result;}
 table pack_result0{key={h.r0.target:exact;}actions={pack_word0;NoAction;}size=3;const default_action=NoAction();const entries={8w0:pack_word0();8w1:pack_word0();8w2:pack_word0();}}
 action inject0(){h.r0.value_lo=h.r0.value_lo+injection_word0.get({h.bridge.weight});}
 table injection0{key={h.r0.inject:exact;}actions={inject0;NoAction;}size=2;
 const default_action=NoAction();const entries={8w0:NoAction();8w1:inject0();}}
Hash<bit<32>>(HashAlgorithm_t.IDENTITY) injection_word1;
 Hash<bit<8>>(HashAlgorithm_t.IDENTITY) carry_bit1;
 Hash<bit<32>>(HashAlgorithm_t.IDENTITY) writeback_tag1;
 action pack_word1(){h.wb.w1=writeback_tag1.get({h.bridge.expected,16w0})+h.r1.result;}
 table pack_result1{key={h.r1.target:exact;}actions={pack_word1;NoAction;}size=3;const default_action=NoAction();const entries={8w0:pack_word1();8w1:pack_word1();8w2:pack_word1();}}
 action inject1(){h.r1.value_lo=h.r1.value_lo+injection_word1.get({h.bridge.weight});}
 table injection1{key={h.r1.inject:exact;}actions={inject1;NoAction;}size=2;
 const default_action=NoAction();const entries={8w0:NoAction();8w1:inject1();}}
action capture_sign0(){m.lane0_n_mode0=carry_bit0.get({7w0,h.r0.value_lo[31:31]});}
 table sign_capture0{key={h.r0.target:exact;}actions={capture_sign0;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:capture_sign0();8w1:capture_sign0();8w2:capture_sign0();}}
action capture_sign1(){m.lane1_n_mode0=carry_bit1.get({7w0,h.r1.value_lo[31:31]});}
 table sign_capture1{key={h.r1.target:exact;}actions={capture_sign1;NoAction;}size=3;const default_action=NoAction();
 const entries={8w0:capture_sign1();8w1:capture_sign1();8w2:capture_sign1();}}
 Counter<bit<64>,bit<8>>(4,CounterType_t.PACKETS_AND_BYTES) hardware_masks;
 apply{if(h.bridge.isValid()){hardware_masks.count(h.bridge.mask);
if(h.r0.isValid()){sign_capture0.apply();injection0.apply();
 if(m.lane0_n_mode0==1&&h.r0.value_lo[31:31]==0){h.r0.value_hi=h.r0.value_hi+1;}}if(h.r1.isValid()){sign_capture1.apply();injection1.apply();
 if(m.lane1_n_mode0==1&&h.r1.value_lo[31:31]==0){h.r1.value_hi=h.r1.value_hi+1;}}if(h.r0.isValid()){
            lane0_locate.apply();if((m.lane0_shift & 8w1)!=0){lane0_barrel_1_table.apply();}if((m.lane0_shift & 8w2)!=0){lane0_barrel_2_table.apply();}if((m.lane0_shift & 8w4)!=0){lane0_barrel_4_table.apply();}if((m.lane0_shift & 8w8)!=0){lane0_barrel_8_table.apply();}if((m.lane0_shift & 8w16)!=0){lane0_barrel_16_table.apply();}
            lane0_normalize.apply(); lane0_split.apply(); lane0_interval.apply(); lane0_choice.apply(); lane0_threshold.apply();
            h.r0.result=h.r0.low;
            if (m.lane0_coin_delta[31:31]==1) { h.r0.result=h.r0.high; }
        }
if(h.r1.isValid()){
            lane1_locate.apply();if((m.lane1_shift & 8w1)!=0){lane1_barrel_1_table.apply();}if((m.lane1_shift & 8w2)!=0){lane1_barrel_2_table.apply();}if((m.lane1_shift & 8w4)!=0){lane1_barrel_4_table.apply();}if((m.lane1_shift & 8w8)!=0){lane1_barrel_8_table.apply();}if((m.lane1_shift & 8w16)!=0){lane1_barrel_16_table.apply();}
            lane1_normalize.apply(); lane1_split.apply(); lane1_interval.apply(); lane1_choice.apply(); lane1_threshold.apply();
            h.r1.result=h.r1.low;
            if (m.lane1_coin_delta[31:31]==1) { h.r1.result=h.r1.high; }
        }
 if(h.bridge.mask!=0){h.wb.setValid();h.wb.marker=8w165;h.wb.mask=h.bridge.mask;
 h.wb.i0=h.bridge.i0;h.wb.i1=h.bridge.i1;h.wb.pad0=0;
 h.wb.w0=0;h.wb.w1=0;
 if(h.r0.isValid()){pack_result0.apply();}if(h.r1.isValid()){pack_result1.apply();}dm.mirror_type=1;dm.mirror_io_select=1;}
 if(h.event.isValid()){h.event.mask=h.bridge.mask;}
 }}
}

control Ed(packet_out pkt,inout headers_t h,in metadata_t m,in egress_intrinsic_metadata_for_deparser_t dm){
 Mirror() mirror;
 apply{if(dm.mirror_type==1){mirror.emit<writeback_t>(h.bridge.session,h.wb);}
 pkt.emit(h.replica);pkt.emit(h.eth);pkt.emit(h.ip);pkt.emit(h.ports);pkt.emit(h.event);}
}
Pipeline(Ip(),Ig(),Id(),Ep(),Eg(),Ed()) pipe;
Switch(pipe) main;
