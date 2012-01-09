------------------------ Inverter v.2 -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY inverter IS
  PORT(in_inv,vdd,vss: IN STD_LOGIC;
       out_inv: OUT STD_LOGIC);
END inverter;

ARCHITECTURE invert_arch OF inverter IS

  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  BEGIN
U1:    pFET PORT MAP(in_inv,vdd,out_inv);
U2:    nFET PORT MAP(in_inv,vss,out_inv);
  
END invert_arch;
------------------------------------------------------------------