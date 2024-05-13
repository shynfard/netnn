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

const bit<104> weight_0_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_0_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_0_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_0_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_1_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_1_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_1_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_1_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_2_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_2_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_2_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_2_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_3_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_3_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_3_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_3_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_4_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_4_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_4_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_4_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_5_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_5_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_5_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_5_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_6_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_6_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_6_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_6_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_7_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_7_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_7_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_7_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_8_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_8_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_8_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_8_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_9_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_9_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_9_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_9_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_10_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_10_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_10_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_10_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_11_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_11_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_11_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_11_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_12_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_12_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_12_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_12_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_13_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_13_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_13_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_13_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_14_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_14_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_14_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_14_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_15_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_15_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_15_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_15_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_16_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_16_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_16_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_16_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_17_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_17_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_17_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_17_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_18_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_18_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_18_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_18_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_19_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_19_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_19_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_19_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_20_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_20_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_20_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_20_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_21_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_21_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_21_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_21_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_22_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_22_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_22_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_22_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_23_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_23_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_23_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_23_3 = 0x1234567890abcdef123456789a;
const bit<104> weight_24_0 = 0x1234567890abcdef123456789a;
const bit<104> weight_24_1 = 0x1234567890abcdef123456789a;
const bit<104> weight_24_2 = 0x1234567890abcdef123456789a;
const bit<104> weight_24_3 = 0x1234567890abcdef123456789a;

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

    register<bit<8>>(25) res;
    
    /**
     * 
     * Number of operations:
     * - read: 25
     * 
     */
    action readData(out bit<200> data) {
        res.read(data[7:0], 0);
        res.read(data[15:8], 1);
        res.read(data[23:16], 2);
        res.read(data[31:24], 3);
        res.read(data[39:32], 4);
        res.read(data[47:40], 5);
        res.read(data[55:48], 6);
        res.read(data[63:56], 7);
        res.read(data[71:64], 8);
        res.read(data[79:72], 9);
        res.read(data[87:80], 10);
        res.read(data[95:88], 11);
        res.read(data[103:96], 12);
        res.read(data[111:104], 13);
        res.read(data[119:112], 14);
        res.read(data[127:120], 15);
        res.read(data[135:128], 16);
        res.read(data[143:136], 17);
        res.read(data[151:144], 18);
        res.read(data[159:152], 19);
        res.read(data[167:160], 20);
        res.read(data[175:168], 21);
        res.read(data[183:176], 22);
        res.read(data[191:184], 23);
        res.read(data[199:192], 24);
    }


    /**
    * Number of operations:
     * - readData: 1
     *
     *
     * @param index The index of the broadcast message.
     */
    action send_broadcast() {
        readData(hdr.p4calc.s4_res);
        hdr.p4calc.s4_replication = replication;

        
        bit<48> tmp;

        /* Swap the MAC addresses */
        tmp = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp;

        /* Send the packet back to the port it came from */
        standard_metadata.egress_spec = standard_metadata.ingress_port;
    }

    action send_back() {

        bit<48> tmp;

        /* Swap the MAC addresses */
        tmp = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp;

        /* Send the packet back to the port it came from */
        standard_metadata.egress_spec = standard_metadata.ingress_port;
    }

    /**
     * 
     * Number of operations:
     * - read: 1
     * - write: 1
     * - add: 13
     * - multi: 13
     * 
     */
    action operation_calcAndWrite(in bit<104> weight, in bit<32> weight_number) {
        bit<8> temp=0;
        res.read(temp, weight_number);
        temp = temp +
        hdr.p4calc.s3_res[7:0]     * weight[7:0] +
        hdr.p4calc.s3_res[15:8]    * weight[15:8] +
        hdr.p4calc.s3_res[23:16]   * weight[23:16] +
        hdr.p4calc.s3_res[31:24]   * weight[31:24] +
        hdr.p4calc.s3_res[39:32]   * weight[39:32] +
        hdr.p4calc.s3_res[47:40]   * weight[47:40] +
        hdr.p4calc.s3_res[55:48]   * weight[55:48] +
        hdr.p4calc.s3_res[63:56]   * weight[63:56] +
        hdr.p4calc.s3_res[71:64]   * weight[71:64] +
        hdr.p4calc.s3_res[79:72]   * weight[79:72] +
        hdr.p4calc.s3_res[87:80]   * weight[87:80] +
        hdr.p4calc.s3_res[95:88]   * weight[95:88] +
        hdr.p4calc.s3_res[103:96]  * weight[103:96];
        res.write(weight_number, temp);
    }

        /**
     * 
     * Number of operations:
     * - operation_calcAndWrite: 25
     * 
     */
    action operation_calc(in bit<104> weight0 ,in bit<104> weight1 ,in bit<104> weight2 ,in bit<104> weight3 ,in bit<104> weight4 ,in bit<104> weight5 ,in bit<104> weight6 ,in bit<104> weight7 ,in bit<104> weight8 ,in bit<104> weight9 ,in bit<104> weight10 ,in bit<104> weight11 ,in bit<104> weight12 ,in bit<104> weight13 ,in bit<104> weight14 ,in bit<104> weight15 ,in bit<104> weight16 ,in bit<104> weight17 ,in bit<104> weight18 ,in bit<104> weight19 ,in bit<104> weight20 ,in bit<104> weight21 ,in bit<104> weight22 ,in bit<104> weight23 ,in bit<104> weight24) {
        operation_calcAndWrite(weight0  ,0);
        operation_calcAndWrite(weight1  ,1);
        operation_calcAndWrite(weight2  ,2);
        operation_calcAndWrite(weight3  ,3);
        operation_calcAndWrite(weight4  ,4);
        operation_calcAndWrite(weight5  ,5);
        operation_calcAndWrite(weight6  ,6);
        operation_calcAndWrite(weight7  ,7);
        operation_calcAndWrite(weight8  ,8);
        operation_calcAndWrite(weight9  ,9);
        operation_calcAndWrite(weight10 ,10);
        operation_calcAndWrite(weight11 ,11);
        operation_calcAndWrite(weight12 ,12);
        operation_calcAndWrite(weight13 ,13);
        operation_calcAndWrite(weight14 ,14);
        operation_calcAndWrite(weight15 ,15);
        operation_calcAndWrite(weight16 ,16);
        operation_calcAndWrite(weight17 ,17);
        operation_calcAndWrite(weight18 ,18);
        operation_calcAndWrite(weight19 ,19);
        operation_calcAndWrite(weight20 ,20);
        operation_calcAndWrite(weight21 ,21);
        operation_calcAndWrite(weight22 ,22);
        operation_calcAndWrite(weight23 ,23);
        operation_calcAndWrite(weight24 ,24);

    }

    /**
     * 
     * Number of operations:
     * - operation_calc: 1
     * - send_back: 1
     * 
     */
    action operation_calcAndBack(bit<104> weight0 ,bit<104> weight1 ,bit<104> weight2 ,bit<104> weight3 ,bit<104> weight4 ,bit<104> weight5 ,bit<104> weight6 ,bit<104> weight7 ,bit<104> weight8 ,bit<104> weight9 ,bit<104> weight10 ,bit<104> weight11 ,bit<104> weight12 ,bit<104> weight13 ,bit<104> weight14 ,bit<104> weight15 ,bit<104> weight16 ,bit<104> weight17 ,bit<104> weight18 ,bit<104> weight19 ,bit<104> weight20 ,bit<104> weight21 ,bit<104> weight22 ,bit<104> weight23 ,bit<104> weight24) {
        operation_calc(weight0, weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8, weight9, weight10, weight11, weight12, weight13, weight14, weight15, weight16, weight17, weight18, weight19, weight20, weight21, weight22, weight23, weight24);
        mark_to_drop(standard_metadata);
    }

    /**
     * 
     * Number of operations:
     * - operation_calc: 1
     * - send_broadcast: 1
     * 
     */
    action operation_calcAndNext(bit<104> weight0 ,bit<104> weight1 ,bit<104> weight2 ,bit<104> weight3 ,bit<104> weight4 ,bit<104> weight5 ,bit<104> weight6 ,bit<104> weight7 ,bit<104> weight8 ,bit<104> weight9 ,bit<104> weight10 ,bit<104> weight11 ,bit<104> weight12 ,bit<104> weight13 ,bit<104> weight14 ,bit<104> weight15 ,bit<104> weight16 ,bit<104> weight17 ,bit<104> weight18 ,bit<104> weight19 ,bit<104> weight20 ,bit<104> weight21 ,bit<104> weight22 ,bit<104> weight23 ,bit<104> weight24) {
        operation_calc(weight0, weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8, weight9, weight10, weight11, weight12, weight13, weight14, weight15, weight16, weight17, weight18, weight19, weight20, weight21, weight22, weight23, weight24);
        send_broadcast();
    }


    action operation_drop() {
        mark_to_drop(standard_metadata);
    }
    

    table calculate {
        key = {
            hdr.p4calc.s3_replication          : exact;
        }
        actions = {
            operation_drop;
            operation_calcAndBack;
            operation_calcAndNext;
        }
        const default_action = operation_drop();
        const entries = {
            0x0: operation_calcAndBack(weight_0_0, weight_1_0, weight_2_0, weight_3_0, weight_4_0, weight_5_0, weight_6_0, weight_7_0, weight_8_0, weight_9_0, weight_10_0, weight_11_0, weight_12_0, weight_13_0, weight_14_0, weight_15_0, weight_16_0, weight_17_0, weight_18_0, weight_19_0, weight_20_0, weight_21_0, weight_22_0, weight_23_0, weight_24_0);
            0x1: operation_calcAndBack(weight_0_1, weight_1_1, weight_2_1, weight_3_1, weight_4_1, weight_5_1, weight_6_1, weight_7_1, weight_8_1, weight_9_1, weight_10_1, weight_11_1, weight_12_1, weight_13_1, weight_14_1, weight_15_1, weight_16_1, weight_17_1, weight_18_1, weight_19_1, weight_20_1, weight_21_1, weight_22_1, weight_23_1, weight_24_1);
            0x2: operation_calcAndBack(weight_0_2, weight_1_2, weight_2_2, weight_3_2, weight_4_2, weight_5_2, weight_6_2, weight_7_2, weight_8_2, weight_9_2, weight_10_2, weight_11_2, weight_12_2, weight_13_2, weight_14_2, weight_15_2, weight_16_2, weight_17_2, weight_18_2, weight_19_2, weight_20_2, weight_21_2, weight_22_2, weight_23_2, weight_24_2);
            0x3: operation_calcAndNext(weight_0_3, weight_1_3, weight_2_3, weight_3_3, weight_4_3, weight_5_3, weight_6_3, weight_7_3, weight_8_3, weight_9_3, weight_10_3, weight_11_3, weight_12_3, weight_13_3, weight_14_3, weight_15_3, weight_16_3, weight_17_3, weight_18_3, weight_19_3, weight_20_3, weight_21_3, weight_22_3, weight_23_3, weight_24_3);
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
