------------------ Simple 4-In OR ----------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_or4 IS
  PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out14: OUT STD_LOGIC);
END basic_or4;

ARCHITECTURE basic_or4_arch OF basic_or4 IS
  SIGNAL interS1: STD_LOGIC;

  COMPONENT basic_orNot4
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT; 

  BEGIN
U1:    basic_orNot4 PORT MAP (in_1,in_2,in_3,in_4,vdd,vss,interS1);
U2:    inverter PORT MAP(interS1,vdd,vss,out14);
  
END basic_or4_arch;
------------------------------------------------------------------

