------------------------- Program Memory Unit -------------------------------------------------------
--                  Capacity 512*16 bit
--  Address word 7..0 bits
--  Data word 16..0 bits
--  This model made with using text file (program_memory.txt)
--  Schematics similar to the one in book "Proektirovanie cifrovih ustroistv. Ueikerly. vol. 2" p.435

LIBRARY IEEE;
USE std.textio.ALL; 
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_textio.ALL; 
USE IEEE.numeric_std.ALL;
ENTITY program_memory_unit IS
  GENERIC ( memory_file: string := "E:\Projects\ModelSim\5 - CMOS memory cell\program_memory.txt");
  PORT( address_word : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        data_word    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_enable  : IN STD_LOGIC;
        cs           : IN STD_LOGIC;
        vdd,vss      : IN STD_LOGIC);
END program_memory_unit;

ARCHITECTURE program_memory_unit OF program_memory_unit IS
  TYPE rom IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  COMPONENT sram_row_decoder
    PORT( addr_in  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
          vdd,vss  : IN STD_LOGIC;
          row_out  : OUT STD_LOGIC_VECTOR(127 DOWNTO 0));
  END COMPONENT;
    
  COMPONENT floating_gate_FET
    PORT (gate,floating_gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT rom_connect_line
    PORT (in_from_drains,to_vdd: IN STD_LOGIC; to_out_buffers: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT tri_state_buffer_tg
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
          data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
  
  -- Function of extracting data from TXT file and soring in array of vectors
  IMPURE FUNCTION file_to_rom (memory_file: STRING) RETURN rom IS
    VARIABLE file_line : LINE;
    VARIABLE mem_word  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE k         : INTEGER :=0;
    FILE mem_file      : TEXT OPEN READ_MODE IS memory_file;
    VARIABLE program_memory: rom;
  BEGIN
    WHILE NOT ENDFILE(mem_file) LOOP  -- read every line in file
    READLINE (mem_file, file_line);
    WHILE file_line(1)='#' LOOP       -- skip comment, which starts with # symbol
      READLINE (mem_file, file_line);
    END LOOP;      
    READ (file_line, mem_word);
    program_memory(k) := mem_word;    -- store in array
    k := k + 1;
  END LOOP;
  RETURN program_memory;
  END file_to_rom;
  
  SIGNAL program_memory: rom:=file_to_rom(memory_file); -- Data from array passes to Signal
  SIGNAL drains_to_line: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL line_to_out_buffer: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL output_enable: STD_LOGIC;
  SIGNAL row_select: STD_LOGIC_VECTOR(127 DOWNTO 0);
  
BEGIN
U1:    basic_and2 PORT MAP(read_enable,cs,vdd,vss,output_enable);
U2:    sram_row_decoder PORT MAP(address_word,vdd,vss,row_select);

Columns: FOR i IN 0 TO 15 GENERATE
U3n:   rom_connect_line PORT MAP(drains_to_line(i),vdd,line_to_out_buffer(i));
  Memory_matrix: FOR j IN 0 TO 127 GENERATE
      fg_fets127: floating_gate_FET PORT MAP(row_select(j),program_memory(j)(i),vss,drains_to_line(i));
    -- Output buffers
      buffers: tri_state_buffer_tg PORT MAP(line_to_out_buffer(i),output_enable,vdd,vss,data_word(i));
  END GENERATE Memory_matrix;
END GENERATE Columns;

END program_memory_unit;
------------------------------------------------------------------------------------------------------------------