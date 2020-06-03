-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\hpa_module\hpa_module_src_Rising_Edge_Detector_Last.vhd
-- Created: 2020-06-01 11:57:03
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: hpa_module_src_Rising_Edge_Detector_Last
-- Source Path: hpa_module/hpa/Rising Edge Detector Last
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hpa_module_src_Rising_Edge_Detector_Last IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Input                             :   IN    std_logic;
        Output                            :   OUT   std_logic
        );
END hpa_module_src_Rising_Edge_Detector_Last;


ARCHITECTURE rtl OF hpa_module_src_Rising_Edge_Detector_Last IS

  -- Signals
  SIGNAL NOT_out1                         : std_logic;
  SIGNAL Delay_out1                       : std_logic;
  SIGNAL AND_out1                         : std_logic;

BEGIN
  NOT_out1 <=  NOT Input;

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_out1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay_out1 <= NOT_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  AND_out1 <= Delay_out1 AND Input;

  Output <= AND_out1;

END rtl;

