------------------------- Timer/Counter -------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY timer_counter_unit IS
  PORT(data_bus    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       reset       : IN STD_LOGIC;
       clk_in      : IN STD_LOGIC;
       ext_clk     : IN STD_LOGIC;
       vdd,vss     : IN STD_LOGIC;
       interrupt   : OUT STD_LOGIC);
END timer_counter_unit;

ARCHITECTURE timer_counter OF timer_counter_unit IS
 
 SIGNAL timer_counter,t_c_ctrl_reg: STD_LOGIC;
 SIGNAL t_c_read_enable,t_c_write_enable: STD_LOGIC;
 SIGNAL t_c_ctrl_reg_write_enable: STD_LOGIC;
 SIGNAL t_c_input_clock: STD_LOGIC;
 
 SIGNAL t_c_signal,t_c_inv_signal: STD_LOGIC_VECTOR(7 DOWNTO 0); -- t_c_inv_signal not used
 SIGNAL t_c_overflow: STD_LOGIC;
 SIGNAL t_c_clk: STD_LOGIC;
 SIGNAL prescaler_out: STD_LOGIC;
 SIGNAL prescaler_active,prescaler_count: STD_LOGIC;
 
 -- 0 - CLEAR   
 -- 1 - DIRECTION         1-down, 0-up
 -- 2 - START/STOP
 -- 3 - Prescaler bit 0
 -- 4 - Prescaler bit 1
 -- 5 - Prescaler bit 2
 -- 6 - Clock source: internal clk signal / external clk signal
 -- 7 - Timer/counter overflow interrupt enable
 SIGNAL control_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  COMPONENT timer_counter_addr_decoder
    PORT( addr_in        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          vdd,vss        : IN STD_LOGIC;
          timer_counter  : OUT STD_LOGIC;
          t_c_ctrl_reg   : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT binary_up_down_counter_w_pload
    PORT(data_in     : IN STD_LOGIC_VECTOR(7 downto 0);
         clock,count : IN STD_LOGIC;
         down_count  : IN STD_LOGIC;
         load,clear  : IN STD_LOGIC; --CLEAR active level 0
         vdd,vss     : IN STD_LOGIC;
         q_out       : INOUT STD_LOGIC_VECTOR(7 downto 0);
         q_inv_out   : INOUT STD_LOGIC_VECTOR(7 downto 0);
         overflow    : INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT timer_counter_prescaler
    PORT(clk_in,count  : IN STD_LOGIC;
         clear         : IN STD_LOGIC; --CLEAR active level 0
         prescaler_ctrl: IN STD_LOGIC_VECTOR(2 downto 0);
         vdd,vss       : IN STD_LOGIC;
         clk_out       : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT d_trigger_reset_enable
    PORT (d_in,enable,reset: IN STD_LOGIC;
                clk_in,vdd,vss: IN STD_LOGIC;
               q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
           out_12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_or3
    PORT(in_1,in_2,in_3: IN STD_LOGIC;
                vdd,vss: IN STD_LOGIC;
                  out13: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
-- Tri-state buffer for enabling the passing data to data bus
  COMPONENT tri_state_buffer_tg -- opens with enable = '1'
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC; data_out: OUT STD_LOGIC);
  END COMPONENT;

  BEGIN
    
U1:   timer_counter_addr_decoder PORT MAP(addr_bus,vdd,vss,timer_counter,t_c_ctrl_reg);

U2:   basic_and2 PORT MAP(timer_counter,ctrl_bus(0),vdd,vss,t_c_read_enable);  -- read T/C, ctrl bus '01'
U3:   basic_and2 PORT MAP(timer_counter,ctrl_bus(1),vdd,vss,t_c_write_enable); -- write T/C, ctrl bus '10'
U4:   basic_and2 PORT MAP(t_c_ctrl_reg,ctrl_bus(1),vdd,vss,t_c_ctrl_reg_write_enable); -- write T/C ctrl reg, ctrl bus '10'

U5:   binary_up_down_counter_w_pload PORT MAP(data_bus,t_c_input_clock,control_signal(2),control_signal(1),
                          t_c_write_enable,control_signal(0),vdd,vss,t_c_signal,t_c_inv_signal,t_c_overflow);
                          
--Generates eight D triggers
Timer_counter_ctrl_register: FOR i IN 7 DOWNTO 0 GENERATE
    U_t_c: d_trigger_reset_enable  PORT MAP(data_bus(i),t_c_ctrl_reg_write_enable,reset,clk_in,vdd,vss,control_signal(i));
    T_C_buffs: tri_state_buffer_tg PORT MAP(t_c_signal(i),t_c_read_enable,vdd,vss,data_bus(i));
  END GENERATE Timer_counter_ctrl_register;
  
U6:   mux_2to1 PORT MAP(clk_in,ext_clk,control_signal(6),vdd,vss,t_c_clk);
U7:   basic_or3 PORT MAP(control_signal(5),control_signal(4),control_signal(3),vdd,vss,prescaler_active);
U8:   basic_and2 PORT MAP(control_signal(2),prescaler_active,vdd,vss,prescaler_count);

U9:   timer_counter_prescaler PORT MAP(t_c_clk,prescaler_count,prescaler_count,
                  control_signal(5 DOWNTO 3),vdd,vss,prescaler_out);

U10:  mux_2to1 PORT MAP(t_c_clk,prescaler_out,prescaler_active,vdd,vss,t_c_input_clock);
U11:  basic_and2 PORT MAP(control_signal(7),t_c_overflow,vdd,vss,interrupt);

END timer_counter;
----------------------------------------------------------------------------------------