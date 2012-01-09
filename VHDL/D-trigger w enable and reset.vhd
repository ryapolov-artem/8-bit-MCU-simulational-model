------------------ D-trigger with reset and enable -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 6, page 12 of 27. Page 141 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY d_trigger_reset_enable IS
  PORT(d_in,enable,reset: IN STD_LOGIC;
       clk_in,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END d_trigger_reset_enable;

ARCHITECTURE d_trigger_reset_enable OF d_trigger_reset_enable IS
  SIGNAL interS1: STD_LOGIC;
 
  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC;
        clk_in,reset,vdd,vss: IN STD_LOGIC;
        q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
           out_12: OUT STD_LOGIC);
  END COMPONENT;
     
  BEGIN
U1:    mux_2to1  PORT MAP(q_out,d_in,enable,vdd,vss,interS1);
U2:    d_trigger_res  PORT MAP(interS1,clk_in,reset,vdd,vss,q_out,q_inv_out);
  
END d_trigger_reset_enable;
------------------------------------------------------------------