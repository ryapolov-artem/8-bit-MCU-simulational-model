------------------ Simple 4-In Or-NOT -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_orNot4 IS
  PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out14: OUT STD_LOGIC);
END basic_orNot4;

ARCHITECTURE basic_orNot4_arch OF basic_orNot4 IS
  SIGNAL interS1,interS2,interS3: STD_LOGIC;
 
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;

  BEGIN
U1:    pFET PORT MAP(in_1,vdd,interS1);
U2:    pFET PORT MAP(in_2,interS1,interS2);
U3:    pFET PORT MAP(in_3,interS2,interS3);
U4:    pFET PORT MAP(in_4,interS3,out14);

U5:    nFET PORT MAP(in_1,vss,out14);
U6:    nFET PORT MAP(in_2,vss,out14);
U7:    nFET PORT MAP(in_3,vss,out14);
U8:    nFET PORT MAP(in_4,vss,out14);
  
END basic_orNot4_arch;
------------------------------------------------------------------

