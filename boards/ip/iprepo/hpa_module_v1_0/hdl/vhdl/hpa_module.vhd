-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\hpa_module\hpa_module.vhd
-- Created: 2020-06-01 11:57:08
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: -1
-- Target subsystem base rate: -1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: hpa_module
-- Source Path: hpa_module
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hpa_module IS
  PORT( IPCORE_CLK                        :   IN    std_logic;  -- ufix1
        IPCORE_RESETN                     :   IN    std_logic;  -- ufix1
        s_img_axis_tvalid                 :   IN    std_logic;  -- ufix1
        s_img_axis_tdata                  :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        s_img_axis_tlast                  :   IN    std_logic;  -- ufix1
        s_hps_axis_tvalid                 :   IN    std_logic;  -- ufix1
        s_hps_axis_tdata                  :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        s_hps_axis_tlast                  :   IN    std_logic;  -- ufix1
        AXI4_Lite_ACLK                    :   IN    std_logic;  -- ufix1
        AXI4_Lite_ARESETN                 :   IN    std_logic;  -- ufix1
        AXI4_Lite_AWADDR                  :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        AXI4_Lite_AWVALID                 :   IN    std_logic;  -- ufix1
        AXI4_Lite_WDATA                   :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        AXI4_Lite_WSTRB                   :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        AXI4_Lite_WVALID                  :   IN    std_logic;  -- ufix1
        AXI4_Lite_BREADY                  :   IN    std_logic;  -- ufix1
        AXI4_Lite_ARADDR                  :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        AXI4_Lite_ARVALID                 :   IN    std_logic;  -- ufix1
        AXI4_Lite_RREADY                  :   IN    std_logic;  -- ufix1
        s_img_axis_tready                 :   OUT   std_logic;  -- ufix1
        s_hps_axis_tready                 :   OUT   std_logic;  -- ufix1
        AXI4_Lite_AWREADY                 :   OUT   std_logic;  -- ufix1
        AXI4_Lite_WREADY                  :   OUT   std_logic;  -- ufix1
        AXI4_Lite_BRESP                   :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        AXI4_Lite_BVALID                  :   OUT   std_logic;  -- ufix1
        AXI4_Lite_ARREADY                 :   OUT   std_logic;  -- ufix1
        AXI4_Lite_RDATA                   :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
        AXI4_Lite_RRESP                   :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        AXI4_Lite_RVALID                  :   OUT   std_logic  -- ufix1
        );
END hpa_module;


ARCHITECTURE rtl OF hpa_module IS

  -- Component Declarations
  COMPONENT hpa_module_reset_sync
    PORT( clk                             :   IN    std_logic;  -- ufix1
          reset_in                        :   IN    std_logic;  -- ufix1
          reset_out                       :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT hpa_module_axi_lite
    PORT( reset                           :   IN    std_logic;
          AXI4_Lite_ACLK                  :   IN    std_logic;  -- ufix1
          AXI4_Lite_ARESETN               :   IN    std_logic;  -- ufix1
          AXI4_Lite_AWADDR                :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          AXI4_Lite_AWVALID               :   IN    std_logic;  -- ufix1
          AXI4_Lite_WDATA                 :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          AXI4_Lite_WSTRB                 :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
          AXI4_Lite_WVALID                :   IN    std_logic;  -- ufix1
          AXI4_Lite_BREADY                :   IN    std_logic;  -- ufix1
          AXI4_Lite_ARADDR                :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          AXI4_Lite_ARVALID               :   IN    std_logic;  -- ufix1
          AXI4_Lite_RREADY                :   IN    std_logic;  -- ufix1
          read_ip_timestamp               :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          read_time_s                     :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          read_time_f                     :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          read_nz_loc                     :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          read_nz_sum                     :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          AXI4_Lite_AWREADY               :   OUT   std_logic;  -- ufix1
          AXI4_Lite_WREADY                :   OUT   std_logic;  -- ufix1
          AXI4_Lite_BRESP                 :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          AXI4_Lite_BVALID                :   OUT   std_logic;  -- ufix1
          AXI4_Lite_ARREADY               :   OUT   std_logic;  -- ufix1
          AXI4_Lite_RDATA                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          AXI4_Lite_RRESP                 :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          AXI4_Lite_RVALID                :   OUT   std_logic;  -- ufix1
          write_axi_enable                :   OUT   std_logic;  -- ufix1
          write_freq                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          write_rst                       :   OUT   std_logic;  -- ufix1
          reset_internal                  :   OUT   std_logic  -- ufix1
          );
  END COMPONENT;

  COMPONENT hpa_module_dut
    PORT( clk                             :   IN    std_logic;  -- ufix1
          reset                           :   IN    std_logic;
          dut_enable                      :   IN    std_logic;  -- ufix1
          freq                            :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          rst                             :   IN    std_logic;  -- ufix1
          s_img_axis_tvalid               :   IN    std_logic;  -- ufix1
          s_img_axis_tdata                :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          s_img_axis_tlast                :   IN    std_logic;  -- ufix1
          s_hps_axis_tvalid               :   IN    std_logic;  -- ufix1
          s_hps_axis_tdata                :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          s_hps_axis_tlast                :   IN    std_logic;  -- ufix1
          ce_out                          :   OUT   std_logic;  -- ufix1
          time_s                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          time_f                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          nz_loc                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          nz_sum                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
          s_img_axis_tready               :   OUT   std_logic;  -- ufix1
          s_hps_axis_tready               :   OUT   std_logic  -- ufix1
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : hpa_module_reset_sync
    USE ENTITY work.hpa_module_reset_sync(rtl);

  FOR ALL : hpa_module_axi_lite
    USE ENTITY work.hpa_module_axi_lite(rtl);

  FOR ALL : hpa_module_dut
    USE ENTITY work.hpa_module_dut(rtl);

  -- Signals
  SIGNAL reset                            : std_logic;
  SIGNAL ip_timestamp                     : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL reset_cm                         : std_logic;  -- ufix1
  SIGNAL reset_internal                   : std_logic;  -- ufix1
  SIGNAL reset_before_sync                : std_logic;  -- ufix1
  SIGNAL time_s_sig                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL time_f_sig                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nz_loc_sig                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nz_sum_sig                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL AXI4_Lite_BRESP_tmp              : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL AXI4_Lite_RDATA_tmp              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL AXI4_Lite_RRESP_tmp              : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL write_axi_enable                 : std_logic;  -- ufix1
  SIGNAL write_freq                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL write_rst                        : std_logic;  -- ufix1
  SIGNAL ce_out_sig                       : std_logic;  -- ufix1
  SIGNAL s_img_axis_tready_sig            : std_logic;  -- ufix1
  SIGNAL s_hps_axis_tready_sig            : std_logic;  -- ufix1

BEGIN
  u_hpa_module_reset_sync_inst : hpa_module_reset_sync
    PORT MAP( clk => IPCORE_CLK,  -- ufix1
              reset_in => reset_before_sync,  -- ufix1
              reset_out => reset
              );

  u_hpa_module_axi_lite_inst : hpa_module_axi_lite
    PORT MAP( reset => reset,
              AXI4_Lite_ACLK => AXI4_Lite_ACLK,  -- ufix1
              AXI4_Lite_ARESETN => AXI4_Lite_ARESETN,  -- ufix1
              AXI4_Lite_AWADDR => AXI4_Lite_AWADDR,  -- ufix16
              AXI4_Lite_AWVALID => AXI4_Lite_AWVALID,  -- ufix1
              AXI4_Lite_WDATA => AXI4_Lite_WDATA,  -- ufix32
              AXI4_Lite_WSTRB => AXI4_Lite_WSTRB,  -- ufix4
              AXI4_Lite_WVALID => AXI4_Lite_WVALID,  -- ufix1
              AXI4_Lite_BREADY => AXI4_Lite_BREADY,  -- ufix1
              AXI4_Lite_ARADDR => AXI4_Lite_ARADDR,  -- ufix16
              AXI4_Lite_ARVALID => AXI4_Lite_ARVALID,  -- ufix1
              AXI4_Lite_RREADY => AXI4_Lite_RREADY,  -- ufix1
              read_ip_timestamp => std_logic_vector(ip_timestamp),  -- ufix32
              read_time_s => time_s_sig,  -- ufix32
              read_time_f => time_f_sig,  -- ufix32
              read_nz_loc => nz_loc_sig,  -- ufix32
              read_nz_sum => nz_sum_sig,  -- ufix32
              AXI4_Lite_AWREADY => AXI4_Lite_AWREADY,  -- ufix1
              AXI4_Lite_WREADY => AXI4_Lite_WREADY,  -- ufix1
              AXI4_Lite_BRESP => AXI4_Lite_BRESP_tmp,  -- ufix2
              AXI4_Lite_BVALID => AXI4_Lite_BVALID,  -- ufix1
              AXI4_Lite_ARREADY => AXI4_Lite_ARREADY,  -- ufix1
              AXI4_Lite_RDATA => AXI4_Lite_RDATA_tmp,  -- ufix32
              AXI4_Lite_RRESP => AXI4_Lite_RRESP_tmp,  -- ufix2
              AXI4_Lite_RVALID => AXI4_Lite_RVALID,  -- ufix1
              write_axi_enable => write_axi_enable,  -- ufix1
              write_freq => write_freq,  -- ufix32
              write_rst => write_rst,  -- ufix1
              reset_internal => reset_internal  -- ufix1
              );

  u_hpa_module_dut_inst : hpa_module_dut
    PORT MAP( clk => IPCORE_CLK,  -- ufix1
              reset => reset,
              dut_enable => write_axi_enable,  -- ufix1
              freq => write_freq,  -- ufix32
              rst => write_rst,  -- ufix1
              s_img_axis_tvalid => s_img_axis_tvalid,  -- ufix1
              s_img_axis_tdata => s_img_axis_tdata,  -- ufix32
              s_img_axis_tlast => s_img_axis_tlast,  -- ufix1
              s_hps_axis_tvalid => s_hps_axis_tvalid,  -- ufix1
              s_hps_axis_tdata => s_hps_axis_tdata,  -- ufix32
              s_hps_axis_tlast => s_hps_axis_tlast,  -- ufix1
              ce_out => ce_out_sig,  -- ufix1
              time_s => time_s_sig,  -- ufix32
              time_f => time_f_sig,  -- ufix32
              nz_loc => nz_loc_sig,  -- ufix32
              nz_sum => nz_sum_sig,  -- ufix32
              s_img_axis_tready => s_img_axis_tready_sig,  -- ufix1
              s_hps_axis_tready => s_hps_axis_tready_sig  -- ufix1
              );

  ip_timestamp <= to_unsigned(2006011157, 32);

  reset_cm <=  NOT IPCORE_RESETN;

  reset_before_sync <= reset_cm OR reset_internal;

  s_img_axis_tready <= s_img_axis_tready_sig;

  s_hps_axis_tready <= s_hps_axis_tready_sig;

  AXI4_Lite_BRESP <= AXI4_Lite_BRESP_tmp;

  AXI4_Lite_RDATA <= AXI4_Lite_RDATA_tmp;

  AXI4_Lite_RRESP <= AXI4_Lite_RRESP_tmp;

END rtl;
