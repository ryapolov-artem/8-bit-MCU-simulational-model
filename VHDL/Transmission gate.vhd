--------------------- Transmision gate ---------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY transmGate IS
  PORT( in_1: IN STD_LOGIC;
        p_gate,n_gate: IN STD_LOGIC;
        out_1: OUT STD_LOGIC);
END transmGate;

ARCHITECTURE transmGate_arch OF transmGate IS
  SIGNAL out_1S: STD_LOGIC;
  
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  BEGIN
U1:    pFET PORT MAP(p_gate,in_1,out_1S);
U2:    nFET PORT MAP(n_gate,in_1,out_1S);
Delay: out_1 <= out_1S after 1 ps;
END transmGate_arch;
------------------------------------------------------------------