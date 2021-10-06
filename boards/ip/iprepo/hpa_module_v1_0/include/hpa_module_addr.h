/*
 * File Name:         hdl_prj\ipcore\hpa_module_v1_0\include\hpa_module_addr.h
 * Description:       C Header File
 * Created:           2020-06-01 11:57:08
*/

#ifndef HPA_MODULE_H_
#define HPA_MODULE_H_

#define  IPCore_Reset_hpa_module       0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_hpa_module      0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_hpa_module   0x8  //contains unique IP timestamp (yymmddHHMM): 2006011157
#define  freq_Data_hpa_module          0x100  //data register for Inport freq
#define  rst_Data_hpa_module           0x104  //data register for Inport rst
#define  time_s_Data_hpa_module        0x108  //data register for Outport time_s
#define  time_f_Data_hpa_module        0x10C  //data register for Outport time_f
#define  nz_loc_Data_hpa_module        0x110  //data register for Outport nz_loc
#define  nz_sum_Data_hpa_module        0x114  //data register for Outport nz_sum

#endif /* HPA_MODULE_H_ */
