----------------------- 5 to 32 decoder -------------------------------
-- Built with predecoder
--
--     0 ---------------- to
--     1 ---------------- predecoder (2 to 4)
--     2 ----------|        | | | |
--     3 ------|   |        | | | |
--     4 ---|  |   |        | | | |
--
--    Enable=chip select
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY decoder_5to32 IS
  PORT(in_5          : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
       enable,vdd,vss: IN STD_LOGIC;
       we,re         : IN STD_LOGIC;
       out_5to32     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END decoder_5to32;

ARCHITECTURE decoder_3to8_arch OF decoder_3to8 IS
  SIGNAL interS1,interS2,interS3,interS4: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_orNot4 IS
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC;
       out14: INOUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    basic_orNot4 PORT MAP(interS1,in_123(2),in_123(1),in_123(0),vdd,vss,out_38(0));
U2:    basic_orNot4 PORT MAP(interS1,in_123(2),in_123(1),interS4,vdd,vss,out_38(1));
U3:    basic_orNot4 PORT MAP(interS1,in_123(2),interS3,in_123(0),vdd,vss,out_38(2));
U4:    basic_orNot4 PORT MAP(interS1,in_123(2),interS3,interS4,vdd,vss,out_38(3));
U5:    basic_orNot4 PORT MAP(interS1,interS2,in_123(1),in_123(0),vdd,vss,out_38(4));
U6:    basic_orNot4 PORT MAP(interS1,interS2,in_123(1),interS4,vdd,vss,out_38(5));
U7:    basic_orNot4 PORT MAP(interS1,interS2,interS3,in_123(0),vdd,vss,out_38(6));
U8:    basic_orNot4 PORT MAP(interS1,interS2,interS3,interS4,vdd,vss,out_38(7));


U9:    inverter PORT MAP(enable,vdd,vss,interS1);
U10:   inverter PORT MAP(in_123(2),vdd,vss,interS2);
U11:   inverter PORT MAP(in_123(1),vdd,vss,interS3);
U12:   inverter PORT MAP(in_123(0),vdd,vss,interS4);
END decoder_3to8_arch;
--------------------------------------------------------------------------
