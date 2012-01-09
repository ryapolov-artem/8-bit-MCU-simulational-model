------------------ Simple 2-In Or-NOT -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_orNot2 IS
  PORT(in_1,in_2: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out12: OUT STD_LOGIC);
END basic_orNot2;

ARCHITECTURE basic_orNot2_arch OF basic_orNot2 IS
  SIGNAL interS1: STD_LOGIC;
 
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;

  BEGIN
U1:    pFET PORT MAP(in_1,vdd,interS1);
U2:    pFET PORT MAP(in_2,interS1,out12);
U3:    nFET PORT MAP(in_1,vss,out12);
U4:    nFET PORT MAP(in_2,vss,out12);
  
END basic_orNot2_arch;
------------------------------------------------------------------