------------------------- Control Unit -------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY control_unit IS
  PORT(ir_word: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       clk_in,reset,vdd,vss: IN STD_LOGIC;
       control_lines: INOUT STD_LOGIC_VECTOR(21 DOWNTO 0));
END control_unit;

ARCHITECTURE control_unit OF control_unit IS
  SIGNAL inv_ir_word: STD_LOGIC_VECTOR(15 DOWNTO 8);
  SIGNAL interS1,interS2: STD_LOGIC;                      -- Other combinations 1101-1111
  SIGNAL rom_row_select: STD_LOGIC_VECTOR(75 DOWNTO 0);   -- pick line in uCommand ROM
  SIGNAL phase_signal: STD_LOGIC_VECTOR(3 DOWNTO 0);
    
  SIGNAL nop_interS1,nop_interS2: STD_LOGIC;
  SIGNAL mov_interS1,mov_interS2: STD_LOGIC;
  SIGNAL ldr_interS1,ldr_interS2: STD_LOGIC; 
  SIGNAL and_interS1,and_interS2: STD_LOGIC;
  SIGNAL or_interS1,or_interS2: STD_LOGIC; 
  SIGNAL add_interS1,add_interS2: STD_LOGIC; 
  SIGNAL sub_interS1,sub_interS2: STD_LOGIC; 
  SIGNAL not_interS0,not_interS1,not_interS2: STD_LOGIC;
  SIGNAL not_rotr_en_interS0: STD_LOGIC;
  SIGNAL inc_interS1,inc_interS2: STD_LOGIC; 
  SIGNAL dec_interS1,dec_interS2: STD_LOGIC; 
  SIGNAL shfl_interS1,shfl_interS2: STD_LOGIC; 
  SIGNAL shfr_interS1,shfr_interS2: STD_LOGIC;
  SIGNAL rotr_interS1,rotr_interS2: STD_LOGIC;
  SIGNAL stm_interS1,stm_interS2: STD_LOGIC; 
  SIGNAL ldm_interS1,ldm_interS2: STD_LOGIC; 
  SIGNAL jmp_interS1,jmp_interS2: STD_LOGIC; 
  SIGNAL out_interS1,out_interS2: STD_LOGIC; 
  SIGNAL in_interS1,in_interS2: STD_LOGIC; 
  SIGNAL other_interS1,other_interS2: STD_LOGIC; 
  
  SIGNAL control_lines_interS: STD_LOGIC_VECTOR(21 DOWNTO 0);
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_or2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and4
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT phase_counter
    PORT(clk_in,reset,vdd,vss: IN STD_LOGIC; phase_out: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT ucommand_unit
    PORT(in_word: IN STD_LOGIC_VECTOR(75 DOWNTO 0);
        vdd,vss: IN STD_LOGIC; control_lines: OUT STD_LOGIC_VECTOR(21 DOWNTO 0));
  END COMPONENT;
  
  BEGIN
 -- Inverters that make inverted signals of instruction word
Inverters: FOR i IN 15 DOWNTO 8 GENERATE
        Inv:  inverter PORT MAP(ir_word(i),vdd,vss,inv_ir_word(i));
END GENERATE  Inverters;

U3:    ucommand_unit PORT MAP(rom_row_select,vdd,vss,control_lines_interS);
U4:    phase_counter PORT MAP(clk_in,reset,vdd,vss,phase_signal);
Laten: control_lines <= control_lines_interS after 10 ps;
--///////////////////////////////////////////////////////////////////
--      Decoding 15-12 bits of command from Instruction register
--///////////////////////////////////////////////////////////////////
-- 'And' gates that make "1" when decoding exact instruction
-- NOP instruction 0000
U5:    basic_and4 PORT MAP(inv_ir_word(15),inv_ir_word(14),inv_ir_word(13),inv_ir_word(12),vdd,vss,nop_interS1);
-- MOV instruction 0001
U6:    basic_and4 PORT MAP(inv_ir_word(15),inv_ir_word(14),inv_ir_word(13),ir_word(12),vdd,vss,mov_interS1);
-- LDR instruction 0010
U7:    basic_and4 PORT MAP(inv_ir_word(15),inv_ir_word(14),ir_word(13),inv_ir_word(12),vdd,vss,ldr_interS1);
-- AND instruction 0011
U8:    basic_and4 PORT MAP(inv_ir_word(15),inv_ir_word(14),ir_word(13),ir_word(12),vdd,vss,and_interS1);
-- OR instruction 0100
U9:    basic_and4 PORT MAP(inv_ir_word(15),ir_word(14),inv_ir_word(13),inv_ir_word(12),vdd,vss,or_interS1);
-- ADD instruction 0101
U10:   basic_and4 PORT MAP(inv_ir_word(15),ir_word(14),inv_ir_word(13),ir_word(12),vdd,vss,add_interS1);
-- SUB instruction 0110
U11:   basic_and4 PORT MAP(inv_ir_word(15),ir_word(14),ir_word(13),inv_ir_word(12),vdd,vss,sub_interS1);
-- NOT INC DEC SHFL SHFR ROTR instructions 0111
U12:   basic_and4 PORT MAP(inv_ir_word(15),ir_word(14),ir_word(13),ir_word(12),vdd,vss,not_rotr_en_interS0); --makes enable signal
-- JMP instruction 1000
U13:   basic_and4 PORT MAP(ir_word(15),inv_ir_word(14),inv_ir_word(13),inv_ir_word(12),vdd,vss,jmp_interS1);
-- STM instruction 1001
U14:   basic_and4 PORT MAP(ir_word(15),inv_ir_word(14),inv_ir_word(13),ir_word(12),vdd,vss,stm_interS1);
-- LDM instruction 1010
U15:   basic_and4 PORT MAP(ir_word(15),inv_ir_word(14),ir_word(13),inv_ir_word(12),vdd,vss,ldm_interS1);
-- OUT instruction 1011
U16:   basic_and4 PORT MAP(ir_word(15),inv_ir_word(14),ir_word(13),ir_word(12),vdd,vss,out_interS1);
-- IN instruction 1100
U17:    basic_and4 PORT MAP(ir_word(15),ir_word(14),inv_ir_word(13),inv_ir_word(12),vdd,vss,in_interS1);

-- Other combinations 1101-1111
U18:    basic_and2 PORT MAP(ir_word(15),ir_word(14),vdd,vss,interS1);
U19:    basic_or2 PORT MAP(ir_word(13),ir_word(12),vdd,vss,interS2);
U20:    basic_and2 PORT MAP(interS1,interS2,vdd,vss,other_interS1);

--///////////////////////////////////////////////////////////////////
--      Decoding 11-8 bits of command from Instruction register
--              Additional bits for NOT-ROTR instructions
--///////////////////////////////////////////////////////////////////
-- NOT instruction 0000
U21:    basic_and4 PORT MAP(inv_ir_word(11),inv_ir_word(10),inv_ir_word(9),inv_ir_word(8),vdd,vss,not_interS1);
-- INC instruction 0001
U22:    basic_and4 PORT MAP(inv_ir_word(11),inv_ir_word(10),inv_ir_word(9),ir_word(8),vdd,vss,inc_interS1);
-- DEC instruction 0010
U23:    basic_and4 PORT MAP(inv_ir_word(11),inv_ir_word(10),ir_word(9),inv_ir_word(8),vdd,vss,dec_interS1);
-- SHFL instruction 0011
U24:    basic_and4 PORT MAP(inv_ir_word(11),inv_ir_word(10),ir_word(9),ir_word(8),vdd,vss,shfl_interS1);
-- SHFR instruction 0100
U25:    basic_and4 PORT MAP(inv_ir_word(11),ir_word(10),inv_ir_word(9),inv_ir_word(8),vdd,vss,shfr_interS1);
-- ROTR instruction 0101
U26:    basic_and4 PORT MAP(inv_ir_word(11),ir_word(10),inv_ir_word(9),ir_word(8),vdd,vss,rotr_interS1);

--///////////////////////////////////////////////////////////////////
--        2-input AND gates are uniting enable signal 
--                from U12 and U21-U26
--///////////////////////////////////////////////////////////////////
-- NOT
U27:    basic_and2 PORT MAP(not_rotr_en_interS0,not_interS1,vdd,vss,not_interS2);
-- INC
U28:    basic_and2 PORT MAP(not_rotr_en_interS0,inc_interS1,vdd,vss,inc_interS2);
-- DEC
U29:    basic_and2 PORT MAP(not_rotr_en_interS0,dec_interS1,vdd,vss,dec_interS2);
-- SHFL
U30:    basic_and2 PORT MAP(not_rotr_en_interS0,shfl_interS1,vdd,vss,shfl_interS2);
-- SHFR
U31:    basic_and2 PORT MAP(not_rotr_en_interS0,shfr_interS1,vdd,vss,shfr_interS2);
-- ROTR
U32:    basic_and2 PORT MAP(not_rotr_en_interS0,rotr_interS1,vdd,vss,rotr_interS2);

--//////////////////////////////////////////////////////////////////////
--      AND gates that picking phase of running command by
--  uniting signal from 4-in AND gates U5-20,U27-32 and from pase generator.
--  Then signals from 2-in AND gates is passing to uCommand ROM matrix
--//////////////////////////////////////////////////////////////////////
ROM_Row_selection: FOR i IN 0 TO 3 GENERATE
  -- NOP starts in ROM from line 0
  U_nop:  basic_and2 PORT MAP(nop_interS1,phase_signal(i),vdd,vss,rom_row_select(i));
  -- MOV starts in ROM from line 4
  U_mov:  basic_and2 PORT MAP(mov_interS1,phase_signal(i),vdd,vss,rom_row_select(i+4));
  -- LDR starts in ROM from line 8
  U_ldr:  basic_and2 PORT MAP(ldr_interS1,phase_signal(i),vdd,vss,rom_row_select(i+8));
  -- AND starts in ROM from line 12
  U_and:  basic_and2 PORT MAP(and_interS1,phase_signal(i),vdd,vss,rom_row_select(i+12));
  -- OR starts in ROM from line 16
  U_or:  basic_and2 PORT MAP(or_interS1,phase_signal(i),vdd,vss,rom_row_select(i+16));
  -- ADD starts in ROM from line 20
  U_add:  basic_and2 PORT MAP(add_interS1,phase_signal(i),vdd,vss,rom_row_select(i+20));
  -- SUB starts in ROM from line 24
  U_sub:  basic_and2 PORT MAP(sub_interS1,phase_signal(i),vdd,vss,rom_row_select(i+24));
  
  -- NOT starts in ROM from line 28
  U_not:  basic_and2 PORT MAP(not_interS2,phase_signal(i),vdd,vss,rom_row_select(i+28));
  -- INC starts in ROM from line 32
  U_inc:  basic_and2 PORT MAP(inc_interS2,phase_signal(i),vdd,vss,rom_row_select(i+32));
  -- DEC starts in ROM from line 36
  U_dec:  basic_and2 PORT MAP(dec_interS2,phase_signal(i),vdd,vss,rom_row_select(i+36));
  -- SHFL starts in ROM from line 40
  U_shfl:  basic_and2 PORT MAP(shfl_interS2,phase_signal(i),vdd,vss,rom_row_select(i+40));
  -- SHFR starts in ROM from line 44
  U_shfr:  basic_and2 PORT MAP(shfr_interS2,phase_signal(i),vdd,vss,rom_row_select(i+44));
  -- ROTR starts in ROM from line 48
  U_rotr:  basic_and2 PORT MAP(rotr_interS2,phase_signal(i),vdd,vss,rom_row_select(i+48));
  
  -- JMP starts in ROM from line 52
  U_jmp:  basic_and2 PORT MAP(jmp_interS1,phase_signal(i),vdd,vss,rom_row_select(i+52));
  -- STM starts in ROM from line 56
  U_stm:  basic_and2 PORT MAP(stm_interS1,phase_signal(i),vdd,vss,rom_row_select(i+56));
  -- LDM starts in ROM from line 60
  U_ldm:  basic_and2 PORT MAP(ldm_interS1,phase_signal(i),vdd,vss,rom_row_select(i+60));
  -- OUT starts in ROM from line 64
  U_out:  basic_and2 PORT MAP(out_interS1,phase_signal(i),vdd,vss,rom_row_select(i+64));
  -- IN starts in ROM from line 68
  U_in:  basic_and2 PORT MAP(in_interS1,phase_signal(i),vdd,vss,rom_row_select(i+68));
  -- WRONG OPCODE starts in ROM from line 72
  U_wr_opcode:  basic_and2 PORT MAP(other_interS1,phase_signal(i),vdd,vss,rom_row_select(i+72));
 
END GENERATE  ROM_Row_selection;

END control_unit;
----------------------------------------------------------------------------------------------------