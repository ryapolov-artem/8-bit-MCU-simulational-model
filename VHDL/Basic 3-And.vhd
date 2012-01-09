------------------ Simple 3-In AND ----------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_and3 IS
  PORT(in_1,in_2,in_3: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out13: OUT STD_LOGIC);
END basic_and3;

ARCHITECTURE basic_and3_arch OF basic_and3 IS
  SIGNAL interS1: STD_LOGIC;

  COMPONENT basic_andNot3
    PORT(in_1,in_2,in_3: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT; 

  BEGIN
U1:    basic_andNot3 PORT MAP (in_1,in_2,in_3,vdd,vss,interS1);
U2:    inverter PORT MAP(interS1,vdd,vss,out13);
  
END basic_and3_arch;
------------------------------------------------------------------