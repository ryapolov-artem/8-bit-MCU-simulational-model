------------------------ Testing D-trigger 2  -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY test_d_trigger_2 IS
  PORT(in_1,in_2,vdd,vss: IN STD_LOGIC;
       S1_out,S2_out: INOUT STD_LOGIC);
END test_d_trigger_2;

ARCHITECTURE test_d_trigger_2 OF test_d_trigger_2 IS
  
   COMPONENT basic_orNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
 BEGIN
U1:    basic_andNot2 PORT MAP (in_1,S2_out,vdd,vss,S1_out);
U2:    basic_orNot2 PORT MAP (S1_out,in_2,vdd,vss,S2_out);
END test_d_trigger_2;
------------------------------------------------------------------