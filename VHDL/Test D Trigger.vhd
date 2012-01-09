------------------------ Testing D-trigger  -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY test_d_trigger IS
  PORT(d_in: IN STD_LOGIC;
       clk_in,vdd,vss: IN STD_LOGIC;
      q_out,q_inv_out: INOUT STD_LOGIC);
END test_d_trigger;

ARCHITECTURE test_d_trigger OF test_d_trigger IS
  SIGNAL clk_inv: STD_LOGIC;
 
  COMPONENT test_inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    transmGate PORT MAP(d_in,clk_inv,clk_in,q_out);
U2:    test_inverter PORT MAP(clk_in,vdd,vss,clk_inv);         --makes inverted clk signal
U3:    test_inverter PORT MAP(q_out,vdd,vss,q_inv_out);
U4:    test_inverter PORT MAP(q_inv_out,vdd,vss,q_out);
--U5:    transmGate PORT MAP(q_out,clk_in,clk_inv,interS1);

U6:    transmGate PORT MAP(vdd,q_inv_out,q_out,q_out);
U7:    transmGate PORT MAP(vdd,q_out,q_inv_out,q_inv_out);
  
END test_d_trigger;
------------------------------------------------------------------