------------------------- Watchdog timer -------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY watchdog_timer IS
  PORT(data_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       reset       : IN STD_LOGIC;
       clk_in      : IN STD_LOGIC;
       internal_clk: IN STD_LOGIC;
       vdd,vss     : IN STD_LOGIC;
       wd_overflow : INOUT STD_LOGIC);
END watchdog_timer;

ARCHITECTURE watchdog_timer OF watchdog_timer IS
 
 SIGNAL wd_ctrl_reg,wd_ctrl_reg_write_enable: STD_LOGIC;
 SIGNAL wd_input_clock: STD_LOGIC;
 
 SIGNAL wd_signal,wd_inv_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
 SIGNAL prescaler_out: STD_LOGIC;
 SIGNAL prescaler_active,prescaler_count: STD_LOGIC;
 
 -- 0 - CLEAR   
 -- 1 -           NOT USED
 -- 2 - START/STOP
 -- 3 - Prescaler bit 0
 -- 4 - Prescaler bit 1
 -- 5 - Prescaler bit 2
 -- 6 -           NOT USED
 -- 7 -           NOT USED
 SIGNAL control_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  COMPONENT wd_ctrl_reg_addr_decoder
    PORT( addr_in     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          vdd,vss     : IN STD_LOGIC;
          out_signal  : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT  binary_up_counter
  PORT(clock,count : IN STD_LOGIC;
       clear       : IN STD_LOGIC; --CLEAR active level 0
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
  
  BEGIN
U1:   wd_ctrl_reg_addr_decoder PORT MAP(addr_bus,vdd,vss,wd_ctrl_reg);
U2:   basic_and2 PORT MAP(wd_ctrl_reg,ctrl_bus(1),vdd,vss,wd_ctrl_reg_write_enable); -- write ctrl reg, ctrl bus '10'
U3:   binary_up_counter PORT MAP(wd_input_clock,control_signal(2),control_signal(0),vdd,vss,
                                wd_signal,wd_inv_signal,wd_overflow);
                        
--Generates eight D triggers
Watchdog_ctrl_register: FOR i IN 7 DOWNTO 0 GENERATE
    U_wd: d_trigger_reset_enable  PORT MAP(data_bus(i),wd_ctrl_reg_write_enable,reset,clk_in,vdd,vss,control_signal(i));
  END GENERATE Watchdog_ctrl_register;
  
U4:   basic_or3 PORT MAP(control_signal(5),control_signal(4),control_signal(3),vdd,vss,prescaler_active);
U5:   basic_and2 PORT MAP(control_signal(2),prescaler_active,vdd,vss,prescaler_count);

U6:   timer_counter_prescaler PORT MAP(internal_clk,prescaler_count,prescaler_count,
                  control_signal(5 DOWNTO 3),vdd,vss,prescaler_out);

U7:  mux_2to1 PORT MAP(internal_clk,prescaler_out,prescaler_active,vdd,vss,wd_input_clock);

END watchdog_timer;
----------------------------------------------------------------------------------------