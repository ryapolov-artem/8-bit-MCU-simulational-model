------------------------ SR-Latch  -------------------------------
-- Hwang p.136

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sr_latch_w_enable IS
  PORT(s_in,r_in,enable: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END sr_latch_w_enable;

ARCHITECTURE sr_latch_w_enable OF sr_latch_w_enable IS
  SIGNAL interS1,interS2: STD_LOGIC;                          -- InterS1=S, interS2=R
 
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
  COMPONENT sr_latch
    PORT(s_in,r_in: IN STD_LOGIC;
         vdd,vss: IN STD_LOGIC;
         q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
U1:    sr_latch PORT MAP(interS1,interS2,vdd,vss,q_out,q_inv_out);
U2:    basic_andNot2 PORT MAP (s_in,enable,vdd,vss,interS1);
U3:    basic_andNot2 PORT MAP (r_in,enable,vdd,vss,interS2);
 
END sr_latch_w_enable;

------------------------------------------------------------------