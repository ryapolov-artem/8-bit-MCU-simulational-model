------------------------ D-trigger  -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY d_trigger IS
  PORT(d_in: IN STD_LOGIC;
       clk_in,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END d_trigger;

ARCHITECTURE d_trigger_arch OF d_trigger IS
  SIGNAL interS1,interS2: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    transmGate PORT MAP(d_in,interS1,clk_in,interS2);
U2:    inverter PORT MAP(clk_in,vdd,vss,interS1);         --makes inverted clk signal
U3:    inverter PORT MAP(interS2,vdd,vss,q_inv_out);
U4:    inverter PORT MAP(q_inv_out,vdd,vss,q_out);
U5:    transmGate PORT MAP(q_out,clk_in,interS1,interS2);
  
END d_trigger_arch;
------------------------------------------------------------------
