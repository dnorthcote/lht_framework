# A PYNQ / Mathworks' HDL Coder Hough Evaluation Platform
This repository contains a [PYNQ](http://www.pynq.io/) (Python Productivity for Zynq) evaluation platform for Field Programmable Gate Array (FPGA) architectures of the Line Hough Transform (LHT). We name this system, the Hough Evaluation Platform (HEP). The HEP can calculate the time taken to process an image and is capable of inspecting the Hough Parameter Space (HPS) using PYNQ's signal tracing and visualisation capbilities. We also introduce a new quantitative measurement for analysing the HPSs produced from different LHT architectures. This measurement is named the Peak-to-Mean Vote Ratio (PMVR) and is useful for quantifying the ability to reliably extract and separate peaks in the HPS from other neighbouring locations.

The HEP uses a Mathworks' HDL Coder reference design for the rapid prototyping and evaluation of LHT architectures. The reference design currently targets the Xilinx ZCU104 development board. Additional platforms will be supported at a later date. See Quick Start to quickly evaluate the HEP using your own ZCU104 development board. Alternatively, you can learn how to use the [HEP reference design](#how-to-use-the-hep-reference-design).

## Quick Start

## How to use the HEP Reference Design
