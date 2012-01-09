--------------------- Basic XOR gate ---------------------------
-- This gate built with transmission gates
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_xor IS
  PORT( in_1,in_2,vdd,vss: IN STD_LOGIC;
        out_12: OUT STD_LOGIC);
END basic_xor;

ARCHITECTURE basic_xor_arch OF basic_xor IS
  SIGNAL interS1,interS2: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
U1:   inverter PORT MAP(in_2,vdd,vss,interS1);
U2:   inverter PORT MAP(in_1,vdd,vss,interS2);
U3:   transmGate PORT MAP(in_1,in_2,interS1,out_12);
U4:   transmGate PORT MAP(interS2,interS1,in_2,out_12);

END basic_xor_arch;
------------------------------------------------------------------