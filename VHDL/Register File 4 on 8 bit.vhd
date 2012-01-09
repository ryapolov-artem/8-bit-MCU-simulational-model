------------------ Register file 4*8 bit -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Page 218-219 in PDF file
-- D - 8-bit data in
-- WA - write A
-- WE - write A enable
-- RA - read A
-- RAE - read A enable
-- RB - read B
-- RBE - read A enable
-- Port A, Port B - output ports

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY regiter_file_4on8_bit IS
  PORT(data_input     :   IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       vdd,vss        :   IN STD_LOGIC;
       wa_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       we_in          :   IN STD_LOGIC;
       ra_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       rae_in         :   IN STD_LOGIC;
       rb_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       rbe_in         :   IN STD_LOGIC;
       port_a_out     :   INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
       port_b_out     :   INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END regiter_file_4on8_bit;

ARCHITECTURE regiter_file_4on8_bit_arch OF regiter_file_4on8_bit IS
  SIGNAL load_enable  : STD_LOGIC_VECTOR(3 DOWNTO 0);
 
  SIGNAL read_a_enable   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL read_b_enable   : STD_LOGIC_VECTOR(3 DOWNTO 0);
 
--  SIGNAL register1_q_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL register2_q_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL register3_q_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL register4_q_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
--  SIGNAL port_a_1signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL port_b_1signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
--  SIGNAL port_a_2signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL port_b_2signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
--  SIGNAL port_a_3signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL port_b_3signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
--  SIGNAL port_a_4signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL port_b_4signal  : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
  COMPONENT decoder_2to4_tg
    PORT(select_input   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         enable,vdd,vss : IN STD_LOGIC;
                 out_24 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;  
  
  COMPONENT regiter_file_cell
    PORT( data_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          write : IN STD_LOGIC;
          read_a,read_b,vdd,vss: IN STD_LOGIC;
          data_out_a,data_out_b: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
--  COMPONENT basic_and2
--    PORT(in_1,in_2: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
--  END COMPONENT;
  
--  COMPONENT basic_or4
--    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: INOUT STD_LOGIC);
--  END COMPONENT;
  
  BEGIN
-- Decoders: write A, read A, read B
U1:    decoder_2to4_tg PORT MAP(wa_in,we_in,vdd,vss,load_enable);
U2:    decoder_2to4_tg PORT MAP(ra_in,rae_in,vdd,vss,read_a_enable);
U3:    decoder_2to4_tg PORT MAP(rb_in,rbe_in,vdd,vss,read_b_enable);

-- Four register file cells
U4:    regiter_file_cell PORT MAP(data_input,load_enable(0),read_a_enable(0),read_b_enable(0),vdd,vss,port_a_out,port_b_out);
U5:    regiter_file_cell PORT MAP(data_input,load_enable(1),read_a_enable(1),read_b_enable(1),vdd,vss,port_a_out,port_b_out);
U6:    regiter_file_cell PORT MAP(data_input,load_enable(2),read_a_enable(2),read_b_enable(2),vdd,vss,port_a_out,port_b_out);
U7:    regiter_file_cell PORT MAP(data_input,load_enable(3),read_a_enable(3),read_b_enable(3),vdd,vss,port_a_out,port_b_out);

-- 8 2-in AND gates for read A enable
-- 8 2-in AND gates for read B enable
-- 8 4-in OR gates for output port A
-- 8 4-in OR gates for output port B
--And_Or_Gates: FOR k IN 7 DOWNTO 0 GENERATE
-- For first register file cell
--    A_enable_And_gates1: basic_and2 PORT MAP(read_a_enable(0),register1_q_out(k),vdd,vss,port_a_1signal(k));
--    B_enable_And_gates1: basic_and2 PORT MAP(read_b_enable(0),register1_q_out(k),vdd,vss,port_b_1signal(k));
    
-- For second register file cell
--    A_enable_And_gates2: basic_and2 PORT MAP(read_a_enable(1),register2_q_out(k),vdd,vss,port_a_2signal(k));
--    B_enable_And_gates2: basic_and2 PORT MAP(read_b_enable(1),register2_q_out(k),vdd,vss,port_b_2signal(k));
    
-- For third register file cell
--   A_enable_And_gates3: basic_and2 PORT MAP(read_a_enable(2),register3_q_out(k),vdd,vss,port_a_3signal(k));
--    B_enable_And_gates3: basic_and2 PORT MAP(read_b_enable(2),register3_q_out(k),vdd,vss,port_b_3signal(k));
  
-- For fourth register file cell
--    A_enable_And_gates4: basic_and2 PORT MAP(read_a_enable(3),register4_q_out(k),vdd,vss,port_a_4signal(k));
--    B_enable_And_gates4: basic_and2 PORT MAP(read_b_enable(3),register4_q_out(k),vdd,vss,port_b_4signal(k));

-- Uniting signals from register file cells in 4-in Or gates   
--    Port_A_Or_gates: basic_or4 PORT MAP(port_a_1signal(k),port_a_2signal(k),
--                                        port_a_3signal(k),port_a_4signal(k),
--                                        vdd,vss,port_a_out(k));
--    Port_B_Or_gates: basic_or4 PORT MAP(port_b_1signal(k),port_b_2signal(k),
--                                        port_b_3signal(k),port_b_4signal(k),
--                                        vdd,vss,port_b_out(k));
--  END GENERATE And_Or_Gates;
  
END regiter_file_4on8_bit_arch;
------------------------------------------------------------------