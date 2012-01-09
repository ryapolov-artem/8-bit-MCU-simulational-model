------------------ Simple 2-In And-NOT -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_andNot2 IS
  PORT(in_1,in_2: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out12: OUT STD_LOGIC);
END basic_andNot2;

ARCHITECTURE basic_andNot2_arch OF basic_andNot2 IS
  SIGNAL interS1: STD_LOGIC;
 
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;

  BEGIN
U1:    pFET PORT MAP(in_1,vdd,out12);
U2:    pFET PORT MAP(in_2,vdd,out12);
U3:    nFET PORT MAP(in_1,interS1,out12);
U4:    nFET PORT MAP(in_2,vss,interS1);
  
END basic_andNot2_arch;
------------------------------------------------------------------