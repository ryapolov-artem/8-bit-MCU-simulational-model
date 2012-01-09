----------------------- Binary Up counter --------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY binary_up_counter IS
  PORT(clock,count : IN STD_LOGIC;
       clear       : IN STD_LOGIC; --CLEAR active level 0
       vdd,vss     : IN STD_LOGIC;
       q_out       : INOUT STD_LOGIC_VECTOR(7 downto 0);
       q_inv_out   : INOUT STD_LOGIC_VECTOR(7 downto 0);
       overflow    : INOUT STD_LOGIC);
END binary_up_counter;

ARCHITECTURE binary_up_counter_arch OF  binary_up_counter IS
  SIGNAL sum_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL carry_word : STD_LOGIC_VECTOR(6 DOWNTO 0);
  
  COMPONENT half_adder_cell
    PORT( in_a,in_carry,vdd,vss: IN STD_LOGIC;
        out_carry, out_sum: INOUT STD_LOGIC);
  END COMPONENT;

  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC; clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;

  BEGIN

Bits_from_6to1: FOR i IN 6 DOWNTO 1 GENERATE
    
Ud:    d_trigger_res PORT MAP(sum_word(i),clock,clear,vdd,vss,q_out(i),q_inv_out(i));
Uhalf: half_adder_cell PORT MAP(q_out(i),carry_word(i-1),vdd,vss,carry_word(i),sum_word(i));
               
  END GENERATE Bits_from_6to1;
  
Udtrg0:   d_trigger_res PORT MAP(sum_word(0),clock,clear,vdd,vss,q_out(0),q_inv_out(0));
Uhalf0:   half_adder_cell PORT MAP(q_out(0),count,vdd,vss,carry_word(0),sum_word(0));
                        
Udtrg7:   d_trigger_res PORT MAP(sum_word(7),clock,clear,vdd,vss,q_out(7),q_inv_out(7));
Uhalf7:   half_adder_cell PORT MAP(q_out(7),carry_word(6),vdd,vss,overflow,sum_word(7));

END  binary_up_counter_arch;
------------------------------------------------------------------
