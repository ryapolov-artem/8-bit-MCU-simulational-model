------------------ Simple 4-In And-NOT -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_andNot4 IS
  PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out14: OUT STD_LOGIC);
END basic_andNot4;

ARCHITECTURE basic_andNot4_arch OF basic_andNot4 IS
  SIGNAL interS1,interS2,interS3: STD_LOGIC;
 
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;

  BEGIN
U1:    pFET PORT MAP(in_1,vdd,out14);
U2:    pFET PORT MAP(in_2,vdd,out14);
U3:    pFET PORT MAP(in_3,vdd,out14);
U4:    pFET PORT MAP(in_4,vdd,out14);

U5:    nFET PORT MAP(in_1,interS3,out14);
U6:    nFET PORT MAP(in_2,interS2,interS3);
U7:    nFET PORT MAP(in_3,interS1,interS2);
U8:    nFET PORT MAP(in_4,vss,interS1);

END basic_andNot4_arch;
------------------------------------------------------------------
