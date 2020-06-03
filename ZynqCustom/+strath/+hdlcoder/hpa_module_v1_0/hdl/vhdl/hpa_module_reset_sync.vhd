-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\hpa_module\hpa_module_reset_sync.vhd
-- Created: 2020-06-01 11:57:08
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: hpa_module_reset_sync
-- Source Path: hpa_module/hpa_module_reset_sync
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hpa_module_reset_sync IS
  PORT( clk                               :   IN    std_logic;
        reset_in                          :   IN    std_logic;  -- ufix1
        reset_out                         :   OUT   std_logic  -- ufix1
        );
END hpa_module_reset_sync;


ARCHITECTURE rtl OF hpa_module_reset_sync IS

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL const_0                          : std_logic;  -- ufix1
  SIGNAL const_1_1                        : std_logic;  -- ufix1
  SIGNAL reset_pipe                       : std_logic;  -- ufix1

BEGIN
  const_0 <= '0';

  const_1_1 <= '1';

  enb <= const_1_1;

  reg_reset_pipe_process : PROCESS (clk, reset_in)
  BEGIN
    IF reset_in = '1' THEN
      reset_pipe <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        reset_pipe <= const_0;
      END IF;
    END IF;
  END PROCESS reg_reset_pipe_process;


  reg_reset_delay_process : PROCESS (clk, reset_in)
  BEGIN
    IF reset_in = '1' THEN
      reset_out <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        reset_out <= reset_pipe;
      END IF;
    END IF;
  END PROCESS reg_reset_delay_process;


END rtl;

