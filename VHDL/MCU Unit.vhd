-------------------------------------- Microprocessor unit -----------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mcu IS
  PORT(port_a,port_b : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       clk_in,vdd,vss: IN STD_LOGIC;
       t_c_ext_clk,ext_reset: IN STD_LOGIC);
END mcu;

ARCHITECTURE mcu_arch OF mcu IS
 
  SIGNAL address_bus: STD_LOGIC_VECTOR(7 DOWNTO 0);           -- Common Address bus
  SIGNAL data_bus: STD_LOGIC_VECTOR(7 DOWNTO 0);              -- Common Data bus
  SIGNAL control_lines: STD_LOGIC_VECTOR(21 DOWNTO 0);        -- Control lines between Control unit and other blocks
  SIGNAL RBAddr,RAAddr,WAAddr: STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Addresses of registers in Register file to read(A,B) and write (A)
  
  SIGNAL count_prmem: STD_LOGIC_VECTOR(7 DOWNTO 0);     -- 8-bit word between Program counter and Program memory
  SIGNAL prmem_ir: STD_LOGIC_VECTOR(15 DOWNTO 0);       -- 16-bit word between Program memory and Instruction register
  SIGNAL ir_control: STD_LOGIC_VECTOR(15 DOWNTO 0);     -- 16-bit word between Instruction register and Control Unit

  SIGNAL start_signal: STD_LOGIC_VECTOR(2 DOWNTO 0);    -- A B C, see MCU Starting circuit.vhd 
  SIGNAL pc_count: STD_LOGIC;
  SIGNAL ir_load: STD_LOGIC;
  SIGNAL prmem_read: STD_LOGIC;
  SIGNAL control_bus: STD_LOGIC_VECTOR(1 DOWNTO 0);     -- Read of Write enable
  SIGNAL reset,wd_overflow: STD_LOGIC;
  
  SIGNAL internal_clk,interrupt: STD_LOGIC;
  
  
-- Process external reset and watchdog reset
  COMPONENT reset_circuit
    PORT(reset,wdr     : IN STD_LOGIC;
         clk_in        : IN STD_LOGIC;
         vdd,vss       : IN STD_LOGIC;
         internal_reset: INOUT STD_LOGIC);
  END COMPONENT;

-- Moore FSM
  COMPONENT starting_circuit
    PORT(clk_in      : IN STD_LOGIC;
         reset       : IN STD_LOGIC; -- active level 0
         vdd,vss     : IN STD_LOGIC;
         abc_out     : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;
  
-- 8-bit program counter  
  COMPONENT program_counter
    PORT(data_bus    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         clock,count : IN STD_LOGIC;
         down_count  : IN STD_LOGIC; --Connected to vss: only UP count
         clear       : IN STD_LOGIC; --CLEAR active level 0
         vdd,vss     : IN STD_LOGIC;
         q_out       : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         overflow    : INOUT STD_LOGIC);
  END COMPONENT;

-- Program storage 128*16 bit   
  COMPONENT program_memory_unit
    PORT( address_word : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
          data_word    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          read_enable  : IN STD_LOGIC;
          cs           : IN STD_LOGIC;
          vdd,vss      : IN STD_LOGIC);
  END COMPONENT;

-- Temporal storage for fetched instruction
  COMPONENT instruction_register
    PORT(load: IN STD_LOGIC;
         paral_input: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         clk_in,reset,vdd,vss: IN STD_LOGIC;
         q_out: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
  END COMPONENT;
  
-- Main control unit  
  COMPONENT control_unit
    PORT(ir_word: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         clk_in,reset,vdd,vss: IN STD_LOGIC;
         control_lines: INOUT STD_LOGIC_VECTOR(21 DOWNTO 0));
  END COMPONENT;
  
-- ALU and General purpose registers  
  COMPONENT datapath_unit
    PORT(in_word : IN STD_LOGIC_VECTOR(7 DOWNTO 0);          -- 8-bit word from Data bus
       out_word: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);           -- 8-bit word to Data bus
       clk_in,vdd,vss: IN STD_LOGIC;
       input_enable  : IN STD_LOGIC;
       write_A_enable: IN STD_LOGIC;
       read_A_enable : IN STD_LOGIC;
       read_B_enable : IN STD_LOGIC;
       alu_control   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       shifter_contr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       store_accumul : IN STD_LOGIC;
       output_enable : IN STD_LOGIC;
       RBAddr,RAAddr,WAAddr: IN STD_LOGIC_VECTOR(1 DOWNTO 0));
  END COMPONENT;
  
-- Static RAM  
  COMPONENT sram_unit
    PORT( address_word : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
          data_word    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          read_enable  : IN STD_LOGIC;
          write_enable : IN STD_LOGIC;
          cs           : IN STD_LOGIC;
          vdd,vss: IN STD_LOGIC);
  END COMPONENT;
  
-- Port A consists of Data register, Direction register, Read register  
  COMPONENT io_port_a
    PORT(data_bus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         addr_bus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         ctrl_bus: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         clk_in,reset,vdd,vss: IN STD_LOGIC;
         port_a: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
-- Port B (Data register, Direction register, Read register)
  COMPONENT io_port_b
    PORT(data_bus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         addr_bus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         ctrl_bus: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         clk_in,reset,vdd,vss: IN STD_LOGIC;
         port_b: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
-- Watchdog timer
  COMPONENT watchdog_timer
    PORT(data_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         reset       : IN STD_LOGIC;
         clk_in      : IN STD_LOGIC;
         internal_clk: IN STD_LOGIC;
         vdd,vss     : IN STD_LOGIC;
         wd_overflow : INOUT STD_LOGIC);
  END COMPONENT;

-- 8-bit timer/counter
  COMPONENT timer_counter_unit
    PORT(data_bus    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         addr_bus    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         ctrl_bus    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         reset       : IN STD_LOGIC;
         clk_in      : IN STD_LOGIC;
         ext_clk     : IN STD_LOGIC;
         vdd,vss     : IN STD_LOGIC;
         interrupt   : OUT STD_LOGIC);
  END COMPONENT;
    
-- Additional components  
  COMPONENT tri_state_buffer_tg -- opens with enable = '1'
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC; data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
           out_12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
    
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT; 
  
  BEGIN
U1:   reset_circuit PORT MAP(ext_reset,wd_overflow,clk_in,vdd,vss,reset);
U2:   starting_circuit PORT MAP(clk_in,reset,vdd,vss,start_signal);

U3:   mux_2to1  PORT MAP(start_signal(0),control_lines(18),start_signal(2),vdd,vss,pc_count);   --PC count signal
U4:   mux_2to1  PORT MAP(start_signal(1),control_lines(17),start_signal(2),vdd,vss,ir_load);    --IR load signal
U5:   mux_2to1  PORT MAP(start_signal(1),control_lines(19),start_signal(2),vdd,vss,prmem_read); --Program memory read signal

U6:   program_counter PORT MAP(data_bus,address_bus,control_bus,clk_in,pc_count,vss,reset,vdd,vss,count_prmem);

-- CS=read_enable <=prmem_read  
U7:   program_memory_unit PORT MAP(count_prmem(6 DOWNTO 0),prmem_ir,prmem_read,prmem_read,vdd,vss);

U8:   instruction_register PORT MAP(ir_load,prmem_ir,clk_in,reset,vdd,vss,ir_control);
  
U9:   control_unit PORT MAP(ir_control,clk_in,start_signal(2),vdd,vss,control_lines); --start_signal(2)-reset signal
S1:   control_bus(0)<= control_lines(20);
S2:   control_bus(1)<= control_lines(21);

-- Tri-state buffers which enable passing register address to reg file input ports
Addr_enable_buffers: FOR i IN 1 DOWNTO 0 GENERATE
  Urb:  tri_state_buffer_tg PORT MAP(ir_control(i),control_lines(8),vdd,vss,RBAddr(i));
  Ura0: tri_state_buffer_tg PORT MAP(ir_control(i),control_lines(10),vdd,vss,RAAddr(i));
  Ura1: tri_state_buffer_tg PORT MAP(ir_control(i+2),control_lines(11),vdd,vss,RAAddr(i));
  Uwa:  tri_state_buffer_tg PORT MAP(ir_control(i+2),control_lines(13),vdd,vss,WAAddr(i));
END GENERATE Addr_enable_buffers;

-- Tri-state buffers which enable passing 8-bit word to address or data bus
Word_to_busses: FOR j IN 7 DOWNTO 0 GENERATE
  Uaddrbus: tri_state_buffer_tg PORT MAP(ir_control(j+4),control_lines(16),vdd,vss,address_bus(j));
  Udatabus: tri_state_buffer_tg PORT MAP(ir_control(j+4),control_lines(15),vdd,vss,data_bus(j));
END GENERATE Word_to_busses;

U10:  datapath_unit PORT MAP(data_bus,data_bus,clk_in,vdd,vss,
         control_lines(14),control_lines(12),control_lines(9),
         control_lines(7),control_lines(6 DOWNTO 4),control_lines(3 DOWNTO 2),control_lines(1),control_lines(0),
         RBAddr,RAAddr,WAAddr);
                 
U11:  sram_unit PORT MAP(address_bus(6 DOWNTO 0),data_bus,control_bus(0),control_bus(1),address_bus(7),vdd,vss);

U12:  watchdog_timer PORT MAP(data_bus,address_bus,control_bus,reset,clk_in,internal_clk,vdd,vss,wd_overflow);

U13:  timer_counter_unit PORT MAP(data_bus,address_bus,control_bus,reset,clk_in,t_c_ext_clk,vdd,vss,interrupt);

U14:  io_port_a PORT MAP(data_bus,address_bus,control_bus,clk_in,reset,vdd,vss,port_a);

U15:  io_port_b PORT MAP(data_bus,address_bus,control_bus,clk_in,reset,vdd,vss,port_b);

END mcu_arch;
-----------------------------------------------------------------------------------