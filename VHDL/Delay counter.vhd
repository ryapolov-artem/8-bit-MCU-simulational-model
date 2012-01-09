----------------------- Binary Up counter --------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY delay_counter IS
  PORT(clock,count : IN STD_LOGIC;
       clear       : IN STD_LOGIC; --CLEAR active level 0
       vdd,vss     : IN STD_LOGIC;
       q_out_2     : INOUT STD_LOGIC);
END delay_counter;

ARCHITECTURE delay_counter OF  delay_counter IS
  SIGNAL sum_word : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL carry_word : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL q_out    : STD_LOGIC_VECTOR(2 downto 0);
  SIGNAL q_inv_out: STD_LOGIC_VECTOR(2 downto 0);
  SIGNAL overflowS: STD_LOGIC;
  
  COMPONENT half_adder_cell
    PORT( in_a,in_carry,vdd,vss: IN STD_LOGIC;
        out_carry, out_sum: INOUT STD_LOGIC);
  END COMPONENT;

  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC; clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;

  BEGIN

Udtrg0:   d_trigger_res PORT MAP(sum_word(0),clock,clear,vdd,vss,q_out(0),q_inv_out(0));
Uhalf0:   half_adder_cell PORT MAP(q_out(0),count,vdd,vss,carry_word(0),sum_word(0));

Udtrg1:   d_trigger_res PORT MAP(sum_word(1),clock,clear,vdd,vss,q_out(1),q_inv_out(1));
Uhalf1:   half_adder_cell PORT MAP(q_out(1),carry_word(0),vdd,vss,carry_word(1),sum_word(1));
                        
Udtrg2:   d_trigger_res PORT MAP(sum_word(2),clock,clear,vdd,vss,q_out(2),q_inv_out(2));
Uhalf2:   half_adder_cell PORT MAP(q_out(2),carry_word(1),vdd,vss,overflowS,sum_word(2));

Output_signal: q_out_2 <= q_out(2);

END  delay_counter;
------------------------------------------------------------------