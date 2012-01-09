----------------------- 8-bit program counter ----------------------
-- Counter up/down with parallel load
-- PC address is '0000 0110'

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY program_counter IS
  PORT(data_bus    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       clock,count : IN STD_LOGIC;
       down_count  : IN STD_LOGIC;
       clear       : IN STD_LOGIC; --CLEAR active level 0   -- load, deleted
       vdd,vss     : IN STD_LOGIC;
       q_out       : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       overflow    : INOUT STD_LOGIC);
END program_counter;

ARCHITECTURE program_counter OF program_counter IS
  SIGNAL sum_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL mux_out_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL carry_word : STD_LOGIC_VECTOR(6 DOWNTO 0);
  
  SIGNAL addr_en_signal: STD_LOGIC;
  SIGNAL read_signal: STD_LOGIC;
  SIGNAL write_signal: STD_LOGIC;
  
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

-- Components for enabling loading/reading data
-- Address decoder  
  COMPONENT pc_addr_decoder
    PORT( addr_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          vdd,vss   : IN STD_LOGIC;
          out_signal: OUT STD_LOGIC);
  END COMPONENT;
-- 2-input AND gate
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
-- Tri-state buffer for enabling the passing data to data bus
  COMPONENT tri_state_buffer_tg -- opens with enable = '1'
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC; data_out: OUT STD_LOGIC);
  END COMPONENT;
 
 
  BEGIN
U1:   pc_addr_decoder PORT MAP (addr_bus,vdd,vss,addr_en_signal);
U2:   basic_and2 PORT MAP(addr_en_signal,ctrl_bus(0),vdd,vss,read_signal);   -- ctrl bus combination '01' enables reading
U3:   basic_and2 PORT MAP(addr_en_signal,ctrl_bus(1),vdd,vss,write_signal);  -- ctrl bus combination '10' enables writing

-- Tri-state buffers which allow to read data from program counter
Read_buffers:  FOR k IN 7 DOWNTO 0 GENERATE
  Uk: tri_state_buffer_tg PORT MAP(q_out(k), read_signal, vdd, vss, data_bus(k));
  END GENERATE Read_buffers;
 
Bits_from_6to1: FOR i IN 6 DOWNTO 1 GENERATE
  Um:    mux_2to1 PORT MAP( sum_word(i),data_bus(i),write_signal,vdd,vss,mux_out_word(i));
  Ud:    d_trigger_res PORT MAP(mux_out_word(i),clock,clear,vdd,vss,q_out(i));
  Uhalf: half_adder_substractor_cell PORT MAP(q_out(i),carry_word(i-1),down_count,vdd,vss,carry_word(i),sum_word(i));
  END GENERATE Bits_from_6to1;

-- bit 0  
Umux0:    mux_2to1 PORT MAP( sum_word(0),data_bus(0),write_signal,vdd,vss,mux_out_word(0));
Udtrg0:   d_trigger_res PORT MAP(mux_out_word(0),clock,clear,vdd,vss,q_out(0));
Uhalf0:   half_adder_substractor_cell PORT MAP(q_out(0),count,down_count,vdd,vss,carry_word(0), sum_word(0));

-- bit 7                        
Umux7:    mux_2to1 PORT MAP( sum_word(7),data_bus(7),write_signal,vdd,vss,mux_out_word(7));
Udtrg7:   d_trigger_res PORT MAP(mux_out_word(7),clock,clear,vdd,vss,q_out(7));
Uhalf7:   half_adder_substractor_cell PORT MAP(q_out(7),carry_word(6),down_count,vdd,vss,overflow, sum_word(7));

END program_counter;
------------------------------------------------------------------