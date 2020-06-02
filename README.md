<img src="https://www.strath.ac.uk/media/1newwebsite/webteam/logos/xUoS_Logo_Horizontal.png.pagespeed.ic.M6gv_BmDx1.png" width="350">

# Hough Evaluation Platform with PYNQ and Mathworks' HDL Coder
This repository contains a [PYNQ](http://www.pynq.io/) (Python Productivity for Zynq) evaluation platform for Field Programmable Gate Array (FPGA) architectures of the Line Hough Transform (LHT). This system is named the Hough Evaluation Platform (HEP). The HEP can calculate the time taken to apply the LHT to an image using a custom FPGA architecture and is capable of inspecting the Hough Parameter Space (HPS) using PYNQ's signal tracing and visualisation capbilities. The HEP can also calculate a new quantitative measurement for analysing the HPSs produced from different LHT architectures. This measurement is named the Peak-to-Mean Vote Ratio (PMVR) and is useful for quantifying the ability to reliably extract and separate peaks in the HPS from other neighbouring locations.

<p align="center">
  <img src="../../blob/master/img/github_hps_gif.gif" width="610" height="586" />
<p/>

The HEP uses a Mathworks' HDL Coder reference design for the rapid prototyping and evaluation of LHT architectures. The reference design currently targets the Xilinx ZCU104 development board. Additional platforms will be supported at a later date. See Quick Start to quickly evaluate the HEP using your own ZCU104 development board. Alternatively, you can learn how to use the [HEP reference design](#how-to-use-the-hep-reference-design).

This repository is compatible with [PYNQ Image v2.5](https://github.com/Xilinx/PYNQ/releases) for the [ZCU104](https://www.xilinx.com/products/boards-and-kits/zcu104.html) development board.

## Quick Start
The following steps will open a demonstration notebook for the HEP, which analyses an FPGA architecture that applies the LHT to an of 1280x720 pixels.
* Load an SD Card with an image of PYNQ v2.5 loaded.
* Launch PYNQ v2.5 on the ZCU104 development board.
* Ensure that you have access to an internet connection from PYNQ.
* Open a Jupyter Lab session by navigating to http://<pynq-ip-address>:9090/lab in a standard web browser (preferably Google Chrome).
* In the Launcher tab, select Terminal to open a new command window.
* Run the following line of code to download the demonstration notebook.
```sh
pip3 install git+https://github.com/dnorthcote/lht_framework.git
```
* Once the download is complete, using Jupyter Lab, navigate to zcu104_hep/notebooks/ and open the Hough Evaluation Platform notebook.
* You can now run the demonstration.

## How to use the HEP Reference Design
Users require MATLAB R2019a and Vivado 2019.1 installed on their system.
