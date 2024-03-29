-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\hpa_module\hpa_module_src_Hough_Performance_Analyser.vhd
-- Created: 2021-12-20 09:42:18
-- 
-- Generated by MATLAB 9.8 and HDL Coder 3.16
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 6.66667e-09
-- Target subsystem base rate: 6.66667e-09
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        6.66667e-09
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- AXI4_ClockCycles              ce_out        6.66667e-09
-- AXI4_Overflow                 ce_out        6.66667e-09
-- s_img_axis_tready             ce_out        6.66667e-09
-- s_hps_axis_tready             ce_out        6.66667e-09
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: hpa_module_src_Hough_Performance_Analyser
-- Source Path: hpa_module/Hough Performance Analyser
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hpa_module_src_Hough_Performance_Analyser IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        AXI4_Reset                        :   IN    std_logic;
        s_img_axis_tvalid                 :   IN    std_logic;
        s_img_axis_tdata                  :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        s_img_axis_tlast                  :   IN    std_logic;
        s_hps_axis_tvalid                 :   IN    std_logic;
        s_hps_axis_tdata                  :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        s_hps_axis_tlast                  :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        AXI4_ClockCycles                  :   OUT   std_logic_vector(31 DOWNTO 0);  -- uint32
        AXI4_Overflow                     :   OUT   std_logic;
        s_img_axis_tready                 :   OUT   std_logic;
        s_hps_axis_tready                 :   OUT   std_logic
        );
END hpa_module_src_Hough_Performance_Analyser;


ARCHITECTURE rtl OF hpa_module_src_Hough_Performance_Analyser IS

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL AND_out1                         : std_logic;
  SIGNAL OR_out1                          : std_logic;
  SIGNAL Constant_out1                    : std_logic;
  SIGNAL Multiport_Switch_out1            : std_logic;
  SIGNAL Unit_Delay_Resettable_Synchronous_out1 : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL Unit_Delay_Enabled_Synchronous_out1 : std_logic;
  SIGNAL NOT_out1                         : std_logic;

BEGIN
  -- AXI4-Lite Registers
  -- 
  -- AXI4-Stream (User Design)
  -- 
  -- AXI4-Stream (Read DMA)

  AND_out1 <= s_hps_axis_tvalid AND s_hps_axis_tlast;

  OR_out1 <= AXI4_Reset OR AND_out1;

  enb <= clk_enable;

  Constant_out1 <= '1';

  Unit_Delay_Resettable_Synchronous_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay_Resettable_Synchronous_out1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        IF OR_out1 = '1' THEN
          Unit_Delay_Resettable_Synchronous_out1 <= '0';
        ELSE 
          Unit_Delay_Resettable_Synchronous_out1 <= Multiport_Switch_out1;
        END IF;
      END IF;
    END IF;
  END PROCESS Unit_Delay_Resettable_Synchronous_process;


  
  Multiport_Switch_out1 <= Unit_Delay_Resettable_Synchronous_out1 WHEN s_img_axis_tvalid = '0' ELSE
      Constant_out1;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 4294967295
  HDL_Counter_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HDL_Counter_out1 <= to_unsigned(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        IF AXI4_Reset = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(0, 32);
        ELSIF Multiport_Switch_out1 = '1' THEN 
          HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(1, 32);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  AXI4_ClockCycles <= std_logic_vector(HDL_Counter_out1);

  
  Compare_To_Constant_out1 <= '1' WHEN HDL_Counter_out1 = unsigned'(X"FFFFFFFF") ELSE
      '0';

  Unit_Delay_Enabled_Synchronous_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay_Enabled_Synchronous_out1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND Multiport_Switch_out1 = '1' THEN
        Unit_Delay_Enabled_Synchronous_out1 <= Compare_To_Constant_out1;
      END IF;
    END IF;
  END PROCESS Unit_Delay_Enabled_Synchronous_process;


  NOT_out1 <=  NOT AXI4_Reset;

  ce_out <= clk_enable;

  AXI4_Overflow <= Unit_Delay_Enabled_Synchronous_out1;

  s_img_axis_tready <= NOT_out1;

  s_hps_axis_tready <= NOT_out1;

END rtl;

