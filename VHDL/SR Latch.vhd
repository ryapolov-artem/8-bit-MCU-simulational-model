------------------------ SR-Latch  -------------------------------
-- Hwang p.133
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sr_latch IS
  PORT(s_in,r_in: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END sr_latch;

-- ARCH based on 2-input OR-NOT gates
ARCHITECTURE sr_ornot_latch OF sr_latch IS
 
  COMPONENT basic_orNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
    
  BEGIN
U1:    basic_orNot2 PORT MAP (s_in,q_out,vdd,vss,q_inv_out);
U2:    basic_orNot2 PORT MAP (q_inv_out,r_in,vdd,vss,q_out);
 
END sr_ornot_latch;
--
-- ARCH based on 2-input AND-NOT gates
--ARCHITECTURE sr_andnot_latch OF sr_latch IS
-- 
--  COMPONENT basic_andNot2
--    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
--  END COMPONENT; 
--    
--  BEGIN
--U1:    basic_andNot2 PORT MAP (s_in,q_out,vdd,vss,q_inv_out);
--U2:    basic_andNot2 PORT MAP (q_inv_out,r_in,vdd,vss,q_out);
-- 
--END sr_andnot_latch;
------------------------------------------------------------------