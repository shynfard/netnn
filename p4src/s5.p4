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

const bit<200> weight_0 = 0x1234567890abcdef123456789a1234567890abcdef12345678;
const bit<200> weight_1 = 0x1234567890abcdef123456789a1234567890abcdef12345678;
const bit<200> weight_2 = 0x1234567890abcdef123456789a1234567890abcdef12345678;
const bit<200> weight_3 = 0x1234567890abcdef123456789a1234567890abcdef12345678;

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


struct metadata {
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

    register<bit<8>>(1) res;


    /**
     * 
     * Number of operations:
     * - read: 1
     * 
     */
    action readData(out bit<8> data) {
        res.read(data, 0);
    }


    /**
    * Number of operations:
     * - readData: 1
     *
     *
     * @param index The index of the broadcast message.
     */
    action send_broadcast() {
        readData(hdr.p4calc.s5_res);
    }


    /**
     * 
     * Number of operations:
     * - read: 1
     * - write: 1
     * - add: 25
     * - multi: 25
     * 
     */
    action operation_calcAndWrite(in bit<200> weight) {
        bit<8> temp=0;
        res.read(temp, 0);
        temp = temp +
        hdr.p4calc.s4_res[7:0]     * weight[7:0] +
        hdr.p4calc.s4_res[15:8]    * weight[15:8] +
        hdr.p4calc.s4_res[23:16]   * weight[23:16] +
        hdr.p4calc.s4_res[31:24]   * weight[31:24] +
        hdr.p4calc.s4_res[39:32]   * weight[39:32] +
        hdr.p4calc.s4_res[47:40]   * weight[47:40] +
        hdr.p4calc.s4_res[55:48]   * weight[55:48] +
        hdr.p4calc.s4_res[63:56]   * weight[63:56] +
        hdr.p4calc.s4_res[71:64]   * weight[71:64] +
        hdr.p4calc.s4_res[79:72]   * weight[79:72] +
        hdr.p4calc.s4_res[87:80]   * weight[87:80] +
        hdr.p4calc.s4_res[95:88]   * weight[95:88] +
        hdr.p4calc.s4_res[103:96]  * weight[103:96]+
        hdr.p4calc.s4_res[111:104]     * weight[111:104] +
        hdr.p4calc.s4_res[119:112]     * weight[119:112] +
        hdr.p4calc.s4_res[127:120]     * weight[127:120] +
        hdr.p4calc.s4_res[135:128]     * weight[135:128] +
        hdr.p4calc.s4_res[143:136]     * weight[143:136] +
        hdr.p4calc.s4_res[151:144]     * weight[151:144] +
        hdr.p4calc.s4_res[159:152]     * weight[159:152] +
        hdr.p4calc.s4_res[167:160]     * weight[167:160] +
        hdr.p4calc.s4_res[175:168]     * weight[175:168] +
        hdr.p4calc.s4_res[183:176]     * weight[183:176] +
        hdr.p4calc.s4_res[191:184]     * weight[191:184] +
        hdr.p4calc.s4_res[199:192]     * weight[199:192];
        res.write(0, temp);
    }

    /**
     * 
     * Number of operations:
     * - operation_calcAndWrite: 1
     * 
     */
    action operation_calc(in bit<200> weight0) {
        operation_calcAndWrite(weight0);

    }

    /**
     * 
     * Number of operations:
     * - operation_calc: 1
     * - send_back: 1
     * 
     */
    action operation_calcAndBack(bit<200> weight0) {
        operation_calc(weight0);
        operation_calcAndWrite(weight0);
    }

        /**
     * 
     * Number of operations:
     * - operation_calc: 1
     * - send_broadcast: 1
     * 
     */
    action operation_calcAndNext(bit<200> weight0) {
        operation_calc(weight0);
        send_broadcast();
    }


    action operation_drop() {
        mark_to_drop(standard_metadata);
    }
    

    table calculate {
        key = {
            hdr.p4calc.s4_replication          : exact;
        }
        actions = {
            operation_drop;
            operation_calcAndBack;
            operation_calcAndNext;
        }
        const default_action = operation_drop();
        const entries = {
            0x0: operation_calcAndBack(weight_0);
            0x1: operation_calcAndBack(weight_1);
            0x2: operation_calcAndBack(weight_2);
            0x3: operation_calcAndNext(weight_3);
        }
    }
    apply {
        if (hdr.p4calc.isValid()) {
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
