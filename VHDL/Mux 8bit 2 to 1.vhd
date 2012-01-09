--------------------- Multilpexor 2 8-bit words to 1 8-bit word ---------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mux_8bit_2to1 IS
  PORT( word_a,word_b: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        in_select,vdd,vss: IN STD_LOGIC;
        output_word: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END mux_8bit_2to1;

ARCHITECTURE mux_8bit_2to1_arch OF mux_8bit_2to1 IS
    
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
             out_12: INOUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
  Bits: FOR i IN 7 DOWNTO 0 GENERATE
    Um:    mux_2to1 PORT MAP(word_a(i),word_b(i),in_select,vdd,vss,output_word(i));
  END GENERATE Bits;

END mux_8bit_2to1_arch;
------------------------------------------------------------------
