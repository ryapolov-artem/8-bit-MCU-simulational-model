----------------------- Timer/counter prescaler --------------------------------
-- Prescaler ctrl - Dividing coefficient
-- 000 - 2
-- 001 - 4
-- 010 - 8
-- 011 - 16
-- 100 - 32
-- 101 - 64
-- 110 - 128
-- 111 - 256

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY timer_counter_prescaler IS
  PORT(clk_in,count  : IN STD_LOGIC;
       clear         : IN STD_LOGIC; --CLEAR active level 0
       prescaler_ctrl: IN STD_LOGIC_VECTOR(2 downto 0);
       vdd,vss       : IN STD_LOGIC;
       clk_out       : OUT STD_LOGIC);
END timer_counter_prescaler;

ARCHITECTURE timer_counter_prescaler OF  timer_counter_prescaler IS
  SIGNAL counter_out_word: STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  COMPONENT mux_8to1
  PORT( paral_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       select_input: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       vdd,vss: IN STD_LOGIC;
       out_8: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT binary_up_counter
    PORT(clock,count : IN STD_LOGIC;
         clear       : IN STD_LOGIC; --CLEAR active level 0
         vdd,vss     : IN STD_LOGIC;
         q_out       : INOUT STD_LOGIC_VECTOR(7 downto 0);
         q_inv_out   : INOUT STD_LOGIC_VECTOR(7 downto 0);
         overflow    : INOUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN

U1:   binary_up_counter PORT MAP(clk_in,count,clear,vdd,vss,counter_out_word);
U2:   mux_8to1 PORT MAP(counter_out_word,prescaler_ctrl,vdd,vss,clk_out);

END  timer_counter_prescaler;
------------------------------------------------------------------