------------------------- Microcommand Unit -------------------------------
--  0 - Output Enable (OE) from Datapath
--  1 - Shift/rotate signal bit 0
--  2 - Shift/rotate signal bit 1
--  3 - ALU signal bit 0
--  4 - ALU signal bit 1
--  5 - ALU signal bit 2
--  6 - Read B Enable
--  7 - Read B Address Enable signal
--  8 - Read A Enable
--  9 - Read A Address Enable signal
--  10 - Write A Enable signal
--  11 - Write A Address Enable signal
--  12 - Input Enable (IE) to Datapath
--  13 - 8-bit word to data bus enable signal
--  14 - 8-bit word to address bus enable signal
--  15 - Instruction register load signal
--  16 - Program memory read

LIBRARY IEEE;
USE std.textio.ALL; 
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_textio.ALL; 
USE IEEE.numeric_std.ALL;
ENTITY ucommand_unit IS
  GENERIC ( uCommand_file: string := "E:\Projects\ModelSim\5 - CMOS memory cell\uCommand_ROM.txt");
  PORT(in_word: IN STD_LOGIC_VECTOR(75 DOWNTO 0);
       vdd,vss: IN STD_LOGIC;
       control_lines: OUT STD_LOGIC_VECTOR(21 DOWNTO 0));
END ucommand_unit;

ARCHITECTURE ucommand_unit OF ucommand_unit IS

  TYPE rom IS ARRAY (0 TO 75) OF STD_LOGIC_VECTOR(21 DOWNTO 0);

  COMPONENT floating_gate_FET
    PORT (gate,floating_gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT rom_connect_line
    PORT (in_from_drains,to_vdd: IN STD_LOGIC; to_out_buffers: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT; 
  
  -- Function of extracting data from TXT file and soring in array of vectors
  IMPURE FUNCTION uCommands_rom_func (memory_file: STRING) RETURN rom IS
    VARIABLE file_line      : LINE;
    VARIABLE rom_word       : STD_LOGIC_VECTOR(21 DOWNTO 0);
    VARIABLE k              : INTEGER :=0;
    FILE ucommand_rom_file  : TEXT OPEN READ_MODE IS uCommand_file;
    VARIABLE uCommand_rom   : rom;
  BEGIN
    WHILE NOT ENDFILE(ucommand_rom_file) LOOP  -- read every line in file
    READLINE (ucommand_rom_file, file_line);
    WHILE file_line(1)='#' LOOP                -- skip comment, which starts with # symbol
      READLINE (ucommand_rom_file, file_line);
    END LOOP;      
    READ (file_line, rom_word);
    uCommand_rom(k) := rom_word;    -- store in array
    k := k + 1;
  END LOOP;
  RETURN uCommand_rom;
  END uCommands_rom_func;
  
  SIGNAL program_memory: rom:=uCommands_rom_func(uCommand_file); -- Data from array is passing to Signal
  SIGNAL drains_to_line: STD_LOGIC_VECTOR(21 DOWNTO 0);
  SIGNAL line_to_out_inverters: STD_LOGIC_VECTOR(21 DOWNTO 0);
  
  BEGIN
Columns: FOR i IN 0 TO 21 GENERATE
U3n:   rom_connect_line PORT MAP(drains_to_line(i),vdd,line_to_out_inverters(i));
  Memory_matrix: FOR j IN 0 TO 75 GENERATE
      fg_fets127: floating_gate_FET PORT MAP(in_word(j),program_memory(j)(i),vss,drains_to_line(i));
    -- Output inverters
      inverters: inverter PORT MAP(line_to_out_inverters(i),vdd,vss,control_lines(i));
  END GENERATE Memory_matrix;
END GENERATE Columns;

END ucommand_unit;
----------------------------------------------------------------------------------------------------