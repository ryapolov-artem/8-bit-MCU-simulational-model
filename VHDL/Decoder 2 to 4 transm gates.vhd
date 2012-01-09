--------------------- Decoder, built with transmission gates -------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY decoder_2to4_tg IS
  PORT(select_input   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       enable,vdd,vss : IN STD_LOGIC;
               out_24 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END decoder_2to4_tg;

ARCHITECTURE decoder_2to4_tg_arch OF decoder_2to4_tg IS
  SIGNAL interS0,interS1,interS2,interS3: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
  -- First column of transmission gates
U1:   inverter   PORT MAP(select_input(1),vdd,vss,interS1);
U2:   transmGate PORT MAP(enable,select_input(1),interS1,interS2);
U3:   transmGate PORT MAP(enable,interS1,select_input(1),interS3);
 -- Second column of transmission gates
U10:  inverter   PORT MAP(select_input(0),vdd,vss,interS0);
U11:  transmGate PORT MAP(interS2,select_input(0),interS0,out_24(0));
U12:  transmGate PORT MAP(interS2,interS0,select_input(0),out_24(1));

U13:  transmGate PORT MAP(interS3,select_input(0),interS0,out_24(2));
U14:  transmGate PORT MAP(interS3,interS0,select_input(0),out_24(3));
 
END decoder_2to4_tg_arch;
------------------------------------------------------------------
