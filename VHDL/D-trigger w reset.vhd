-------------------- D-trigger with reset -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY d_trigger_res IS
  PORT(d_in: IN STD_LOGIC;
       clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END d_trigger_res;

ARCHITECTURE d_trigger_res_arch OF d_trigger_res IS
  SIGNAL interS1,interS2,interS3,interS4,interS5: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    transmGate PORT MAP(d_in,clk_in,interS1,interS2);
U2:    basic_andNot2 PORT MAP(reset,interS2,vdd,vss,interS3);
U3:    inverter PORT MAP(interS3,vdd,vss,interS4);
U4:    transmGate PORT MAP(interS4,interS1,clk_in,interS2);
U5:    transmGate PORT MAP(interS3,interS1,clk_in,interS5);
U6:    inverter PORT MAP(interS5,vdd,vss,q_out);
U7:    basic_andNot2 PORT MAP(reset,q_out,vdd,vss,q_inv_out);
U8:    transmGate PORT MAP(q_inv_out,clk_in,interS1,interS5);
U9:    inverter PORT MAP(clk_in,vdd,vss,interS1);         --makes inverted clk signal


END d_trigger_res_arch;
--------------------------------------------------------------------------