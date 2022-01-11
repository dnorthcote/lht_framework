<img src="strathsdr_banner.png" width="100%">

# A Hough Evaluation Platform with PYNQ and Mathworks' HDL Coder
See the corresponding publication [here](https://pureportal.strath.ac.uk/en/publications/a-pynq-evaluation-platform-for-fpga-architectures-of-the-line-hou).

This repository contains a [PYNQ](http://www.pynq.io/) (Python Productivity for Zynq) evaluation platform for Field Programmable Gate Array (FPGA) architectures of the Line Hough Transform (LHT). This system is named the Hough Evaluation Platform (HEP). The HEP can calculate the time taken to apply the LHT to an image using a custom FPGA architecture and is capable of inspecting the Hough Parameter Space (HPS) using PYNQ's signal tracing and visualisation capbilities. The HEP can also calculate a new quantitative measurement for analysing the HPS produced from different LHT architectures. This measurement is named the Peak-to-Mean Vote Ratio (PMVR) and is useful for quantifying the ability to reliably extract and separate peaks in the HPS from other neighbouring locations.

<p align="center">
  <img src="./demonstration.gif" width="30%" height="30%" />
</p>

The HEP uses a Mathworks' HDL Coder reference design for the rapid prototyping and evaluation of LHT architectures. The reference design currently targets the Xilinx ZCU104 development board. Additional platforms will be supported at a later date. See Quick Start to quickly evaluate the HEP using your own ZCU104 development board. Alternatively, you can learn how to use the [HEP reference design](#how-to-use-the-hep-reference-design).

This repository is compatible with [PYNQ Image v2.7](https://github.com/Xilinx/PYNQ/releases) for the [ZCU104](https://www.xilinx.com/products/boards-and-kits/zcu104.html) development board.

The example notebook can be found [here](https://nbviewer.jupyter.org/github/dnorthcote/lht_framework/blob/master/boards/ZCU104/lht_framework/notebooks/hough-evaluation-platform.ipynb), although, there will be no interactivity as it must be used on the Zynq MPSoC device.

## Quick Start
The following steps will open a demonstration notebook for the HEP, which analyses an FPGA architecture that applies the LHT to an of 1920x1080 pixels.
* Load an SD Card with an image of PYNQ v2.7 loaded.
* Launch PYNQ v2.7 on the ZCU104 development board.
* Ensure that you have access to an internet connection from PYNQ.
* Open a Jupyter Lab session by navigating to http://\<pynq-ip-address\>:9090/lab in a standard web browser (preferably Google Chrome).
* In the Launcher tab, select Terminal to open a new command window.
* Run the following line of code to download the demonstration notebook.
```sh
pip3 install git+https://github.com/dnorthcote/lht_framework.git
```
* Once the download is complete, using Jupyter Lab, navigate to hep/default/notebooks and open the Hough Evaluation Platform notebook.
* You can now run the demonstration.

## How to use the HEP Reference Design
Users require MATLAB R2020a and Vivado 2020.1 installed on their system. The ZCU104 development board should also be loaded with an image of PYNQ v2.7. To begin, download the current PYNQ Hough Transform Support Package from the following link: https://github.com/dnorthcote/lht_framework/releases/

Launch MATLAB R2020a and setup the HDL toolpath to Vivado 2020.1. To do this, you will need to run the _hdlsetuptoolpath_ function in the MATLAB command window as below:
```sh
hdlsetuptoolpath('ToolName','Xilinx Vivado','ToolPath','<vivado-installation-directory>Xilinx/Vivado/2020.1/bin')
```
In MATLAB, navigate to the folder where you have downloaded the support package. Double-click the support package to install the HEP reference design and workflow. After installation, navigate to the help documentation for the HEP to open an example design.
