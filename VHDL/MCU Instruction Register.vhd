------------------------- Instruction Register -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Page 218 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY instruction_register IS
  PORT(load: IN STD_LOGIC;
       paral_input: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END instruction_register;

ARCHITECTURE instruction_register OF instruction_register IS
 
  COMPONENT d_trigger_reset_enable
    PORT (d_in,enable,reset: IN STD_LOGIC;
                clk_in,vdd,vss: IN STD_LOGIC;
               q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
--Generates sixteen D trigger registers with enable and reset
  D_triggers_w_enable_reset: FOR i IN 15 DOWNTO 0 GENERATE
    U1to8: d_trigger_reset_enable  PORT MAP(paral_input(i),load,reset,clk_in,vdd,vss,q_out(i));
  END GENERATE D_triggers_w_enable_reset;
  
END instruction_register;
------------------------------------------------------------------