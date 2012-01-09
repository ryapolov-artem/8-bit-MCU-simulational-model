------------------ Simple 2-In And ----------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY basic_and2 IS
  PORT(in_1,in_2: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       out12: OUT STD_LOGIC);
END basic_and2;

ARCHITECTURE basic_and2_arch OF basic_and2 IS
  SIGNAL interS1: STD_LOGIC;

  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
    
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT; 

  BEGIN
U1:    basic_andNot2 PORT MAP (in_1,in_2,vdd,vss,interS1);
U2:    inverter PORT MAP(interS1,vdd,vss,out12);
  
END basic_and2_arch;
------------------------------------------------------------------
