----------------------- 2 to 4 decoder -------------------------------
-- Based on 3-input OR-NOT gates

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY decoder_2to4 IS
  PORT(in_12: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       enable,vdd,vss: IN STD_LOGIC;
       out_24: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END decoder_2to4;

ARCHITECTURE decoder_2to4_arch OF decoder_2to4 IS
  SIGNAL interS1,interS2: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and3
    PORT(in_1,in_2,in_3,vdd,vss: IN STD_LOGIC; out13: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN

U1:    basic_and3 PORT MAP(enable,interS1,interS2,vdd,vss,out_24(0));
U2:    basic_and3 PORT MAP(enable,interS1,in_12(0),vdd,vss,out_24(1));
U3:    basic_and3 PORT MAP(enable,in_12(1),interS2,vdd,vss,out_24(2));
U4:    basic_and3 PORT MAP(enable,in_12(1),in_12(0),vdd,vss,out_24(3));

U5:    inverter PORT MAP(in_12(1),vdd,vss,interS1);
U6:    inverter PORT MAP(in_12(0),vdd,vss,interS2);
END decoder_2to4_arch;
--------------------------------------------------------------------------