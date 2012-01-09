----------------------- RESET circuit --------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY reset_circuit IS
  PORT(reset,wdr     : IN STD_LOGIC;
       clk_in        : IN STD_LOGIC;
       vdd,vss       : IN STD_LOGIC;
       internal_reset: INOUT STD_LOGIC);
END reset_circuit;

ARCHITECTURE reset_circuit OF  reset_circuit IS
  SIGNAL inv_reset,set_signal,reset_signal,count_signal,counter_reset: STD_LOGIC;

  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT basic_orNot2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT sr_latch
    PORT(s_in,r_in: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT delay_counter
    PORT(clock,count : IN STD_LOGIC;
         clear       : IN STD_LOGIC; --CLEAR active level 0
         vdd,vss     : IN STD_LOGIC;
         q_out_2     : INOUT STD_LOGIC);
  END COMPONENT;

  BEGIN
U1:     inverter PORT MAP(reset,vdd,vss,inv_reset);
U2:     basic_orNot2 PORT MAP(inv_reset,wdr,vdd,vss,counter_reset);
U3:     delay_counter PORT MAP(clk_in,count_signal,counter_reset,vdd,vss,reset_signal);
U4:     inverter PORT MAP(reset_signal,vdd,vss,set_signal);
U5:     sr_latch PORT MAP(set_signal,reset_signal,vdd,vss,count_signal,internal_reset);

END  reset_circuit;
------------------------------------------------------------------