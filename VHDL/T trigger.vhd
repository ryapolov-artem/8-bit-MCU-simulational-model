------------------- T-trigger (clock divider) -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 6, page 154 / 341 in PDF file
-- 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY t_trigger IS
  PORT(t_in,clk_in,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END t_trigger;

ARCHITECTURE t_trigger_arch OF t_trigger IS
  SIGNAL interS1,interS2,interS3: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_xor
    PORT( in_1,in_2,vdd,vss: IN STD_LOGIC;
          out_12: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    transmGate PORT MAP(interS3,interS1,clk_in,interS2);
U2:    inverter PORT MAP(clk_in,vdd,vss,interS1);         --makes inverted clk signal
U3:    inverter PORT MAP(interS2,vdd,vss,q_inv_out);
U4:    inverter PORT MAP(q_inv_out,vdd,vss,q_out);
U5:    transmGate PORT MAP(q_out,clk_in,interS1,interS2);
U6:    basic_xor PORT MAP(q_out,t_in,vdd,vss,interS3);
  
END t_trigger_arch;
------------------------------------------------------------------
