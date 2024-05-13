#!/usr/bin/env python3
import argparse
import sys
import socket
import random
import struct

from scapy.all import sendp, send, get_if_list, get_if_hwaddr, bind_layers
from scapy.all import Packet
from scapy.all import Ether, IP, UDP
from scapy.fields import *
import readline

class P4calc(Packet):
    name = "P4calc"
    fields_desc = [ StrFixedLenField("P", "P", length=1),
                    StrFixedLenField("Four", "4", length=1),
                    XByteField("version", 0x01),
                    
                    BitField("s1_index", 0, 32),
                    BitField("s1_max_pool_index", 0, 32),
                    BitField("s1_input_data", 0, 40),
                    BitField("s1_replication", 0, 32),
                    BitField("s1_res", 0, 64),
                    BitField("s2_replication", 0, 32),
                    BitField("s2_res", 0, 128),
                    BitField("s2_index", 0, 32),
                    BitField("s3_replication", 0, 32),
                    BitField("s3_res", 0, 104),
                    BitField("s4_replication", 0, 32),
                    BitField("s4_res", 0, 200),
                    BitField("s5_res", 0, 8),
                    
                    
                    ]
    
def get_if():
    ifs=get_if_list()
    iface=None
    for i in get_if_list():
        if "eth0" in i:
            iface=i
            break
    if not iface:
        print("Cannot find eth0 interface")
        exit(1)
    return iface


def main():

    iface = get_if()

    while True:
        s = input('index> ')
        s1_index = int(s)
        s1_max_pool_index = int(s) // 5
        pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff', type=0x1234) / P4calc(
                    s1_index=s1_index,
                    s1_max_pool_index=s1_max_pool_index,
                    s1_input_data=0x123456789abcdef0123456789abcdef0,
                    )
        sendp(pkt, iface=iface, verbose=False)

if __name__ == '__main__':
    main()