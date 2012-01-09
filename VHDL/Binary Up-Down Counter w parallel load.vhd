----------------------- Binary Up-Down counter w parallel load ----------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY binary_up_down_counter_w_pload IS
  PORT(data_in     : IN STD_LOGIC_VECTOR(7 downto 0);
       clock,count : IN STD_LOGIC;
       down_count  : IN STD_LOGIC;
       load,clear  : IN STD_LOGIC; --CLEAR active level 0
       vdd,vss     : IN STD_LOGIC;
       q_out       : INOUT STD_LOGIC_VECTOR(7 downto 0);
       q_inv_out   : INOUT STD_LOGIC_VECTOR(7 downto 0);
       overflow    : INOUT STD_LOGIC);
END binary_up_down_counter_w_pload;

ARCHITECTURE binary_up_down_counter_w_pload_arch OF binary_up_down_counter_w_pload IS
  SIGNAL sum_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL mux_out_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL carry_word : STD_LOGIC_VECTOR(6 DOWNTO 0);
  
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
           out_12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT half_adder_substractor_cell
    PORT( in_a,in_carry,in_down,vdd,vss: IN STD_LOGIC;
        out_carry, out_sum: OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC; clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;

  BEGIN

Bits_from_6to1: FOR i IN 6 DOWNTO 1 GENERATE
    
Um:    mux_2to1 PORT MAP( sum_word(i),data_in(i),load,vdd,vss,mux_out_word(i));
Ud:    d_trigger_res PORT MAP(mux_out_word(i),clock,clear,vdd,vss,q_out(i),q_inv_out(i));
Uhalf: half_adder_substractor_cell PORT MAP(q_out(i),carry_word(i-1),down_count,
                        vdd,vss,carry_word(i), sum_word(i));
               
  END GENERATE Bits_from_6to1;
  
Umux0:    mux_2to1 PORT MAP( sum_word(0),data_in(0),load,vdd,vss,mux_out_word(0));
Udtrg0:   d_trigger_res PORT MAP(mux_out_word(0),clock,clear,vdd,vss,q_out(0),q_inv_out(0));
Uhalf0:   half_adder_substractor_cell PORT MAP(q_out(0),count,down_count,
                        vdd,vss,carry_word(0), sum_word(0));
                        
Umux7:    mux_2to1 PORT MAP( sum_word(7),data_in(7),load,vdd,vss,mux_out_word(7));
Udtrg7:   d_trigger_res PORT MAP(mux_out_word(7),clock,clear,vdd,vss,q_out(7),q_inv_out(7));
Uhalf7:   half_adder_substractor_cell PORT MAP(q_out(7),carry_word(6),down_count,
                        vdd,vss,overflow, sum_word(7));

END binary_up_down_counter_w_pload_arch;
------------------------------------------------------------------