--------------------- SRAM decoder 7 to 128 ---------------------
-- Idea taken from schematics from WEB-page named:
--              Aries: An LSI Macro-Block for DSP Applications.
-- Circuit built with 2 predecoders implemented with 
--                decoders 2 to 4

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_row_decoder IS
  PORT( addr_in  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        vdd,vss  : IN STD_LOGIC;
        row_out  : OUT STD_LOGIC_VECTOR(127 DOWNTO 0));
END sram_row_decoder;

ARCHITECTURE sram_row_decoder_arch OF sram_row_decoder IS
  SIGNAL interS1: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL interS2: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL interS3: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL interS4: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL interS5: STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL interS6: STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL interS7: STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL interS8: STD_LOGIC;
  SIGNAL interS9: STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL interS10: STD_LOGIC;
  SIGNAL interS11: STD_LOGIC;

  COMPONENT decoder_2to4_tg
    PORT(select_input: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       enable,vdd,vss: IN STD_LOGIC;
               out_24: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
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
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
    
U1:    decoder_2to4_tg PORT MAP(addr_in(6 DOWNTO 5),vdd,vdd,vss,interS1);
U2:    decoder_2to4_tg PORT MAP(addr_in(4 DOWNTO 3),vdd,vdd,vss,interS2);
-- 000
U3:    basic_and3 PORT MAP(interS5(2),interS5(1),interS5(0),vdd,vss,interS4(0));
U4:    inverter PORT MAP(addr_in(2),vdd,vss,interS5(2));
U5:    inverter PORT MAP(addr_in(1),vdd,vss,interS5(1));
U6:    inverter PORT MAP(addr_in(0),vdd,vss,interS5(0));
-- 001
U7:    basic_and3 PORT MAP(interS6(1),interS6(0),addr_in(0),vdd,vss,interS4(1));
U8:    inverter PORT MAP(addr_in(2),vdd,vss,interS6(1));
U9:    inverter PORT MAP(addr_in(1),vdd,vss,interS6(0));
-- 010
U10:    basic_and3 PORT MAP(interS7(1),addr_in(1),interS7(0),vdd,vss,interS4(2));
U12:    inverter PORT MAP(addr_in(2),vdd,vss,interS7(1));
U13:    inverter PORT MAP(addr_in(0),vdd,vss,interS7(0));
-- 011
U14:    basic_and3 PORT MAP(interS8,addr_in(1),addr_in(0),vdd,vss,interS4(3));
U15:    inverter PORT MAP(addr_in(2),vdd,vss,interS8);
-- 100
U16:    basic_and3 PORT MAP(addr_in(2),interS9(1),interS9(0),vdd,vss,interS4(4));
U17:    inverter PORT MAP(addr_in(1),vdd,vss,interS9(1));
U18:    inverter PORT MAP(addr_in(0),vdd,vss,interS9(0));
-- 101
U19:    basic_and3 PORT MAP(addr_in(2),interS10,addr_in(0),vdd,vss,interS4(5));
U20:    inverter PORT MAP(addr_in(1),vdd,vss,interS10);
-- 110
U21:    basic_and3 PORT MAP(addr_in(2),addr_in(1),interS11,vdd,vss,interS4(6));
U22:    inverter PORT MAP(addr_in(0),vdd,vss,interS11);
-- 111
U23:    basic_and3 PORT MAP(addr_in(0),addr_in(1),addr_in(2),vdd,vss,interS4(7));

-- Internal 2-Input AND gates
  Output_gates: FOR k IN 0 TO 3 GENERATE
    Predecoder_gates: FOR j IN 0 TO 3 GENERATE
        Signals_from_3in_And_gates: FOR i IN 0 TO 7 GENERATE
          
        Un_32:  basic_and2 PORT MAP(interS4(i),interS2(j),vdd,vss,interS3(i+j*8));
        Un_128: basic_and2 PORT MAP(interS3(i+j*8),interS1(k),vdd,vss,row_out(i+j*8+k*32));
        
      END GENERATE  Signals_from_3in_And_gates;
    END GENERATE Predecoder_gates;
  END GENERATE Output_gates;
  
END sram_row_decoder_arch;
----------------------------------------------------------------------------------------------------------------------
