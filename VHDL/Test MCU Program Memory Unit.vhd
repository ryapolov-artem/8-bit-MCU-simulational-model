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
ENTITY test_program_memory_unit IS
  GENERIC ( memory_file: string := "E:\Projects\ModelSim\5 - CMOS memory cell\program_memory1.txt");
  PORT( address_word : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        data_word    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_enable  : IN STD_LOGIC;
        cs           : IN STD_LOGIC;
        vdd,vss      : IN STD_LOGIC);
END test_program_memory_unit;

ARCHITECTURE test_program_memory_unit OF test_program_memory_unit IS
  TYPE rom IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  --TYPE bit_line_connect IS ARRAY (15 DOWNTO 0) OF STD_LOGIC;
  --TYPE connections IS ARRAY (7 DOWNTO 0) OF bit_lines; -- Array of signals that connects FETs from one line with FETs from next line (row)
  
  COMPONENT decoder_3to8 IS
    PORT(in_123: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        enable,vdd,vss: IN STD_LOGIC;
        out_38: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
    
  COMPONENT floating_gate_FET
    PORT (gate,floating_gate,source,bit_line_in: IN STD_LOGIC; bit_line_out: OUT STD_LOGIC);
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
    READ (file_line, mem_word);
    program_memory(k) := mem_word;    -- store in array
    k := k + 1;
  END LOOP;
  RETURN program_memory;
  END file_to_rom;
  
  SIGNAL program_memory: rom:=file_to_rom(memory_file); -- Data from array passes to Signal
  
  SIGNAL bit_line_connect0: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect1: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect2: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect3: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect4: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect5: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect6: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL bit_line_connect7: STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL output_enable: STD_LOGIC;
  SIGNAL row_select: STD_LOGIC_VECTOR(7 DOWNTO 0);
  
BEGIN
U1:    basic_and2 PORT MAP(read_enable,cs,vdd,vss,output_enable);
U2:    decoder_3to8 PORT MAP(address_word,cs,vdd,vss,row_select);

Columns: FOR j IN 15 DOWNTO 0 GENERATE
  fg_fets0: floating_gate_FET PORT MAP(row_select(0),program_memory(0)(j),vss,vdd,bit_line_connect7(j));
  fg_fets1: floating_gate_FET PORT MAP(row_select(1),program_memory(1)(j),vss,bit_line_connect7(j),bit_line_connect6(j));
  fg_fets2: floating_gate_FET PORT MAP(row_select(2),program_memory(2)(j),vss,bit_line_connect6(j),bit_line_connect5(j));
  fg_fets3: floating_gate_FET PORT MAP(row_select(3),program_memory(3)(j),vss,bit_line_connect5(j),bit_line_connect4(j));
  fg_fets4: floating_gate_FET PORT MAP(row_select(4),program_memory(4)(j),vss,bit_line_connect4(j),bit_line_connect3(j));
  fg_fets5: floating_gate_FET PORT MAP(row_select(5),program_memory(5)(j),vss,bit_line_connect3(j),bit_line_connect2(j));
  fg_fets6: floating_gate_FET PORT MAP(row_select(6),program_memory(6)(j),vss,bit_line_connect2(j),bit_line_connect1(j));
  fg_fets7: floating_gate_FET PORT MAP(row_select(7),program_memory(7)(j),vss,bit_line_connect1(j),bit_line_connect0(j));

  buffers: tri_state_buffer_tg PORT MAP(bit_line_connect0(j),output_enable,vdd,vss,data_word(j));
END GENERATE Columns;

END test_program_memory_unit;
------------------------------------------------------------------------------------------------------------------