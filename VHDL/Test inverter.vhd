------------------------ Testing Inverter -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY test_inverter IS
  PORT(in_inv,vdd,vss: IN STD_LOGIC;
       out_inv: OUT STD_LOGIC);
END test_inverter;

ARCHITECTURE test_inverter OF test_inverter IS

  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  BEGIN
U1:    pFET PORT MAP(in_inv,vdd,out_inv);
U2:    nFET PORT MAP(in_inv,vss,out_inv);
U3:    pFET PORT MAP(in_inv,vss,out_inv);
U4:    nFET PORT MAP(in_inv,vdd,out_inv);

END test_inverter;
------------------------------------------------------------------