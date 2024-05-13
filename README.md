# NetNN: Neural Intrusion Detection System in Programmable Networks
The rise of deep learning has led to various successful attempts to apply deep neural networks (DNNs) for important networking tasks such as intrusion detection. Yet, running DNNs in the network control plane, as typically done in existing proposals, suffers from high latency that impedes the practicality of such approaches. 
This paper introduces NetNN, a novel DNN-based intrusion detection system that runs completely in the network data plane to achieve low latency. NetNN adopts raw packet information as input, avoiding complicated feature engineering. NetNN mimics the DNN dataflow execution by mapping DNN parts to a network of programmable switches, executing partial DNN computations on individual switches, and generating packets carrying intermediate execution results between these switches. We implement NetNN in P4 and demonstrate the feasibility of such an approach. Experimental results show that NetNN can improve the intrusion detection accuracy to 99\% while meeting the real-time requirement.

## Project Structure
```
   +--+
   |h1|
   +--+
     |
   +--+
   |s0|
   +--+
     |
+----+----+----+----+
|    |    |    |    |
|    |    |    |    |
v    v    v    v    v
+----+  +----+  +----+  +----+
|s1_0|  |s1_1|  |s1_2|  |s1_3|
+----+  +----+  +----+  +----+
|    |  |    |  |    |  |    |
+----+--+----+--+----+--+----+
|    |  |    |  |    |  |    |
v    v  v    v  v    v  v    v
+----+  +----+  +----+  +----+
|s2_0|  |s2_1|  |s2_2|  |s2_3|
+----+  +----+  +----+  +----+
|    |  |    |  |    |  |    |
+----+--+----+--+----+--+----+
|    |  |    |  |    |  |    |
v    v  v    v  v    v  v    v
+----+  +----+  +----+  +----+
|s3_0|  |s3_1|  |s3_2|  |s3_3|
+----+  +----+  +----+  +----+
|    |  |    |  |    |  |    |
+----+--+----+--+----+--+----+
|    |  |    |  |    |  |    |
v    v  v    v  v    v  v    v
+----+  +----+  +----+  +----+
|s4_0|  |s4_1|  |s4_2|  |s4_3|
+----+  +----+  +----+  +----+
|    |  |    |  |    |  |    |
+----+----+----+----+----+
     |
   +--+
   |s5|
   +--+
     |
   +--+
   |h2|
   +--+

```
This diagram shows the hierarchical structure of the switches and hosts in your network. It starts from h1 connected to the root switch s0, which then connects to four s1_* switches, each of which further connects to four s2_* switches, and so on until the final layer of s4_* switches. The final s5 switch connects to h2.

## Project Setup Steps

### Required software

*Netnn* depends on the following software that needs to be installed before to be run. For install all the required software, you can follow the instructions in the [Installation](#Installation) section.

- [PI](https://github.com/p4lang/PI)
- [*Behavioral Model* (BMv2)](https://github.com/p4lang/behavioral-model)
- [P4C](https://github.com/p4lang/p4c)
- [*Mininet*](http://mininet.org/)
- [*FRRouting*](https://frrouting.org/)
- [*P4-Utils*](https://github.com/nsg-ethz/p4-utils)

### Installation 

To get started quickly and conveniently, you may want to install the P4-Tools suite using the following command:

```bash
curl -sSL https://raw.githubusercontent.com/nsg-ethz/p4-utils/master/install-tools/install-p4-dev.sh | bash

git clone https://github.com/nsg-ethz/p4-utils.git
cd p4-utils
sudo ./install.sh
```

### Running the project

To run the project, you can follow the steps below:

1. Start the Mininet topology:

```bash
sudo python3 network.py
```

2. Network should be fully up and running. You can now send all packets from h1:

```bash
h1 python3 sendAll.py
```

or send a single packet from h1: The index of the packet will be asked as input.

```bash
h1 python3 send.py
```

## Citation
Please use the following citation if you use this framework:

```
@TODO: add citation
```
