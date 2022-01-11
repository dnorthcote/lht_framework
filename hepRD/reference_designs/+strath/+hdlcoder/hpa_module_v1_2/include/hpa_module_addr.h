/*
 * File Name:         hdl_prj\ipcore\hpa_module_v1_2\include\hpa_module_addr.h
 * Description:       C Header File
 * Created:           2021-12-20 09:42:20
*/

#ifndef HPA_MODULE_H_
#define HPA_MODULE_H_

#define  IPCore_Reset_hpa_module            0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_hpa_module           0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_hpa_module        0x8  //contains unique IP timestamp (yymmddHHMM): 2112200942
#define  AXI4_Reset_Data_hpa_module         0x100  //data register for Inport AXI4_Reset
#define  AXI4_ClockCycles_Data_hpa_module   0x104  //data register for Outport AXI4_ClockCycles
#define  AXI4_Overflow_Data_hpa_module      0x108  //data register for Outport AXI4_Overflow

#endif /* HPA_MODULE_H_ */
