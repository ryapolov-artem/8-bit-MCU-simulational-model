------------------------ D Latch w enable -------------------------------
-- Hwang p.137

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY d_latch_w_enable IS
  PORT(d_in,enable: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END d_latch_w_enable;

ARCHITECTURE d_latch_w_enable OF d_latch_w_enable IS
  SIGNAL interS1: STD_LOGIC;                       
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT sr_latch_w_enable
    PORT(s_in,r_in,enable: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
U1:    sr_latch_w_enable PORT MAP(d_in,interS1,enable,vdd,vss,q_out,q_inv_out);
U2:    inverter PORT MAP(d_in,vdd,vss,interS1);
 
END d_latch_w_enable;

------------------------------------------------------------------