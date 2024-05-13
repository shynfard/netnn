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

const bit<1280> FILTER_l0 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l1 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l2 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l3 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l4 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l5 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l6 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l7 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l8 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l9 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l10 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l11 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l12 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l13 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l14 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;
const bit<1280> FILTER_l15 = 0x88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe88272881fe;


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

    register<bit<8>>(5184) input_data;
    register<bit<8>>(496) max_pool_registry;

    /**
     * Number of operations:
     * - Multiplication: 1
     * - Addition: 31
     * - Read: 32
     *
     * Reads 32 bytes of data from the input_data register.
     * @param index The index of the data.
     * @param data readed data.
     */
    action readData(in bit<32> index, out bit<256> data) {
        bit<32> index_read = index * 32;
        input_data.read(data[7:0],     index_read);
        input_data.read(data[15:8],    index_read + 1);
        input_data.read(data[23:16],   index_read + 2);
        input_data.read(data[31:24],   index_read + 3);
        input_data.read(data[39:32],   index_read + 4);
        input_data.read(data[47:40],   index_read + 5);
        input_data.read(data[55:48],   index_read + 6);
        input_data.read(data[63:56],   index_read + 7);
        input_data.read(data[71:64],   index_read + 8);
        input_data.read(data[79:72],   index_read + 9);
        input_data.read(data[87:80],   index_read + 10);
        input_data.read(data[95:88],   index_read + 11);
        input_data.read(data[103:96],  index_read + 12);
        input_data.read(data[111:104], index_read + 13);
        input_data.read(data[119:112], index_read + 14);
        input_data.read(data[127:120], index_read + 15);
        input_data.read(data[135:128], index_read + 16);
        input_data.read(data[143:136], index_read + 17);
        input_data.read(data[151:144], index_read + 18);
        input_data.read(data[159:152], index_read + 19);
        input_data.read(data[167:160], index_read + 20);
        input_data.read(data[175:168], index_read + 21);
        input_data.read(data[183:176], index_read + 22);
        input_data.read(data[191:184], index_read + 23);
        input_data.read(data[199:192], index_read + 24);
        input_data.read(data[207:200], index_read + 25);
        input_data.read(data[215:208], index_read + 26);
        input_data.read(data[223:216], index_read + 27);
        input_data.read(data[231:224], index_read + 28);
        input_data.read(data[239:232], index_read + 29);
        input_data.read(data[247:240], index_read + 30);
        input_data.read(data[255:248], index_read + 31);

    }

    /**
    * Number of operations:
     * -read 16
     * - add 15
     *
     * @param index The index of the broadcast message.
     */
    action send_broadcast(in bit<32> index) {

        max_pool_registry.read(hdr.p4calc.s2_res[7:0],     index );
        max_pool_registry.read(hdr.p4calc.s2_res[15:8],    index + 1);
        max_pool_registry.read(hdr.p4calc.s2_res[23:16],   index + 2);
        max_pool_registry.read(hdr.p4calc.s2_res[31:24],   index + 3);
        max_pool_registry.read(hdr.p4calc.s2_res[39:32],   index + 4);
        max_pool_registry.read(hdr.p4calc.s2_res[47:40],   index + 5);
        max_pool_registry.read(hdr.p4calc.s2_res[55:48],   index + 6);
        max_pool_registry.read(hdr.p4calc.s2_res[63:56],   index + 7);
        max_pool_registry.read(hdr.p4calc.s2_res[71:64],   index + 8);
        max_pool_registry.read(hdr.p4calc.s2_res[79:72],   index + 9);
        max_pool_registry.read(hdr.p4calc.s2_res[87:80],   index + 10);
        max_pool_registry.read(hdr.p4calc.s2_res[95:88],   index + 11);
        max_pool_registry.read(hdr.p4calc.s2_res[103:96],  index + 12);
        max_pool_registry.read(hdr.p4calc.s2_res[111:104], index + 13);
        max_pool_registry.read(hdr.p4calc.s2_res[119:112], index + 14);
        max_pool_registry.read(hdr.p4calc.s2_res[127:120], index + 15);
        hdr.p4calc.s2_replication = replication;
        hdr.p4calc.s2_index = index;
    }

    /**
     * 
     * Number of operations:
     * - Multiplication: 2
     * - Addition: 8
     * - write: 8
     * 
     * Inserts the input data into the input_data register.
     *
     */
    action operation_write() {
        bit<32> index = hdr.p4calc.s1_max_pool_index * 32 + hdr.p4calc.s1_replication * 8;
        input_data.write(index, hdr.p4calc.s1_res[7:0]);
        input_data.write(index + 1, hdr.p4calc.s1_res[15:8]);
        input_data.write(index + 2, hdr.p4calc.s1_res[23:16]);
        input_data.write(index + 3, hdr.p4calc.s1_res[31:24]);
        input_data.write(index + 4, hdr.p4calc.s1_res[39:32]);
        input_data.write(index + 5, hdr.p4calc.s1_res[47:40]);
        input_data.write(index + 6, hdr.p4calc.s1_res[55:48]);
        input_data.write(index + 7, hdr.p4calc.s1_res[63:56]);
    }


    /**
     * 
     * Number of operations:
     * - Multiplication: 160
     * - Addition: 159
     * - Read: 1
     * - Write: 1
     * - Compare: 1

     * Action to calculate convolution and max pooling.
     *
     * @param f the filter.
     * @param d_0 The first data. 0-31
     * @param d_1  32-63
     * @param d_2  64-95
     * @param d_3  96-127
     * @param d_4  128-159
     * @param max_pool_index The index of the max pooling.
     */
    action conv_maxpool_calc(in bit<1280> f, in bit<256> d_0, in bit<256> d_1, in bit<256> d_2, in bit<256> d_3, in bit<256> d_4, in bit<32> max_pool_index) {
        bit<8> conv = 
        d_0[7:0]         * f[7:0] + 
        d_0[15:8]        * f[15:8] + 
        d_0[23:16]       * f[23:16] + 
        d_0[31:24]       * f[31:24] + 
        d_0[39:32]       * f[39:32] + 
        d_0[47:40]       * f[47:40] + 
        d_0[55:48]       * f[55:48] + 
        d_0[63:56]       * f[63:56] + 
        d_0[71:64]       * f[71:64] + 
        d_0[79:72]       * f[79:72] + 
        d_0[87:80]       * f[87:80] + 
        d_0[95:88]       * f[95:88] + 
        d_0[103:96]      * f[103:96] + 
        d_0[111:104]     * f[111:104] + 
        d_0[119:112]     * f[119:112] + 
        d_0[127:120]     * f[127:120] + 
        d_0[135:128]     * f[135:128] + 
        d_0[143:136]     * f[143:136] + 
        d_0[151:144]     * f[151:144] + 
        d_0[159:152]     * f[159:152] + 
        d_0[167:160]     * f[167:160] + 
        d_0[175:168]     * f[175:168] + 
        d_0[183:176]     * f[183:176] + 
        d_0[191:184]     * f[191:184] + 
        d_0[199:192]     * f[199:192] + 
        d_0[207:200]     * f[207:200] + 
        d_0[215:208]     * f[215:208] + 
        d_0[223:216]     * f[223:216] + 
        d_0[231:224]     * f[231:224] + 
        d_0[239:232]     * f[239:232] + 
        d_0[247:240]     * f[247:240] + 
        d_0[255:248]     * f[255:248] + 
        d_1[7:0]         * f[263:256] + 
        d_1[15:8]        * f[271:264] + 
        d_1[23:16]       * f[279:272] + 
        d_1[31:24]       * f[287:280] + 
        d_1[39:32]       * f[295:288] + 
        d_1[47:40]       * f[303:296] + 
        d_1[55:48]       * f[311:304] + 
        d_1[63:56]       * f[319:312] + 
        d_1[71:64]       * f[327:320] + 
        d_1[79:72]       * f[335:328] + 
        d_1[87:80]       * f[343:336] + 
        d_1[95:88]       * f[351:344] + 
        d_1[103:96]      * f[359:352] + 
        d_1[111:104]     * f[367:360] + 
        d_1[119:112]     * f[375:368] + 
        d_1[127:120]     * f[383:376] + 
        d_1[135:128]     * f[391:384] + 
        d_1[143:136]     * f[399:392] + 
        d_1[151:144]     * f[407:400] + 
        d_1[159:152]     * f[415:408] + 
        d_1[167:160]     * f[423:416] + 
        d_1[175:168]     * f[431:424] + 
        d_1[183:176]     * f[439:432] + 
        d_1[191:184]     * f[447:440] + 
        d_1[199:192]     * f[455:448] + 
        d_1[207:200]     * f[463:456] + 
        d_1[215:208]     * f[471:464] + 
        d_1[223:216]     * f[479:472] + 
        d_1[231:224]     * f[487:480] + 
        d_1[239:232]     * f[495:488] + 
        d_1[247:240]     * f[503:496] + 
        d_1[255:248]     * f[511:504] + 
        d_2[7:0]         * f[519:512] + 
        d_2[15:8]        * f[527:520] + 
        d_2[23:16]       * f[535:528] + 
        d_2[31:24]       * f[543:536] + 
        d_2[39:32]       * f[551:544] + 
        d_2[47:40]       * f[559:552] + 
        d_2[55:48]       * f[567:560] + 
        d_2[63:56]       * f[575:568] + 
        d_2[71:64]       * f[583:576] + 
        d_2[79:72]       * f[591:584] + 
        d_2[87:80]       * f[599:592] + 
        d_2[95:88]       * f[607:600] + 
        d_2[103:96]      * f[615:608] + 
        d_2[111:104]     * f[623:616] + 
        d_2[119:112]     * f[631:624] + 
        d_2[127:120]     * f[639:632] + 
        d_2[135:128]     * f[647:640] + 
        d_2[143:136]     * f[655:648] + 
        d_2[151:144]     * f[663:656] + 
        d_2[159:152]     * f[671:664] + 
        d_2[167:160]     * f[679:672] + 
        d_2[175:168]     * f[687:680] + 
        d_2[183:176]     * f[695:688] + 
        d_2[191:184]     * f[703:696] + 
        d_2[199:192]     * f[711:704] + 
        d_2[207:200]     * f[719:712] + 
        d_2[215:208]     * f[727:720] + 
        d_2[223:216]     * f[735:728] + 
        d_2[231:224]     * f[743:736] + 
        d_2[239:232]     * f[751:744] + 
        d_2[247:240]     * f[759:752] + 
        d_2[255:248]     * f[767:760] + 
        d_3[7:0]         * f[775:768] + 
        d_3[15:8]        * f[783:776] + 
        d_3[23:16]       * f[791:784] + 
        d_3[31:24]       * f[799:792] + 
        d_3[39:32]       * f[807:800] + 
        d_3[47:40]       * f[815:808] + 
        d_3[55:48]       * f[823:816] + 
        d_3[63:56]       * f[831:824] + 
        d_3[71:64]       * f[839:832] + 
        d_3[79:72]       * f[847:840] + 
        d_3[87:80]       * f[855:848] + 
        d_3[95:88]       * f[863:856] + 
        d_3[103:96]      * f[871:864] + 
        d_3[111:104]     * f[879:872] + 
        d_3[119:112]     * f[887:880] + 
        d_3[127:120]     * f[895:888] + 
        d_3[135:128]     * f[903:896] + 
        d_3[143:136]     * f[911:904] + 
        d_3[151:144]     * f[919:912] + 
        d_3[159:152]     * f[927:920] + 
        d_3[167:160]     * f[935:928] + 
        d_3[175:168]     * f[943:936] + 
        d_3[183:176]     * f[951:944] + 
        d_3[191:184]     * f[959:952] + 
        d_3[199:192]     * f[967:960] + 
        d_3[207:200]     * f[975:968] + 
        d_3[215:208]     * f[983:976] + 
        d_3[223:216]     * f[991:984] + 
        d_3[231:224]     * f[999:992] + 
        d_3[239:232]     * f[1007:1000] + 
        d_3[247:240]     * f[1015:1008] + 
        d_3[255:248]     * f[1023:1016] + 
        d_4[7:0]         * f[1031:1024] + 
        d_4[15:8]        * f[1039:1032] + 
        d_4[23:16]       * f[1047:1040] + 
        d_4[31:24]       * f[1055:1048] + 
        d_4[39:32]       * f[1063:1056] + 
        d_4[47:40]       * f[1071:1064] + 
        d_4[55:48]       * f[1079:1072] + 
        d_4[63:56]       * f[1087:1080] + 
        d_4[71:64]       * f[1095:1088] + 
        d_4[79:72]       * f[1103:1096] + 
        d_4[87:80]       * f[1111:1104] + 
        d_4[95:88]       * f[1119:1112] + 
        d_4[103:96]      * f[1127:1120] + 
        d_4[111:104]     * f[1135:1128] + 
        d_4[119:112]     * f[1143:1136] + 
        d_4[127:120]     * f[1151:1144] + 
        d_4[135:128]     * f[1159:1152] + 
        d_4[143:136]     * f[1167:1160] + 
        d_4[151:144]     * f[1175:1168] + 
        d_4[159:152]     * f[1183:1176] + 
        d_4[167:160]     * f[1191:1184] + 
        d_4[175:168]     * f[1199:1192] + 
        d_4[183:176]     * f[1207:1200] + 
        d_4[191:184]     * f[1215:1208] + 
        d_4[199:192]     * f[1223:1216] + 
        d_4[207:200]     * f[1231:1224] + 
        d_4[215:208]     * f[1239:1232] + 
        d_4[223:216]     * f[1247:1240] + 
        d_4[231:224]     * f[1255:1248] + 
        d_4[239:232]     * f[1263:1256] + 
        d_4[247:240]     * f[1271:1264] + 
        d_4[255:248]     * f[1279:1272];



        bit<8> maxpool;
        max_pool_registry.read(maxpool, max_pool_index);
        if (conv > maxpool) {
            maxpool = conv;
        }
        max_pool_registry.write(max_pool_index, maxpool);
    }

    /**
     * 
     * Number of operations:
     * - readData: 5
     * - conv_maxpool_calc: 16
     * - Addition: 19
     * 
     * Performs the calculation operation on 16 Filters.
     *
     */
    action operation_calc(in bit<32> input_index, in bit<32> max_pool_index) {
        bit<256> d_0;
        bit<256> d_1;
        bit<256> d_2;
        bit<256> d_3;
        bit<256> d_4;
        readData(input_index , d_0);
        readData(input_index + 1, d_1);
        readData(input_index + 2, d_2);
        readData(input_index + 3, d_3);
        readData(input_index + 4, d_4);

        conv_maxpool_calc(FILTER_l0, d_0, d_1, d_2, d_3, d_4, max_pool_index);
        conv_maxpool_calc(FILTER_l1, d_0, d_1, d_2, d_3, d_4, max_pool_index + 1);
        conv_maxpool_calc(FILTER_l2, d_0, d_1, d_2, d_3, d_4, max_pool_index + 2);
        conv_maxpool_calc(FILTER_l3, d_0, d_1, d_2, d_3, d_4, max_pool_index + 3);
        conv_maxpool_calc(FILTER_l4, d_0, d_1, d_2, d_3, d_4, max_pool_index + 4);
        // conv_maxpool_calc(FILTER_l5, d_0, d_1, d_2, d_3, d_4, max_pool_index + 5);
        // conv_maxpool_calc(FILTER_l6, d_0, d_1, d_2, d_3, d_4, max_pool_index + 6);
        // conv_maxpool_calc(FILTER_l7, d_0, d_1, d_2, d_3, d_4, max_pool_index + 7);
        // conv_maxpool_calc(FILTER_l0, d_0, d_1, d_2, d_3, d_4, max_pool_index + 8);
        // conv_maxpool_calc(FILTER_l1, d_0, d_1, d_2, d_3, d_4, max_pool_index + 9);
        // conv_maxpool_calc(FILTER_l2, d_0, d_1, d_2, d_3, d_4, max_pool_index + 10);
        // conv_maxpool_calc(FILTER_l3, d_0, d_1, d_2, d_3, d_4, max_pool_index + 11);
        // conv_maxpool_calc(FILTER_l4, d_0, d_1, d_2, d_3, d_4, max_pool_index + 12);
        // conv_maxpool_calc(FILTER_l5, d_0, d_1, d_2, d_3, d_4, max_pool_index + 13);
        // conv_maxpool_calc(FILTER_l6, d_0, d_1, d_2, d_3, d_4, max_pool_index + 14);
        // conv_maxpool_calc(FILTER_l7, d_0, d_1, d_2, d_3, d_4, max_pool_index + 15);

    }

    /**
     * 
     * Number of operations:
     * - operation_write: 1
     * - operation_calc: 1
     * 
     */
    action operation_insertAndCalc(bit<32> input_index, bit<32> max_pool_index) {
        operation_write();
        operation_calc(input_index, max_pool_index);
        mark_to_drop(standard_metadata);
    }
    /**
     * 
     * Number of operations:
     * - operation_write: 1
     * 
     */
    action operation_insert() {
        operation_write();
        mark_to_drop(standard_metadata);
    }

    /**
     * 
     * Number of operations:
     * - operation_write: 1
     * - operation_calc: 1
     * - send_broadcast: 1
     * 
     */
    action operation_insertAndCalcAndSend(bit<32> input_index, bit<32> max_pool_index, bit<32> send_input) {
        operation_write();
        operation_calc(input_index, max_pool_index);
        send_broadcast(send_input);
    }

    action operation_drop() {
        mark_to_drop(standard_metadata);
    }
    

    table calculate {
        key = {
            hdr.p4calc.s1_replication          : exact;
            hdr.p4calc.s1_max_pool_index       : exact;
        }
        actions = {
            operation_insert;
            operation_drop;
            operation_insertAndCalc;
            operation_insertAndCalcAndSend;
        }
        const default_action = operation_drop();
        const entries = {
            (0x00, 0x0): operation_insert();
            (0x01, 0x0): operation_insert();
            (0x02, 0x0): operation_insert();
            (0x03, 0x0): operation_insert();
            (0x00, 0x1): operation_insert();
            (0x01, 0x1): operation_insert();
            (0x02, 0x1): operation_insert();
            (0x03, 0x1): operation_insert();
            (0x00, 0x2): operation_insert();
            (0x01, 0x2): operation_insert();
            (0x02, 0x2): operation_insert();
            (0x03, 0x2): operation_insert();
            (0x00, 0x3): operation_insert();
            (0x01, 0x3): operation_insert();
            (0x02, 0x3): operation_insert();
            (0x03, 0x3): operation_insert();
            (0x00, 0x4): operation_insert();
            (0x01, 0x4): operation_insert();
            (0x02, 0x4): operation_insert();
            (0x03, 0x4): operation_insertAndCalc(0, 0);
            (0x00, 0x5): operation_insert();
            (0x01, 0x5): operation_insert();
            (0x02, 0x5): operation_insert();
            (0x03, 0x5): operation_insertAndCalc(1, 0);
            (0x00, 0x6): operation_insert();
            (0x01, 0x6): operation_insert();
            (0x02, 0x6): operation_insert();
            (0x03, 0x6): operation_insertAndCalc(2, 0);
            (0x00, 0x7): operation_insert();
            (0x01, 0x7): operation_insert();
            (0x02, 0x7): operation_insert();
            (0x03, 0x7): operation_insertAndCalc(3, 0);
            (0x00, 0x8): operation_insert();
            (0x01, 0x8): operation_insert();
            (0x02, 0x8): operation_insert();
            (0x03, 0x8): operation_insertAndCalc(4, 0);
            (0x00, 0x9): operation_insert();
            (0x01, 0x9): operation_insert();
            (0x02, 0x9): operation_insert();
            (0x03, 0x9): operation_insertAndCalcAndSend(5, 1, 0);
            (0x00, 0xa): operation_insert();
            (0x01, 0xa): operation_insert();
            (0x02, 0xa): operation_insert();
            (0x03, 0xa): operation_insertAndCalc(6, 1);
            (0x00, 0xb): operation_insert();
            (0x01, 0xb): operation_insert();
            (0x02, 0xb): operation_insert();
            (0x03, 0xb): operation_insertAndCalc(7, 1);
            (0x00, 0xc): operation_insert();
            (0x01, 0xc): operation_insert();
            (0x02, 0xc): operation_insert();
            (0x03, 0xc): operation_insertAndCalc(8, 1);
            (0x00, 0xd): operation_insert();
            (0x01, 0xd): operation_insert();
            (0x02, 0xd): operation_insert();
            (0x03, 0xd): operation_insertAndCalc(9, 1);
            (0x00, 0xe): operation_insert();
            (0x01, 0xe): operation_insert();
            (0x02, 0xe): operation_insert();
            (0x03, 0xe): operation_insertAndCalcAndSend(10, 2, 1);
            (0x00, 0xf): operation_insert();
            (0x01, 0xf): operation_insert();
            (0x02, 0xf): operation_insert();
            (0x03, 0xf): operation_insertAndCalc(11, 2);
            (0x00, 0x10): operation_insert();
            (0x01, 0x10): operation_insert();
            (0x02, 0x10): operation_insert();
            (0x03, 0x10): operation_insertAndCalc(12, 2);
            (0x00, 0x11): operation_insert();
            (0x01, 0x11): operation_insert();
            (0x02, 0x11): operation_insert();
            (0x03, 0x11): operation_insertAndCalc(13, 2);
            (0x00, 0x12): operation_insert();
            (0x01, 0x12): operation_insert();
            (0x02, 0x12): operation_insert();
            (0x03, 0x12): operation_insertAndCalc(14, 2);
            (0x00, 0x13): operation_insert();
            (0x01, 0x13): operation_insert();
            (0x02, 0x13): operation_insert();
            (0x03, 0x13): operation_insertAndCalcAndSend(15, 3, 2);
            (0x00, 0x14): operation_insert();
            (0x01, 0x14): operation_insert();
            (0x02, 0x14): operation_insert();
            (0x03, 0x14): operation_insertAndCalc(16, 3);
            (0x00, 0x15): operation_insert();
            (0x01, 0x15): operation_insert();
            (0x02, 0x15): operation_insert();
            (0x03, 0x15): operation_insertAndCalc(17, 3);
            (0x00, 0x16): operation_insert();
            (0x01, 0x16): operation_insert();
            (0x02, 0x16): operation_insert();
            (0x03, 0x16): operation_insertAndCalc(18, 3);
            (0x00, 0x17): operation_insert();
            (0x01, 0x17): operation_insert();
            (0x02, 0x17): operation_insert();
            (0x03, 0x17): operation_insertAndCalc(19, 3);
            (0x00, 0x18): operation_insert();
            (0x01, 0x18): operation_insert();
            (0x02, 0x18): operation_insert();
            (0x03, 0x18): operation_insertAndCalcAndSend(20, 4, 3);
            (0x00, 0x19): operation_insert();
            (0x01, 0x19): operation_insert();
            (0x02, 0x19): operation_insert();
            (0x03, 0x19): operation_insertAndCalc(21, 4);
            (0x00, 0x1a): operation_insert();
            (0x01, 0x1a): operation_insert();
            (0x02, 0x1a): operation_insert();
            (0x03, 0x1a): operation_insertAndCalc(22, 4);
            (0x00, 0x1b): operation_insert();
            (0x01, 0x1b): operation_insert();
            (0x02, 0x1b): operation_insert();
            (0x03, 0x1b): operation_insertAndCalc(23, 4);
            (0x00, 0x1c): operation_insert();
            (0x01, 0x1c): operation_insert();
            (0x02, 0x1c): operation_insert();
            (0x03, 0x1c): operation_insertAndCalc(24, 4);
            (0x00, 0x1d): operation_insert();
            (0x01, 0x1d): operation_insert();
            (0x02, 0x1d): operation_insert();
            (0x03, 0x1d): operation_insertAndCalcAndSend(25, 5, 4);
            (0x00, 0x1e): operation_insert();
            (0x01, 0x1e): operation_insert();
            (0x02, 0x1e): operation_insert();
            (0x03, 0x1e): operation_insertAndCalc(26, 5);
            (0x00, 0x1f): operation_insert();
            (0x01, 0x1f): operation_insert();
            (0x02, 0x1f): operation_insert();
            (0x03, 0x1f): operation_insertAndCalc(27, 5);
            (0x00, 0x20): operation_insert();
            (0x01, 0x20): operation_insert();
            (0x02, 0x20): operation_insert();
            (0x03, 0x20): operation_insertAndCalc(28, 5);
            (0x00, 0x21): operation_insert();
            (0x01, 0x21): operation_insert();
            (0x02, 0x21): operation_insert();
            (0x03, 0x21): operation_insertAndCalc(29, 5);
            (0x00, 0x22): operation_insert();
            (0x01, 0x22): operation_insert();
            (0x02, 0x22): operation_insert();
            (0x03, 0x22): operation_insertAndCalcAndSend(30, 6, 5);
            (0x00, 0x23): operation_insert();
            (0x01, 0x23): operation_insert();
            (0x02, 0x23): operation_insert();
            (0x03, 0x23): operation_insertAndCalc(31, 6);
            (0x00, 0x24): operation_insert();
            (0x01, 0x24): operation_insert();
            (0x02, 0x24): operation_insert();
            (0x03, 0x24): operation_insertAndCalc(32, 6);
            (0x00, 0x25): operation_insert();
            (0x01, 0x25): operation_insert();
            (0x02, 0x25): operation_insert();
            (0x03, 0x25): operation_insertAndCalc(33, 6);
            (0x00, 0x26): operation_insert();
            (0x01, 0x26): operation_insert();
            (0x02, 0x26): operation_insert();
            (0x03, 0x26): operation_insertAndCalc(34, 6);
            (0x00, 0x27): operation_insert();
            (0x01, 0x27): operation_insert();
            (0x02, 0x27): operation_insert();
            (0x03, 0x27): operation_insertAndCalcAndSend(35, 7, 6);
            (0x00, 0x28): operation_insert();
            (0x01, 0x28): operation_insert();
            (0x02, 0x28): operation_insert();
            (0x03, 0x28): operation_insertAndCalc(36, 7);
            (0x00, 0x29): operation_insert();
            (0x01, 0x29): operation_insert();
            (0x02, 0x29): operation_insert();
            (0x03, 0x29): operation_insertAndCalc(37, 7);
            (0x00, 0x2a): operation_insert();
            (0x01, 0x2a): operation_insert();
            (0x02, 0x2a): operation_insert();
            (0x03, 0x2a): operation_insertAndCalc(38, 7);
            (0x00, 0x2b): operation_insert();
            (0x01, 0x2b): operation_insert();
            (0x02, 0x2b): operation_insert();
            (0x03, 0x2b): operation_insertAndCalc(39, 7);
            (0x00, 0x2c): operation_insert();
            (0x01, 0x2c): operation_insert();
            (0x02, 0x2c): operation_insert();
            (0x03, 0x2c): operation_insertAndCalcAndSend(40, 8, 7);
            (0x00, 0x2d): operation_insert();
            (0x01, 0x2d): operation_insert();
            (0x02, 0x2d): operation_insert();
            (0x03, 0x2d): operation_insertAndCalc(41, 8);
            (0x00, 0x2e): operation_insert();
            (0x01, 0x2e): operation_insert();
            (0x02, 0x2e): operation_insert();
            (0x03, 0x2e): operation_insertAndCalc(42, 8);
            (0x00, 0x2f): operation_insert();
            (0x01, 0x2f): operation_insert();
            (0x02, 0x2f): operation_insert();
            (0x03, 0x2f): operation_insertAndCalc(43, 8);
            (0x00, 0x30): operation_insert();
            (0x01, 0x30): operation_insert();
            (0x02, 0x30): operation_insert();
            (0x03, 0x30): operation_insertAndCalc(44, 8);
            (0x00, 0x31): operation_insert();
            (0x01, 0x31): operation_insert();
            (0x02, 0x31): operation_insert();
            (0x03, 0x31): operation_insertAndCalcAndSend(45, 9, 8);
            (0x00, 0x32): operation_insert();
            (0x01, 0x32): operation_insert();
            (0x02, 0x32): operation_insert();
            (0x03, 0x32): operation_insertAndCalc(46, 9);
            (0x00, 0x33): operation_insert();
            (0x01, 0x33): operation_insert();
            (0x02, 0x33): operation_insert();
            (0x03, 0x33): operation_insertAndCalc(47, 9);
            (0x00, 0x34): operation_insert();
            (0x01, 0x34): operation_insert();
            (0x02, 0x34): operation_insert();
            (0x03, 0x34): operation_insertAndCalc(48, 9);
            (0x00, 0x35): operation_insert();
            (0x01, 0x35): operation_insert();
            (0x02, 0x35): operation_insert();
            (0x03, 0x35): operation_insertAndCalc(49, 9);
            (0x00, 0x36): operation_insert();
            (0x01, 0x36): operation_insert();
            (0x02, 0x36): operation_insert();
            (0x03, 0x36): operation_insertAndCalcAndSend(50, 10, 9);
            (0x00, 0x37): operation_insert();
            (0x01, 0x37): operation_insert();
            (0x02, 0x37): operation_insert();
            (0x03, 0x37): operation_insertAndCalc(51, 10);
            (0x00, 0x38): operation_insert();
            (0x01, 0x38): operation_insert();
            (0x02, 0x38): operation_insert();
            (0x03, 0x38): operation_insertAndCalc(52, 10);
            (0x00, 0x39): operation_insert();
            (0x01, 0x39): operation_insert();
            (0x02, 0x39): operation_insert();
            (0x03, 0x39): operation_insertAndCalc(53, 10);
            (0x00, 0x3a): operation_insert();
            (0x01, 0x3a): operation_insert();
            (0x02, 0x3a): operation_insert();
            (0x03, 0x3a): operation_insertAndCalc(54, 10);
            (0x00, 0x3b): operation_insert();
            (0x01, 0x3b): operation_insert();
            (0x02, 0x3b): operation_insert();
            (0x03, 0x3b): operation_insertAndCalcAndSend(55, 11, 10);
            (0x00, 0x3c): operation_insert();
            (0x01, 0x3c): operation_insert();
            (0x02, 0x3c): operation_insert();
            (0x03, 0x3c): operation_insertAndCalc(56, 11);
            (0x00, 0x3d): operation_insert();
            (0x01, 0x3d): operation_insert();
            (0x02, 0x3d): operation_insert();
            (0x03, 0x3d): operation_insertAndCalc(57, 11);
            (0x00, 0x3e): operation_insert();
            (0x01, 0x3e): operation_insert();
            (0x02, 0x3e): operation_insert();
            (0x03, 0x3e): operation_insertAndCalc(58, 11);
            (0x00, 0x3f): operation_insert();
            (0x01, 0x3f): operation_insert();
            (0x02, 0x3f): operation_insert();
            (0x03, 0x3f): operation_insertAndCalc(59, 11);
            (0x00, 0x40): operation_insert();
            (0x01, 0x40): operation_insert();
            (0x02, 0x40): operation_insert();
            (0x03, 0x40): operation_insertAndCalcAndSend(60, 12, 11);
            (0x00, 0x41): operation_insert();
            (0x01, 0x41): operation_insert();
            (0x02, 0x41): operation_insert();
            (0x03, 0x41): operation_insertAndCalc(61, 12);
            (0x00, 0x42): operation_insert();
            (0x01, 0x42): operation_insert();
            (0x02, 0x42): operation_insert();
            (0x03, 0x42): operation_insertAndCalc(62, 12);
            (0x00, 0x43): operation_insert();
            (0x01, 0x43): operation_insert();
            (0x02, 0x43): operation_insert();
            (0x03, 0x43): operation_insertAndCalc(63, 12);
            (0x00, 0x44): operation_insert();
            (0x01, 0x44): operation_insert();
            (0x02, 0x44): operation_insert();
            (0x03, 0x44): operation_insertAndCalc(64, 12);
            (0x00, 0x45): operation_insert();
            (0x01, 0x45): operation_insert();
            (0x02, 0x45): operation_insert();
            (0x03, 0x45): operation_insertAndCalcAndSend(65, 13, 12);
            (0x00, 0x46): operation_insert();
            (0x01, 0x46): operation_insert();
            (0x02, 0x46): operation_insert();
            (0x03, 0x46): operation_insertAndCalc(66, 13);
            (0x00, 0x47): operation_insert();
            (0x01, 0x47): operation_insert();
            (0x02, 0x47): operation_insert();
            (0x03, 0x47): operation_insertAndCalc(67, 13);
            (0x00, 0x48): operation_insert();
            (0x01, 0x48): operation_insert();
            (0x02, 0x48): operation_insert();
            (0x03, 0x48): operation_insertAndCalc(68, 13);
            (0x00, 0x49): operation_insert();
            (0x01, 0x49): operation_insert();
            (0x02, 0x49): operation_insert();
            (0x03, 0x49): operation_insertAndCalc(69, 13);
            (0x00, 0x4a): operation_insert();
            (0x01, 0x4a): operation_insert();
            (0x02, 0x4a): operation_insert();
            (0x03, 0x4a): operation_insertAndCalcAndSend(70, 14, 13);
            (0x00, 0x4b): operation_insert();
            (0x01, 0x4b): operation_insert();
            (0x02, 0x4b): operation_insert();
            (0x03, 0x4b): operation_insertAndCalc(71, 14);
            (0x00, 0x4c): operation_insert();
            (0x01, 0x4c): operation_insert();
            (0x02, 0x4c): operation_insert();
            (0x03, 0x4c): operation_insertAndCalc(72, 14);
            (0x00, 0x4d): operation_insert();
            (0x01, 0x4d): operation_insert();
            (0x02, 0x4d): operation_insert();
            (0x03, 0x4d): operation_insertAndCalc(73, 14);
            (0x00, 0x4e): operation_insert();
            (0x01, 0x4e): operation_insert();
            (0x02, 0x4e): operation_insert();
            (0x03, 0x4e): operation_insertAndCalc(74, 14);
            (0x00, 0x4f): operation_insert();
            (0x01, 0x4f): operation_insert();
            (0x02, 0x4f): operation_insert();
            (0x03, 0x4f): operation_insertAndCalcAndSend(75, 15, 14);
            (0x00, 0x50): operation_insert();
            (0x01, 0x50): operation_insert();
            (0x02, 0x50): operation_insert();
            (0x03, 0x50): operation_insertAndCalc(76, 15);
            (0x00, 0x51): operation_insert();
            (0x01, 0x51): operation_insert();
            (0x02, 0x51): operation_insert();
            (0x03, 0x51): operation_insertAndCalc(77, 15);
            (0x00, 0x52): operation_insert();
            (0x01, 0x52): operation_insert();
            (0x02, 0x52): operation_insert();
            (0x03, 0x52): operation_insertAndCalc(78, 15);
            (0x00, 0x53): operation_insert();
            (0x01, 0x53): operation_insert();
            (0x02, 0x53): operation_insert();
            (0x03, 0x53): operation_insertAndCalc(79, 15);
            (0x00, 0x54): operation_insert();
            (0x01, 0x54): operation_insert();
            (0x02, 0x54): operation_insert();
            (0x03, 0x54): operation_insertAndCalcAndSend(80, 16, 15);
            (0x00, 0x55): operation_insert();
            (0x01, 0x55): operation_insert();
            (0x02, 0x55): operation_insert();
            (0x03, 0x55): operation_insertAndCalc(81, 16);
            (0x00, 0x56): operation_insert();
            (0x01, 0x56): operation_insert();
            (0x02, 0x56): operation_insert();
            (0x03, 0x56): operation_insertAndCalc(82, 16);
            (0x00, 0x57): operation_insert();
            (0x01, 0x57): operation_insert();
            (0x02, 0x57): operation_insert();
            (0x03, 0x57): operation_insertAndCalc(83, 16);
            (0x00, 0x58): operation_insert();
            (0x01, 0x58): operation_insert();
            (0x02, 0x58): operation_insert();
            (0x03, 0x58): operation_insertAndCalc(84, 16);
            (0x00, 0x59): operation_insert();
            (0x01, 0x59): operation_insert();
            (0x02, 0x59): operation_insert();
            (0x03, 0x59): operation_insertAndCalcAndSend(85, 17, 16);
            (0x00, 0x5a): operation_insert();
            (0x01, 0x5a): operation_insert();
            (0x02, 0x5a): operation_insert();
            (0x03, 0x5a): operation_insertAndCalc(86, 17);
            (0x00, 0x5b): operation_insert();
            (0x01, 0x5b): operation_insert();
            (0x02, 0x5b): operation_insert();
            (0x03, 0x5b): operation_insertAndCalc(87, 17);
            (0x00, 0x5c): operation_insert();
            (0x01, 0x5c): operation_insert();
            (0x02, 0x5c): operation_insert();
            (0x03, 0x5c): operation_insertAndCalc(88, 17);
            (0x00, 0x5d): operation_insert();
            (0x01, 0x5d): operation_insert();
            (0x02, 0x5d): operation_insert();
            (0x03, 0x5d): operation_insertAndCalc(89, 17);
            (0x00, 0x5e): operation_insert();
            (0x01, 0x5e): operation_insert();
            (0x02, 0x5e): operation_insert();
            (0x03, 0x5e): operation_insertAndCalcAndSend(90, 18, 17);
            (0x00, 0x5f): operation_insert();
            (0x01, 0x5f): operation_insert();
            (0x02, 0x5f): operation_insert();
            (0x03, 0x5f): operation_insertAndCalc(91, 18);
            (0x00, 0x60): operation_insert();
            (0x01, 0x60): operation_insert();
            (0x02, 0x60): operation_insert();
            (0x03, 0x60): operation_insertAndCalc(92, 18);
            (0x00, 0x61): operation_insert();
            (0x01, 0x61): operation_insert();
            (0x02, 0x61): operation_insert();
            (0x03, 0x61): operation_insertAndCalc(93, 18);
            (0x00, 0x62): operation_insert();
            (0x01, 0x62): operation_insert();
            (0x02, 0x62): operation_insert();
            (0x03, 0x62): operation_insertAndCalc(94, 18);
            (0x00, 0x63): operation_insert();
            (0x01, 0x63): operation_insert();
            (0x02, 0x63): operation_insert();
            (0x03, 0x63): operation_insertAndCalcAndSend(95, 19, 18);
            (0x00, 0x64): operation_insert();
            (0x01, 0x64): operation_insert();
            (0x02, 0x64): operation_insert();
            (0x03, 0x64): operation_insertAndCalc(96, 19);
            (0x00, 0x65): operation_insert();
            (0x01, 0x65): operation_insert();
            (0x02, 0x65): operation_insert();
            (0x03, 0x65): operation_insertAndCalc(97, 19);
            (0x00, 0x66): operation_insert();
            (0x01, 0x66): operation_insert();
            (0x02, 0x66): operation_insert();
            (0x03, 0x66): operation_insertAndCalc(98, 19);
            (0x00, 0x67): operation_insert();
            (0x01, 0x67): operation_insert();
            (0x02, 0x67): operation_insert();
            (0x03, 0x67): operation_insertAndCalc(99, 19);
            (0x00, 0x68): operation_insert();
            (0x01, 0x68): operation_insert();
            (0x02, 0x68): operation_insert();
            (0x03, 0x68): operation_insertAndCalcAndSend(100, 20, 19);
            (0x00, 0x69): operation_insert();
            (0x01, 0x69): operation_insert();
            (0x02, 0x69): operation_insert();
            (0x03, 0x69): operation_insertAndCalc(101, 20);
            (0x00, 0x6a): operation_insert();
            (0x01, 0x6a): operation_insert();
            (0x02, 0x6a): operation_insert();
            (0x03, 0x6a): operation_insertAndCalc(102, 20);
            (0x00, 0x6b): operation_insert();
            (0x01, 0x6b): operation_insert();
            (0x02, 0x6b): operation_insert();
            (0x03, 0x6b): operation_insertAndCalc(103, 20);
            (0x00, 0x6c): operation_insert();
            (0x01, 0x6c): operation_insert();
            (0x02, 0x6c): operation_insert();
            (0x03, 0x6c): operation_insertAndCalc(104, 20);
            (0x00, 0x6d): operation_insert();
            (0x01, 0x6d): operation_insert();
            (0x02, 0x6d): operation_insert();
            (0x03, 0x6d): operation_insertAndCalcAndSend(105, 21, 20);
            (0x00, 0x6e): operation_insert();
            (0x01, 0x6e): operation_insert();
            (0x02, 0x6e): operation_insert();
            (0x03, 0x6e): operation_insertAndCalc(106, 21);
            (0x00, 0x6f): operation_insert();
            (0x01, 0x6f): operation_insert();
            (0x02, 0x6f): operation_insert();
            (0x03, 0x6f): operation_insertAndCalc(107, 21);
            (0x00, 0x70): operation_insert();
            (0x01, 0x70): operation_insert();
            (0x02, 0x70): operation_insert();
            (0x03, 0x70): operation_insertAndCalc(108, 21);
            (0x00, 0x71): operation_insert();
            (0x01, 0x71): operation_insert();
            (0x02, 0x71): operation_insert();
            (0x03, 0x71): operation_insertAndCalc(109, 21);
            (0x00, 0x72): operation_insert();
            (0x01, 0x72): operation_insert();
            (0x02, 0x72): operation_insert();
            (0x03, 0x72): operation_insertAndCalcAndSend(110, 22, 21);
            (0x00, 0x73): operation_insert();
            (0x01, 0x73): operation_insert();
            (0x02, 0x73): operation_insert();
            (0x03, 0x73): operation_insertAndCalc(111, 22);
            (0x00, 0x74): operation_insert();
            (0x01, 0x74): operation_insert();
            (0x02, 0x74): operation_insert();
            (0x03, 0x74): operation_insertAndCalc(112, 22);
            (0x00, 0x75): operation_insert();
            (0x01, 0x75): operation_insert();
            (0x02, 0x75): operation_insert();
            (0x03, 0x75): operation_insertAndCalc(113, 22);
            (0x00, 0x76): operation_insert();
            (0x01, 0x76): operation_insert();
            (0x02, 0x76): operation_insert();
            (0x03, 0x76): operation_insertAndCalc(114, 22);
            (0x00, 0x77): operation_insert();
            (0x01, 0x77): operation_insert();
            (0x02, 0x77): operation_insert();
            (0x03, 0x77): operation_insertAndCalcAndSend(115, 23, 22);
            (0x00, 0x78): operation_insert();
            (0x01, 0x78): operation_insert();
            (0x02, 0x78): operation_insert();
            (0x03, 0x78): operation_insertAndCalc(116, 23);
            (0x00, 0x79): operation_insert();
            (0x01, 0x79): operation_insert();
            (0x02, 0x79): operation_insert();
            (0x03, 0x79): operation_insertAndCalc(117, 23);
            (0x00, 0x7a): operation_insert();
            (0x01, 0x7a): operation_insert();
            (0x02, 0x7a): operation_insert();
            (0x03, 0x7a): operation_insertAndCalc(118, 23);
            (0x00, 0x7b): operation_insert();
            (0x01, 0x7b): operation_insert();
            (0x02, 0x7b): operation_insert();
            (0x03, 0x7b): operation_insertAndCalc(119, 23);
            (0x00, 0x7c): operation_insert();
            (0x01, 0x7c): operation_insert();
            (0x02, 0x7c): operation_insert();
            (0x03, 0x7c): operation_insertAndCalcAndSend(120, 24, 23);
            (0x00, 0x7d): operation_insert();
            (0x01, 0x7d): operation_insert();
            (0x02, 0x7d): operation_insert();
            (0x03, 0x7d): operation_insertAndCalc(121, 24);
            (0x00, 0x7e): operation_insert();
            (0x01, 0x7e): operation_insert();
            (0x02, 0x7e): operation_insert();
            (0x03, 0x7e): operation_insertAndCalc(122, 24);
            (0x00, 0x7f): operation_insert();
            (0x01, 0x7f): operation_insert();
            (0x02, 0x7f): operation_insert();
            (0x03, 0x7f): operation_insertAndCalc(123, 24);
            (0x00, 0x80): operation_insert();
            (0x01, 0x80): operation_insert();
            (0x02, 0x80): operation_insert();
            (0x03, 0x80): operation_insertAndCalc(124, 24);
            (0x00, 0x81): operation_insert();
            (0x01, 0x81): operation_insert();
            (0x02, 0x81): operation_insert();
            (0x03, 0x81): operation_insertAndCalcAndSend(125, 25, 24);
            (0x00, 0x82): operation_insert();
            (0x01, 0x82): operation_insert();
            (0x02, 0x82): operation_insert();
            (0x03, 0x82): operation_insertAndCalc(126, 25);
            (0x00, 0x83): operation_insert();
            (0x01, 0x83): operation_insert();
            (0x02, 0x83): operation_insert();
            (0x03, 0x83): operation_insertAndCalc(127, 25);
            (0x00, 0x84): operation_insert();
            (0x01, 0x84): operation_insert();
            (0x02, 0x84): operation_insert();
            (0x03, 0x84): operation_insertAndCalc(128, 25);
            (0x00, 0x85): operation_insert();
            (0x01, 0x85): operation_insert();
            (0x02, 0x85): operation_insert();
            (0x03, 0x85): operation_insertAndCalc(129, 25);
            (0x00, 0x86): operation_insert();
            (0x01, 0x86): operation_insert();
            (0x02, 0x86): operation_insert();
            (0x03, 0x86): operation_insertAndCalcAndSend(130, 26, 25);
            (0x00, 0x87): operation_insert();
            (0x01, 0x87): operation_insert();
            (0x02, 0x87): operation_insert();
            (0x03, 0x87): operation_insertAndCalc(131, 26);
            (0x00, 0x88): operation_insert();
            (0x01, 0x88): operation_insert();
            (0x02, 0x88): operation_insert();
            (0x03, 0x88): operation_insertAndCalc(132, 26);
            (0x00, 0x89): operation_insert();
            (0x01, 0x89): operation_insert();
            (0x02, 0x89): operation_insert();
            (0x03, 0x89): operation_insertAndCalc(133, 26);
            (0x00, 0x8a): operation_insert();
            (0x01, 0x8a): operation_insert();
            (0x02, 0x8a): operation_insert();
            (0x03, 0x8a): operation_insertAndCalc(134, 26);
            (0x00, 0x8b): operation_insert();
            (0x01, 0x8b): operation_insert();
            (0x02, 0x8b): operation_insert();
            (0x03, 0x8b): operation_insertAndCalcAndSend(135, 27, 26);
            (0x00, 0x8c): operation_insert();
            (0x01, 0x8c): operation_insert();
            (0x02, 0x8c): operation_insert();
            (0x03, 0x8c): operation_insertAndCalc(136, 27);
            (0x00, 0x8d): operation_insert();
            (0x01, 0x8d): operation_insert();
            (0x02, 0x8d): operation_insert();
            (0x03, 0x8d): operation_insertAndCalc(137, 27);
            (0x00, 0x8e): operation_insert();
            (0x01, 0x8e): operation_insert();
            (0x02, 0x8e): operation_insert();
            (0x03, 0x8e): operation_insertAndCalc(138, 27);
            (0x00, 0x8f): operation_insert();
            (0x01, 0x8f): operation_insert();
            (0x02, 0x8f): operation_insert();
            (0x03, 0x8f): operation_insertAndCalc(139, 27);
            (0x00, 0x90): operation_insert();
            (0x01, 0x90): operation_insert();
            (0x02, 0x90): operation_insert();
            (0x03, 0x90): operation_insertAndCalcAndSend(140, 28, 27);
            (0x00, 0x91): operation_insert();
            (0x01, 0x91): operation_insert();
            (0x02, 0x91): operation_insert();
            (0x03, 0x91): operation_insertAndCalc(141, 28);
            (0x00, 0x92): operation_insert();
            (0x01, 0x92): operation_insert();
            (0x02, 0x92): operation_insert();
            (0x03, 0x92): operation_insertAndCalc(142, 28);
            (0x00, 0x93): operation_insert();
            (0x01, 0x93): operation_insert();
            (0x02, 0x93): operation_insert();
            (0x03, 0x93): operation_insertAndCalc(143, 28);
            (0x00, 0x94): operation_insert();
            (0x01, 0x94): operation_insert();
            (0x02, 0x94): operation_insert();
            (0x03, 0x94): operation_insertAndCalc(144, 28);
            (0x00, 0x95): operation_insert();
            (0x01, 0x95): operation_insert();
            (0x02, 0x95): operation_insert();
            (0x03, 0x95): operation_insertAndCalcAndSend(145, 29, 28);
            (0x00, 0x96): operation_insert();
            (0x01, 0x96): operation_insert();
            (0x02, 0x96): operation_insert();
            (0x03, 0x96): operation_insertAndCalc(146, 29);
            (0x00, 0x97): operation_insert();
            (0x01, 0x97): operation_insert();
            (0x02, 0x97): operation_insert();
            (0x03, 0x97): operation_insertAndCalc(147, 29);
            (0x00, 0x98): operation_insert();
            (0x01, 0x98): operation_insert();
            (0x02, 0x98): operation_insert();
            (0x03, 0x98): operation_insertAndCalc(148, 29);
            (0x00, 0x99): operation_insert();
            (0x01, 0x99): operation_insert();
            (0x02, 0x99): operation_insert();
            (0x03, 0x99): operation_insertAndCalc(149, 29);
            (0x00, 0x9a): operation_insert();
            (0x01, 0x9a): operation_insert();
            (0x02, 0x9a): operation_insert();
            (0x03, 0x9a): operation_insertAndCalcAndSend(150, 30, 29);
            (0x00, 0x9b): operation_insert();
            (0x01, 0x9b): operation_insert();
            (0x02, 0x9b): operation_insert();
            (0x03, 0x9b): operation_insertAndCalc(151, 30);
            (0x00, 0x9c): operation_insert();
            (0x01, 0x9c): operation_insert();
            (0x02, 0x9c): operation_insert();
            (0x03, 0x9c): operation_insertAndCalc(152, 30);
            (0x00, 0x9d): operation_insert();
            (0x01, 0x9d): operation_insert();
            (0x02, 0x9d): operation_insert();
            (0x03, 0x9d): operation_insertAndCalc(153, 30);
            (0x00, 0x9e): operation_insert();
            (0x01, 0x9e): operation_insert();
            (0x02, 0x9e): operation_insert();
            (0x03, 0x9e): operation_insertAndCalc(154, 30);
            (0x00, 0x9f): operation_insert();
            (0x01, 0x9f): operation_insert();
            (0x02, 0x9f): operation_insert();
            (0x03, 0x9f): operation_insertAndCalcAndSend(155, 31, 30);
            (0x00, 0xa0): operation_drop();
            (0x01, 0xa0): operation_drop();
            (0x02, 0xa0): operation_drop();
            (0x03, 0xa0): operation_drop();
            (0x00, 0xa1): operation_drop();
            (0x01, 0xa1): operation_drop();
            (0x02, 0xa1): operation_drop();
            (0x03, 0xa1): operation_drop();

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
