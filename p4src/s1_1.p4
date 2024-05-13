/* -*- P4_16 -*- */

#include <core.p4>
#include <v1model.p4>


/*
 * Standard ethernet header
 */
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

/*
 * This is a custom protocol header for the calculator. We'll use
 * ethertype 0x1234 for is (see parser)
 */
const bit<16> P4CALC_ETYPE = 0x1234;
const bit<8>  P4CALC_P     = 0x50;   // 'P'
const bit<8>  P4CALC_4     = 0x34;   // '4'
const bit<8>  P4CALC_VER   = 0x01;   // v0.1

const bit<32> replication = 0x01;

const bit<40> FILTER_l0 = 0x88272881fe;
const bit<40> FILTER_l1 = 0x0085718781;
const bit<40> FILTER_l2 = 0x850075fe81;
const bit<40> FILTER_l3 = 0x81fefd9364;
const bit<40> FILTER_l4 = 0x5cf9820081;
const bit<40> FILTER_l5 = 0x36813ca386;
const bit<40> FILTER_l6 = 0xfe01868167;
const bit<40> FILTER_l7 = 0x9581086e90;

header p4calc_t {
    bit<8>      p;
    bit<8>      four;
    bit<8>      ver;


//s1 input
    bit<32>     s1_index;
    bit<32>     s1_max_pool_index;
    bit<40>     s1_input_data;
    
// s1 output
    bit<32>     s1_replication;
    bit<64>     s1_res;

//s2 output
    bit<32>     s2_replication;
    bit<128>    s2_res;
    bit<32>     s2_index;

//s3 output
    bit<32>     s3_replication;
    bit<104>    s3_res;

//s4 output
    bit<32>     s4_replication;
    bit<200>    s4_res;

//s5 output
    bit<8>    s5_res;
}


struct headers {
    ethernet_t   ethernet;
    p4calc_t     p4calc;
}


struct ingress_metadata_t {
    bit<32> nhop_ipv4;
}

struct metadata {
        ingress_metadata_t   ingress_metadata;
}

/*************************************************************************
 ***********************  P A R S E R  ***********************************
 *************************************************************************/
parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            P4CALC_ETYPE : check_p4calc;
            default      : accept;
        }
    }

    state check_p4calc {
        transition select(packet.lookahead<p4calc_t>().p,
        packet.lookahead<p4calc_t>().four,
        packet.lookahead<p4calc_t>().ver) {
            (P4CALC_P, P4CALC_4, P4CALC_VER) : parse_p4calc;
            default                          : accept;
        }
    }

    state parse_p4calc {
        packet.extract(hdr.p4calc);
        transition accept;
    }
}

/*************************************************************************
 ************   C H E C K S U M    V E R I F I C A T I O N   *************
 *************************************************************************/
control MyVerifyChecksum(inout headers hdr,
                         inout metadata meta) {
    apply { }
}

/*************************************************************************
 **************  I N G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    register<bit<8>>(1296) max_pool_registry;

    /**
    * Number of operations:
     * - Addition: 7
     * - Read: 8
     *
     *
     * @param index The index of the broadcast message.
     */
    action send_broadcast(in bit<32> index) {

        max_pool_registry.read(hdr.p4calc.s1_res[7:0]    ,index);
        max_pool_registry.read(hdr.p4calc.s1_res[15:8]   ,index + 1);
        max_pool_registry.read(hdr.p4calc.s1_res[23:16]  ,index + 2);
        max_pool_registry.read(hdr.p4calc.s1_res[31:24]  ,index + 3);
        max_pool_registry.read(hdr.p4calc.s1_res[39:32]  ,index + 4);
        max_pool_registry.read(hdr.p4calc.s1_res[47:40]  ,index + 5);
        max_pool_registry.read(hdr.p4calc.s1_res[55:48]  ,index + 6);
        max_pool_registry.read(hdr.p4calc.s1_res[63:56]  ,index + 7);

        hdr.p4calc.s1_replication = replication;
    }


    /**
     * 
     * Number of operations:
     * - Multiplication: 5
     * - Addition: 4
     * - Read: 1
     * - Write: 1
     * - Compare: 1

     * Action to calculate convolution and max pooling.
     *
     * @param f the filter.
     * @param index The index of the max pooling.
     */
    action conv_maxpool_calc(in bit<40> f, in bit<32> index ) {
        bit<8> conv =
        hdr.p4calc.s1_input_data[7:0]   * f[7:0]   +
        hdr.p4calc.s1_input_data[15:8]  * f[15:8]  +
        hdr.p4calc.s1_input_data[23:16] * f[23:16] +
        hdr.p4calc.s1_input_data[31:24] * f[31:24] +
        hdr.p4calc.s1_input_data[39:32] * f[39:32];


        bit<8> maxpool;
        max_pool_registry.read(maxpool, index);
        if (conv > maxpool) {
            maxpool = conv;
        }
        max_pool_registry.write(index, maxpool);
    }

    /**
     * 
     * Number of operations:
     * - conv_maxpool_calc: 8
     * - Multiplication: 1
     * - Addition: 7
     * 
     * Performs the calculation operation on 8 Filters.
     *
     */
    action operation_calc() {
        bit<32> index = hdr.p4calc.s1_max_pool_index * 8;

        conv_maxpool_calc(FILTER_l0, index);
        conv_maxpool_calc(FILTER_l1, index + 1);
        conv_maxpool_calc(FILTER_l2, index + 2);
        conv_maxpool_calc(FILTER_l3, index + 3);
        conv_maxpool_calc(FILTER_l4, index + 4);
        conv_maxpool_calc(FILTER_l5, index + 5);
        conv_maxpool_calc(FILTER_l6, index + 6);
        conv_maxpool_calc(FILTER_l7, index + 7);
        mark_to_drop(standard_metadata);
    }
    /**
     * 
     * Number of operations:
     * - conv_maxpool_calc: 8
     * - send_broadcast: 1
     * - Multiplication: 1
     * - Addition: 7
     * 
     * Performs the calculation operation on 8 Filters.
     *
     */
    action operation_calcAndSend() {
        bit<32> index = hdr.p4calc.s1_max_pool_index * 8;

        conv_maxpool_calc(FILTER_l0, index);
        conv_maxpool_calc(FILTER_l1, index + 1);
        conv_maxpool_calc(FILTER_l2, index + 2);
        conv_maxpool_calc(FILTER_l3, index + 3);
        conv_maxpool_calc(FILTER_l4, index + 4);
        conv_maxpool_calc(FILTER_l5, index + 5);
        conv_maxpool_calc(FILTER_l6, index + 6);
        conv_maxpool_calc(FILTER_l7, index + 7);
        
        send_broadcast(index);
    }

    action operation_drop() {
        mark_to_drop(standard_metadata);
    }
    
    table calculate {
        key = {
            hdr.p4calc.s1_index        : exact;
        }
        actions = {
            operation_calc;
            operation_calcAndSend;
            operation_drop;
        }
        const default_action = operation_drop();
        const entries = {
            0x0: operation_calc();
            0x1: operation_calc();
            0x2: operation_calc();
            0x3: operation_calc();
            0x4: operation_calcAndSend();
            0x5: operation_calc();
            0x6: operation_calc();
            0x7: operation_calc();
            0x8: operation_calc();
            0x9: operation_calcAndSend();
            0xa: operation_calc();
            0xb: operation_calc();
            0xc: operation_calc();
            0xd: operation_calc();
            0xe: operation_calcAndSend();
            0xf: operation_calc();
            0x10: operation_calc();
            0x11: operation_calc();
            0x12: operation_calc();
            0x13: operation_calcAndSend();
            0x14: operation_calc();
            0x15: operation_calc();
            0x16: operation_calc();
            0x17: operation_calc();
            0x18: operation_calcAndSend();
            0x19: operation_calc();
            0x1a: operation_calc();
            0x1b: operation_calc();
            0x1c: operation_calc();
            0x1d: operation_calcAndSend();
            0x1e: operation_calc();
            0x1f: operation_calc();
            0x20: operation_calc();
            0x21: operation_calc();
            0x22: operation_calcAndSend();
            0x23: operation_calc();
            0x24: operation_calc();
            0x25: operation_calc();
            0x26: operation_calc();
            0x27: operation_calcAndSend();
            0x28: operation_calc();
            0x29: operation_calc();
            0x2a: operation_calc();
            0x2b: operation_calc();
            0x2c: operation_calcAndSend();
            0x2d: operation_calc();
            0x2e: operation_calc();
            0x2f: operation_calc();
            0x30: operation_calc();
            0x31: operation_calcAndSend();
            0x32: operation_calc();
            0x33: operation_calc();
            0x34: operation_calc();
            0x35: operation_calc();
            0x36: operation_calcAndSend();
            0x37: operation_calc();
            0x38: operation_calc();
            0x39: operation_calc();
            0x3a: operation_calc();
            0x3b: operation_calcAndSend();
            0x3c: operation_calc();
            0x3d: operation_calc();
            0x3e: operation_calc();
            0x3f: operation_calc();
            0x40: operation_calcAndSend();
            0x41: operation_calc();
            0x42: operation_calc();
            0x43: operation_calc();
            0x44: operation_calc();
            0x45: operation_calcAndSend();
            0x46: operation_calc();
            0x47: operation_calc();
            0x48: operation_calc();
            0x49: operation_calc();
            0x4a: operation_calcAndSend();
            0x4b: operation_calc();
            0x4c: operation_calc();
            0x4d: operation_calc();
            0x4e: operation_calc();
            0x4f: operation_calcAndSend();
            0x50: operation_calc();
            0x51: operation_calc();
            0x52: operation_calc();
            0x53: operation_calc();
            0x54: operation_calcAndSend();
            0x55: operation_calc();
            0x56: operation_calc();
            0x57: operation_calc();
            0x58: operation_calc();
            0x59: operation_calcAndSend();
            0x5a: operation_calc();
            0x5b: operation_calc();
            0x5c: operation_calc();
            0x5d: operation_calc();
            0x5e: operation_calcAndSend();
            0x5f: operation_calc();
            0x60: operation_calc();
            0x61: operation_calc();
            0x62: operation_calc();
            0x63: operation_calcAndSend();
            0x64: operation_calc();
            0x65: operation_calc();
            0x66: operation_calc();
            0x67: operation_calc();
            0x68: operation_calcAndSend();
            0x69: operation_calc();
            0x6a: operation_calc();
            0x6b: operation_calc();
            0x6c: operation_calc();
            0x6d: operation_calcAndSend();
            0x6e: operation_calc();
            0x6f: operation_calc();
            0x70: operation_calc();
            0x71: operation_calc();
            0x72: operation_calcAndSend();
            0x73: operation_calc();
            0x74: operation_calc();
            0x75: operation_calc();
            0x76: operation_calc();
            0x77: operation_calcAndSend();
            0x78: operation_calc();
            0x79: operation_calc();
            0x7a: operation_calc();
            0x7b: operation_calc();
            0x7c: operation_calcAndSend();
            0x7d: operation_calc();
            0x7e: operation_calc();
            0x7f: operation_calc();
            0x80: operation_calc();
            0x81: operation_calcAndSend();
            0x82: operation_calc();
            0x83: operation_calc();
            0x84: operation_calc();
            0x85: operation_calc();
            0x86: operation_calcAndSend();
            0x87: operation_calc();
            0x88: operation_calc();
            0x89: operation_calc();
            0x8a: operation_calc();
            0x8b: operation_calcAndSend();
            0x8c: operation_calc();
            0x8d: operation_calc();
            0x8e: operation_calc();
            0x8f: operation_calc();
            0x90: operation_calcAndSend();
            0x91: operation_calc();
            0x92: operation_calc();
            0x93: operation_calc();
            0x94: operation_calc();
            0x95: operation_calcAndSend();
            0x96: operation_calc();
            0x97: operation_calc();
            0x98: operation_calc();
            0x99: operation_calc();
            0x9a: operation_calcAndSend();
            0x9b: operation_calc();
            0x9c: operation_calc();
            0x9d: operation_calc();
            0x9e: operation_calc();
            0x9f: operation_calcAndSend();
            0xa0: operation_calc();
            0xa1: operation_calc();
            0xa2: operation_calc();
            0xa3: operation_calc();
            0xa4: operation_calcAndSend();
            0xa5: operation_calc();
            0xa6: operation_calc();
            0xa7: operation_calc();
            0xa8: operation_calc();
            0xa9: operation_calcAndSend();
            0xaa: operation_calc();
            0xab: operation_calc();
            0xac: operation_calc();
            0xad: operation_calc();
            0xae: operation_calcAndSend();
            0xaf: operation_calc();
            0xb0: operation_calc();
            0xb1: operation_calc();
            0xb2: operation_calc();
            0xb3: operation_calcAndSend();
            0xb4: operation_calc();
            0xb5: operation_calc();
            0xb6: operation_calc();
            0xb7: operation_calc();
            0xb8: operation_calcAndSend();
            0xb9: operation_calc();
            0xba: operation_calc();
            0xbb: operation_calc();
            0xbc: operation_calc();
            0xbd: operation_calcAndSend();
            0xbe: operation_calc();
            0xbf: operation_calc();
            0xc0: operation_calc();
            0xc1: operation_calc();
            0xc2: operation_calcAndSend();
            0xc3: operation_calc();
            0xc4: operation_calc();
            0xc5: operation_calc();
            0xc6: operation_calc();
            0xc7: operation_calcAndSend();
            0xc8: operation_calc();
            0xc9: operation_calc();
            0xca: operation_calc();
            0xcb: operation_calc();
            0xcc: operation_calcAndSend();
            0xcd: operation_calc();
            0xce: operation_calc();
            0xcf: operation_calc();
            0xd0: operation_calc();
            0xd1: operation_calcAndSend();
            0xd2: operation_calc();
            0xd3: operation_calc();
            0xd4: operation_calc();
            0xd5: operation_calc();
            0xd6: operation_calcAndSend();
            0xd7: operation_calc();
            0xd8: operation_calc();
            0xd9: operation_calc();
            0xda: operation_calc();
            0xdb: operation_calcAndSend();
            0xdc: operation_calc();
            0xdd: operation_calc();
            0xde: operation_calc();
            0xdf: operation_calc();
            0xe0: operation_calcAndSend();
            0xe1: operation_calc();
            0xe2: operation_calc();
            0xe3: operation_calc();
            0xe4: operation_calc();
            0xe5: operation_calcAndSend();
            0xe6: operation_calc();
            0xe7: operation_calc();
            0xe8: operation_calc();
            0xe9: operation_calc();
            0xea: operation_calcAndSend();
            0xeb: operation_calc();
            0xec: operation_calc();
            0xed: operation_calc();
            0xee: operation_calc();
            0xef: operation_calcAndSend();
            0xf0: operation_calc();
            0xf1: operation_calc();
            0xf2: operation_calc();
            0xf3: operation_calc();
            0xf4: operation_calcAndSend();
            0xf5: operation_calc();
            0xf6: operation_calc();
            0xf7: operation_calc();
            0xf8: operation_calc();
            0xf9: operation_calcAndSend();
            0xfa: operation_calc();
            0xfb: operation_calc();
            0xfc: operation_calc();
            0xfd: operation_calc();
            0xfe: operation_calcAndSend();
            0xff: operation_calc();
            0x100: operation_calc();
            0x101: operation_calc();
            0x102: operation_calc();
            0x103: operation_calcAndSend();
            0x104: operation_calc();
            0x105: operation_calc();
            0x106: operation_calc();
            0x107: operation_calc();
            0x108: operation_calcAndSend();
            0x109: operation_calc();
            0x10a: operation_calc();
            0x10b: operation_calc();
            0x10c: operation_calc();
            0x10d: operation_calcAndSend();
            0x10e: operation_calc();
            0x10f: operation_calc();
            0x110: operation_calc();
            0x111: operation_calc();
            0x112: operation_calcAndSend();
            0x113: operation_calc();
            0x114: operation_calc();
            0x115: operation_calc();
            0x116: operation_calc();
            0x117: operation_calcAndSend();
            0x118: operation_calc();
            0x119: operation_calc();
            0x11a: operation_calc();
            0x11b: operation_calc();
            0x11c: operation_calcAndSend();
            0x11d: operation_calc();
            0x11e: operation_calc();
            0x11f: operation_calc();
            0x120: operation_calc();
            0x121: operation_calcAndSend();
            0x122: operation_calc();
            0x123: operation_calc();
            0x124: operation_calc();
            0x125: operation_calc();
            0x126: operation_calcAndSend();
            0x127: operation_calc();
            0x128: operation_calc();
            0x129: operation_calc();
            0x12a: operation_calc();
            0x12b: operation_calcAndSend();
            0x12c: operation_calc();
            0x12d: operation_calc();
            0x12e: operation_calc();
            0x12f: operation_calc();
            0x130: operation_calcAndSend();
            0x131: operation_calc();
            0x132: operation_calc();
            0x133: operation_calc();
            0x134: operation_calc();
            0x135: operation_calcAndSend();
            0x136: operation_calc();
            0x137: operation_calc();
            0x138: operation_calc();
            0x139: operation_calc();
            0x13a: operation_calcAndSend();
            0x13b: operation_calc();
            0x13c: operation_calc();
            0x13d: operation_calc();
            0x13e: operation_calc();
            0x13f: operation_calcAndSend();
            0x140: operation_calc();
            0x141: operation_calc();
            0x142: operation_calc();
            0x143: operation_calc();
            0x144: operation_calcAndSend();
            0x145: operation_calc();
            0x146: operation_calc();
            0x147: operation_calc();
            0x148: operation_calc();
            0x149: operation_calcAndSend();
            0x14a: operation_calc();
            0x14b: operation_calc();
            0x14c: operation_calc();
            0x14d: operation_calc();
            0x14e: operation_calcAndSend();
            0x14f: operation_calc();
            0x150: operation_calc();
            0x151: operation_calc();
            0x152: operation_calc();
            0x153: operation_calcAndSend();
            0x154: operation_calc();
            0x155: operation_calc();
            0x156: operation_calc();
            0x157: operation_calc();
            0x158: operation_calcAndSend();
            0x159: operation_calc();
            0x15a: operation_calc();
            0x15b: operation_calc();
            0x15c: operation_calc();
            0x15d: operation_calcAndSend();
            0x15e: operation_calc();
            0x15f: operation_calc();
            0x160: operation_calc();
            0x161: operation_calc();
            0x162: operation_calcAndSend();
            0x163: operation_calc();
            0x164: operation_calc();
            0x165: operation_calc();
            0x166: operation_calc();
            0x167: operation_calcAndSend();
            0x168: operation_calc();
            0x169: operation_calc();
            0x16a: operation_calc();
            0x16b: operation_calc();
            0x16c: operation_calcAndSend();
            0x16d: operation_calc();
            0x16e: operation_calc();
            0x16f: operation_calc();
            0x170: operation_calc();
            0x171: operation_calcAndSend();
            0x172: operation_calc();
            0x173: operation_calc();
            0x174: operation_calc();
            0x175: operation_calc();
            0x176: operation_calcAndSend();
            0x177: operation_calc();
            0x178: operation_calc();
            0x179: operation_calc();
            0x17a: operation_calc();
            0x17b: operation_calcAndSend();
            0x17c: operation_calc();
            0x17d: operation_calc();
            0x17e: operation_calc();
            0x17f: operation_calc();
            0x180: operation_calcAndSend();
            0x181: operation_calc();
            0x182: operation_calc();
            0x183: operation_calc();
            0x184: operation_calc();
            0x185: operation_calcAndSend();
            0x186: operation_calc();
            0x187: operation_calc();
            0x188: operation_calc();
            0x189: operation_calc();
            0x18a: operation_calcAndSend();
            0x18b: operation_calc();
            0x18c: operation_calc();
            0x18d: operation_calc();
            0x18e: operation_calc();
            0x18f: operation_calcAndSend();
            0x190: operation_calc();
            0x191: operation_calc();
            0x192: operation_calc();
            0x193: operation_calc();
            0x194: operation_calcAndSend();
            0x195: operation_calc();
            0x196: operation_calc();
            0x197: operation_calc();
            0x198: operation_calc();
            0x199: operation_calcAndSend();
            0x19a: operation_calc();
            0x19b: operation_calc();
            0x19c: operation_calc();
            0x19d: operation_calc();
            0x19e: operation_calcAndSend();
            0x19f: operation_calc();
            0x1a0: operation_calc();
            0x1a1: operation_calc();
            0x1a2: operation_calc();
            0x1a3: operation_calcAndSend();
            0x1a4: operation_calc();
            0x1a5: operation_calc();
            0x1a6: operation_calc();
            0x1a7: operation_calc();
            0x1a8: operation_calcAndSend();
            0x1a9: operation_calc();
            0x1aa: operation_calc();
            0x1ab: operation_calc();
            0x1ac: operation_calc();
            0x1ad: operation_calcAndSend();
            0x1ae: operation_calc();
            0x1af: operation_calc();
            0x1b0: operation_calc();
            0x1b1: operation_calc();
            0x1b2: operation_calcAndSend();
            0x1b3: operation_calc();
            0x1b4: operation_calc();
            0x1b5: operation_calc();
            0x1b6: operation_calc();
            0x1b7: operation_calcAndSend();
            0x1b8: operation_calc();
            0x1b9: operation_calc();
            0x1ba: operation_calc();
            0x1bb: operation_calc();
            0x1bc: operation_calcAndSend();
            0x1bd: operation_calc();
            0x1be: operation_calc();
            0x1bf: operation_calc();
            0x1c0: operation_calc();
            0x1c1: operation_calcAndSend();
            0x1c2: operation_calc();
            0x1c3: operation_calc();
            0x1c4: operation_calc();
            0x1c5: operation_calc();
            0x1c6: operation_calcAndSend();
            0x1c7: operation_calc();
            0x1c8: operation_calc();
            0x1c9: operation_calc();
            0x1ca: operation_calc();
            0x1cb: operation_calcAndSend();
            0x1cc: operation_calc();
            0x1cd: operation_calc();
            0x1ce: operation_calc();
            0x1cf: operation_calc();
            0x1d0: operation_calcAndSend();
            0x1d1: operation_calc();
            0x1d2: operation_calc();
            0x1d3: operation_calc();
            0x1d4: operation_calc();
            0x1d5: operation_calcAndSend();
            0x1d6: operation_calc();
            0x1d7: operation_calc();
            0x1d8: operation_calc();
            0x1d9: operation_calc();
            0x1da: operation_calcAndSend();
            0x1db: operation_calc();
            0x1dc: operation_calc();
            0x1dd: operation_calc();
            0x1de: operation_calc();
            0x1df: operation_calcAndSend();
            0x1e0: operation_calc();
            0x1e1: operation_calc();
            0x1e2: operation_calc();
            0x1e3: operation_calc();
            0x1e4: operation_calcAndSend();
            0x1e5: operation_calc();
            0x1e6: operation_calc();
            0x1e7: operation_calc();
            0x1e8: operation_calc();
            0x1e9: operation_calcAndSend();
            0x1ea: operation_calc();
            0x1eb: operation_calc();
            0x1ec: operation_calc();
            0x1ed: operation_calc();
            0x1ee: operation_calcAndSend();
            0x1ef: operation_calc();
            0x1f0: operation_calc();
            0x1f1: operation_calc();
            0x1f2: operation_calc();
            0x1f3: operation_calcAndSend();
            0x1f4: operation_calc();
            0x1f5: operation_calc();
            0x1f6: operation_calc();
            0x1f7: operation_calc();
            0x1f8: operation_calcAndSend();
            0x1f9: operation_calc();
            0x1fa: operation_calc();
            0x1fb: operation_calc();
            0x1fc: operation_calc();
            0x1fd: operation_calcAndSend();
            0x1fe: operation_calc();
            0x1ff: operation_calc();
            0x200: operation_calc();
            0x201: operation_calc();
            0x202: operation_calcAndSend();
            0x203: operation_calc();
            0x204: operation_calc();
            0x205: operation_calc();
            0x206: operation_calc();
            0x207: operation_calcAndSend();
            0x208: operation_calc();
            0x209: operation_calc();
            0x20a: operation_calc();
            0x20b: operation_calc();
            0x20c: operation_calcAndSend();
            0x20d: operation_calc();
            0x20e: operation_calc();
            0x20f: operation_calc();
            0x210: operation_calc();
            0x211: operation_calcAndSend();
            0x212: operation_calc();
            0x213: operation_calc();
            0x214: operation_calc();
            0x215: operation_calc();
            0x216: operation_calcAndSend();
            0x217: operation_calc();
            0x218: operation_calc();
            0x219: operation_calc();
            0x21a: operation_calc();
            0x21b: operation_calcAndSend();
            0x21c: operation_calc();
            0x21d: operation_calc();
            0x21e: operation_calc();
            0x21f: operation_calc();
            0x220: operation_calcAndSend();
            0x221: operation_calc();
            0x222: operation_calc();
            0x223: operation_calc();
            0x224: operation_calc();
            0x225: operation_calcAndSend();
            0x226: operation_calc();
            0x227: operation_calc();
            0x228: operation_calc();
            0x229: operation_calc();
            0x22a: operation_calcAndSend();
            0x22b: operation_calc();
            0x22c: operation_calc();
            0x22d: operation_calc();
            0x22e: operation_calc();
            0x22f: operation_calcAndSend();
            0x230: operation_calc();
            0x231: operation_calc();
            0x232: operation_calc();
            0x233: operation_calc();
            0x234: operation_calcAndSend();
            0x235: operation_calc();
            0x236: operation_calc();
            0x237: operation_calc();
            0x238: operation_calc();
            0x239: operation_calcAndSend();
            0x23a: operation_calc();
            0x23b: operation_calc();
            0x23c: operation_calc();
            0x23d: operation_calc();
            0x23e: operation_calcAndSend();
            0x23f: operation_calc();
            0x240: operation_calc();
            0x241: operation_calc();
            0x242: operation_calc();
            0x243: operation_calcAndSend();
            0x244: operation_calc();
            0x245: operation_calc();
            0x246: operation_calc();
            0x247: operation_calc();
            0x248: operation_calcAndSend();
            0x249: operation_calc();
            0x24a: operation_calc();
            0x24b: operation_calc();
            0x24c: operation_calc();
            0x24d: operation_calcAndSend();
            0x24e: operation_calc();
            0x24f: operation_calc();
            0x250: operation_calc();
            0x251: operation_calc();
            0x252: operation_calcAndSend();
            0x253: operation_calc();
            0x254: operation_calc();
            0x255: operation_calc();
            0x256: operation_calc();
            0x257: operation_calcAndSend();
            0x258: operation_calc();
            0x259: operation_calc();
            0x25a: operation_calc();
            0x25b: operation_calc();
            0x25c: operation_calcAndSend();
            0x25d: operation_calc();
            0x25e: operation_calc();
            0x25f: operation_calc();
            0x260: operation_calc();
            0x261: operation_calcAndSend();
            0x262: operation_calc();
            0x263: operation_calc();
            0x264: operation_calc();
            0x265: operation_calc();
            0x266: operation_calcAndSend();
            0x267: operation_calc();
            0x268: operation_calc();
            0x269: operation_calc();
            0x26a: operation_calc();
            0x26b: operation_calcAndSend();
            0x26c: operation_calc();
            0x26d: operation_calc();
            0x26e: operation_calc();
            0x26f: operation_calc();
            0x270: operation_calcAndSend();
            0x271: operation_calc();
            0x272: operation_calc();
            0x273: operation_calc();
            0x274: operation_calc();
            0x275: operation_calcAndSend();
            0x276: operation_calc();
            0x277: operation_calc();
            0x278: operation_calc();
            0x279: operation_calc();
            0x27a: operation_calcAndSend();
            0x27b: operation_calc();
            0x27c: operation_calc();
            0x27d: operation_calc();
            0x27e: operation_calc();
            0x27f: operation_calcAndSend();
            0x280: operation_calc();
            0x281: operation_calc();
            0x282: operation_calc();
            0x283: operation_calc();
            0x284: operation_calcAndSend();
            0x285: operation_calc();
            0x286: operation_calc();
            0x287: operation_calc();
            0x288: operation_calc();
            0x289: operation_calcAndSend();
            0x28a: operation_calc();
            0x28b: operation_calc();
            0x28c: operation_calc();
            0x28d: operation_calc();
            0x28e: operation_calcAndSend();
            0x28f: operation_calc();
            0x290: operation_calc();
            0x291: operation_calc();
            0x292: operation_calc();
            0x293: operation_calcAndSend();
            0x294: operation_calc();
            0x295: operation_calc();
            0x296: operation_calc();
            0x297: operation_calc();
            0x298: operation_calcAndSend();
            0x299: operation_calc();
            0x29a: operation_calc();
            0x29b: operation_calc();
            0x29c: operation_calc();
            0x29d: operation_calcAndSend();
            0x29e: operation_calc();
            0x29f: operation_calc();
            0x2a0: operation_calc();
            0x2a1: operation_calc();
            0x2a2: operation_calcAndSend();
            0x2a3: operation_calc();
            0x2a4: operation_calc();
            0x2a5: operation_calc();
            0x2a6: operation_calc();
            0x2a7: operation_calcAndSend();
            0x2a8: operation_calc();
            0x2a9: operation_calc();
            0x2aa: operation_calc();
            0x2ab: operation_calc();
            0x2ac: operation_calcAndSend();
            0x2ad: operation_calc();
            0x2ae: operation_calc();
            0x2af: operation_calc();
            0x2b0: operation_calc();
            0x2b1: operation_calcAndSend();
            0x2b2: operation_calc();
            0x2b3: operation_calc();
            0x2b4: operation_calc();
            0x2b5: operation_calc();
            0x2b6: operation_calcAndSend();
            0x2b7: operation_calc();
            0x2b8: operation_calc();
            0x2b9: operation_calc();
            0x2ba: operation_calc();
            0x2bb: operation_calcAndSend();
            0x2bc: operation_calc();
            0x2bd: operation_calc();
            0x2be: operation_calc();
            0x2bf: operation_calc();
            0x2c0: operation_calcAndSend();
            0x2c1: operation_calc();
            0x2c2: operation_calc();
            0x2c3: operation_calc();
            0x2c4: operation_calc();
            0x2c5: operation_calcAndSend();
            0x2c6: operation_calc();
            0x2c7: operation_calc();
            0x2c8: operation_calc();
            0x2c9: operation_calc();
            0x2ca: operation_calcAndSend();
            0x2cb: operation_calc();
            0x2cc: operation_calc();
            0x2cd: operation_calc();
            0x2ce: operation_calc();
            0x2cf: operation_calcAndSend();
            0x2d0: operation_calc();
            0x2d1: operation_calc();
            0x2d2: operation_calc();
            0x2d3: operation_calc();
            0x2d4: operation_calcAndSend();
            0x2d5: operation_calc();
            0x2d6: operation_calc();
            0x2d7: operation_calc();
            0x2d8: operation_calc();
            0x2d9: operation_calcAndSend();
            0x2da: operation_calc();
            0x2db: operation_calc();
            0x2dc: operation_calc();
            0x2dd: operation_calc();
            0x2de: operation_calcAndSend();
            0x2df: operation_calc();
            0x2e0: operation_calc();
            0x2e1: operation_calc();
            0x2e2: operation_calc();
            0x2e3: operation_calcAndSend();
            0x2e4: operation_calc();
            0x2e5: operation_calc();
            0x2e6: operation_calc();
            0x2e7: operation_calc();
            0x2e8: operation_calcAndSend();
            0x2e9: operation_calc();
            0x2ea: operation_calc();
            0x2eb: operation_calc();
            0x2ec: operation_calc();
            0x2ed: operation_calcAndSend();
            0x2ee: operation_calc();
            0x2ef: operation_calc();
            0x2f0: operation_calc();
            0x2f1: operation_calc();
            0x2f2: operation_calcAndSend();
            0x2f3: operation_calc();
            0x2f4: operation_calc();
            0x2f5: operation_calc();
            0x2f6: operation_calc();
            0x2f7: operation_calcAndSend();
            0x2f8: operation_calc();
            0x2f9: operation_calc();
            0x2fa: operation_calc();
            0x2fb: operation_calc();
            0x2fc: operation_calcAndSend();
            0x2fd: operation_calc();
            0x2fe: operation_calc();
            0x2ff: operation_calc();
            0x300: operation_calc();
            0x301: operation_calcAndSend();
            0x302: operation_calc();
            0x303: operation_calc();
            0x304: operation_calc();
            0x305: operation_calc();
            0x306: operation_calcAndSend();
            0x307: operation_calc();
            0x308: operation_calc();
            0x309: operation_calc();
            0x30a: operation_calc();
            0x30b: operation_calcAndSend();
            0x30c: operation_calc();
            0x30d: operation_calc();
            0x30e: operation_calc();
            0x30f: operation_calc();
            0x310: operation_calcAndSend();
            0x311: operation_calc();
            0x312: operation_calc();
            0x313: operation_calc();
            0x314: operation_calc();
            0x315: operation_calcAndSend();
            0x316: operation_calc();
            0x317: operation_calc();
            0x318: operation_calc();
            0x319: operation_calc();
            0x31a: operation_calcAndSend();
            0x31b: operation_calc();
            0x31c: operation_calc();
            0x31d: operation_calc();
            0x31e: operation_calc();
            0x31f: operation_calcAndSend();
            0x320: operation_calc();
            0x321: operation_calc();
            0x322: operation_calc();
            0x323: operation_calc();
            0x324: operation_calcAndSend();
            0x325: operation_calc();
            0x326: operation_calc();
            0x327: operation_calc();
            0x328: operation_calc();
            0x329: operation_calcAndSend();
            0x32a: operation_drop();
        }
    }
    apply {
        if (hdr.p4calc.isValid()) {
            standard_metadata.mcast_grp =  1;
            calculate.apply();
        } else {
            operation_drop();
        }
    }
}

/*************************************************************************
 ****************  E G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

/*************************************************************************
 *************   C H E C K S U M    C O M P U T A T I O N   **************
 *************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

/*************************************************************************
 ***********************  D E P A R S E R  *******************************
 *************************************************************************/
control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.p4calc);
    }
}

/*************************************************************************
 ***********************  S W I T T C H **********************************
 *************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
