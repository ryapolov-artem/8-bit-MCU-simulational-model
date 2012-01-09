------------------------ D-Latch (Based on SR-latch)  -------------------------------
-- Hwang p.136

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY d_latch IS
  PORT(d_in: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END d_latch;

-- ARCH based on 2-input OR-NOT gates
ARCHITECTURE d_ornot_latch OF d_latch IS
  SIGNAL interS1: STD_LOGIC;
 
  COMPONENT basic_orNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
    
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
U1:    inverter PORT MAP(d_in,vdd,vss,interS1);
U2:    basic_orNot2 PORT MAP (interS1,q_inv_out,vdd,vss,q_out);
U3:    basic_orNot2 PORT MAP (q_out,d_in,vdd,vss,q_inv_out);
 
END d_ornot_latch;

-- ARCH based on 2-input AND-NOT gates
ARCHITECTURE d_andnot_latch OF d_latch IS
  SIGNAL interS1: STD_LOGIC;
 
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
U1:    inverter PORT MAP(d_in,vdd,vss,interS1);
U2:    basic_andNot2 PORT MAP (interS1,q_inv_out,vdd,vss,q_out);
U3:    basic_andNot2 PORT MAP (q_out,d_in,vdd,vss,q_inv_out);
 
END d_andnot_latch;
------------------------------------------------------------------