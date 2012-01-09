------------------------- SRAM Unit ---------------------------
--                  Capacity 128*8 bit
--  Address word 6..0 bits
--  Data word 7..0 bits
--  Schematics in book "Proektirovanie cifrovih ustroistv. Ueikerly. vol. 2" p.435

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_unit IS
  PORT( address_word : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        data_word    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        read_enable  : IN STD_LOGIC;
        write_enable : IN STD_LOGIC;
        cs           : IN STD_LOGIC;
        vdd,vss: IN STD_LOGIC);
END sram_unit;

ARCHITECTURE sram_unit OF sram_unit IS
  SIGNAL write_signal: STD_LOGIC;
  SIGNAL write_enable_inv: STD_LOGIC;
  SIGNAL output_enable: STD_LOGIC;
  SIGNAL data_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL bit_lines: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL row_select: STD_LOGIC_VECTOR(127 DOWNTO 0);

  COMPONENT sram_row_decoder
    PORT( addr_in  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
          vdd,vss  : IN STD_LOGIC;
          row_out  : OUT STD_LOGIC_VECTOR(127 DOWNTO 0));
  END COMPONENT;
    
  COMPONENT sram_dtrig_cell
    PORT( data_in,select_in,write : IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
           data_out: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT tri_state_buffer_tg
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
          data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT non_inv_buffer
    PORT (data_in,vdd,vss: IN STD_LOGIC;
          data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and3
    PORT(in_1,in_2,in_3: IN STD_LOGIC;
                vdd,vss: IN STD_LOGIC;
                  out13: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
      
  BEGIN
U1:    basic_and2 PORT MAP(write_enable,cs,vdd,vss,write_signal);
U2:    inverter   PORT MAP(write_enable,vdd,vss,write_enable_inv);
U3:    basic_and3 PORT MAP(write_enable_inv,cs,read_enable,vdd,vss,output_enable);
U4:    sram_row_decoder PORT MAP(address_word,vdd,vss,row_select);

Memory_matrix: FOR i IN 127 DOWNTO 0 GENERATE
  Data_words: FOR j IN 7 DOWNTO 0 GENERATE
    sram_cells: sram_dtrig_cell PORT MAP(data_signal(j),row_select(i),write_signal,vdd,vss,bit_lines(j));
    out_buffers: tri_state_buffer_tg PORT MAP(bit_lines(j),output_enable,vdd,vss,data_word(j));
    in_buffer: non_inv_buffer PORT MAP(data_word(j),vdd,vss,data_signal(j));
  END GENERATE Data_words;
END GENERATE Memory_matrix;

END sram_unit;
----------------------------------------------------------------------------------