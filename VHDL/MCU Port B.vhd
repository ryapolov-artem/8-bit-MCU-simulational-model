---------------------------------- I/O Port B ---------------------------------------------
-- PORT B Data register         0000 1100
-- PORT B Direction register    0000 1101
-- PORT B Read register         0000 1110
------------------------------ I/O Port Direction Register --------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY io_port_b IS
  PORT(data_bus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       addr_bus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ctrl_bus: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       clk_in,reset,vdd,vss: IN STD_LOGIC;
       port_b: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END io_port_b;

ARCHITECTURE io_port_b OF io_port_b IS
  SIGNAL data_regS,dir_regS,read_regS: STD_LOGIC;
  SIGNAL data_reg_write,data_reg_read: STD_LOGIC;
  SIGNAL dir_reg_write,dir_reg_read: STD_LOGIC;
  SIGNAL read_reg_read: STD_LOGIC;
  SIGNAL data_reg_out,dir_reg_out,read_reg_out: STD_LOGIC_VECTOR(7 DOWNTO 0);

  COMPONENT d_trigger_reset_enable
    PORT (d_in,enable,reset: IN STD_LOGIC;
                clk_in,vdd,vss: IN STD_LOGIC;
               q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC;
        clk_in,reset,vdd,vss: IN STD_LOGIC;
        q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
-- Components for enabling loading/reading data
-- Address decoder  
  COMPONENT port_b_regs_decoders
    PORT( addr_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          vdd,vss   : IN STD_LOGIC;
          data_reg  : OUT STD_LOGIC;
          dir_reg   : OUT STD_LOGIC;
          read_reg  : OUT STD_LOGIC);
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
U1:   port_b_regs_decoders PORT MAP(addr_bus,vdd,vss,data_regS,dir_regS,read_regS);
U2:   basic_and2 PORT MAP(data_regS,ctrl_bus(0),vdd,vss,data_reg_read);   -- read Port B Data Reg, ctrl '01'
U3:   basic_and2 PORT MAP(data_regS,ctrl_bus(1),vdd,vss,data_reg_write);  -- write Port B Data Reg, ctrl '10'
U4:   basic_and2 PORT MAP(dir_regS,ctrl_bus(0),vdd,vss,dir_reg_read);     -- read Port B Direction Reg, ctrl '01'
U5:   basic_and2 PORT MAP(dir_regS,ctrl_bus(1),vdd,vss,dir_reg_write);    -- write Port B Direction Reg, ctrl '10'
U6:   basic_and2 PORT MAP(read_regS,ctrl_bus(0),vdd,vss,read_reg_read);   -- read Port B Read Reg, ctrl '01'

  Port_B_registers: FOR i IN 7 DOWNTO 0 GENERATE
    -- Data register
    U_data: d_trigger_reset_enable  PORT MAP(data_bus(i),data_reg_write,reset,clk_in,vdd,vss,data_reg_out(i));
    Data_reg_read_buf: tri_state_buffer_tg PORT MAP(data_reg_out(i),data_reg_read,vdd,vss,data_bus(i));
    -- Direction register
    U_dir : d_trigger_reset_enable  PORT MAP(data_bus(i),dir_reg_write,reset,clk_in,vdd,vss,dir_reg_out(i));
    Dir_reg_read_buf: tri_state_buffer_tg PORT MAP(dir_reg_out(i),dir_reg_read,vdd,vss,data_bus(i));
    -- Input register
    U_read: d_trigger_res  PORT MAP(port_b(i),clk_in,reset,vdd,vss,read_reg_out(i));
    Read_reg_read_buf: tri_state_buffer_tg PORT MAP(read_reg_out(i), read_reg_read, vdd, vss, data_bus(i));
    -- Output buffers
    Output_buf: tri_state_buffer_tg PORT MAP(data_reg_out(i), dir_reg_out(i), vdd, vss, port_b(i));
  END GENERATE Port_B_registers;
  
END io_port_b;
--------------------------------------------------------------------------------------------