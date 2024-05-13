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

const bit<32> replication = 0x00;

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
    action operation_drop() {
        mark_to_drop(standard_metadata);
    }

    apply {
         if (hdr.p4calc.isValid()) {
            standard_metadata.mcast_grp =  1;
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
