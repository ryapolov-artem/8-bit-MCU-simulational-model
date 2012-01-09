--------------------- Multilpexor 8 to 1 ---------------------------
--Scheme in book Basics of CMOS cell design. Sicard, Bendhia.2007
--Page 222

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mux_8to1_2 IS
  PORT( paral_input: IN STD_LOGIC_VECTOR(0 TO 7);
       select_input: IN STD_LOGIC_VECTOR(0 TO 2);
       vdd,vss: IN STD_LOGIC;
       out_8: INOUT STD_LOGIC);
END mux_8to1_2;

ARCHITECTURE mux_8to1_2_arch OF mux_8to1_2 IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6: STD_LOGIC;
  
  COMPONENT mux_2to1
    PORT( in_1,in_2: IN STD_LOGIC; sel_in,vdd,vss: IN STD_LOGIC;
           out_12: INOUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
U1:   mux_2to1 PORT MAP(paral_input(0),paral_input(1),select_input(0),vdd,vss,interS1);
U2:   mux_2to1 PORT MAP(paral_input(2),paral_input(3),select_input(0),vdd,vss,interS2);
U3:   mux_2to1 PORT MAP(paral_input(4),paral_input(5),select_input(0),vdd,vss,interS3);
U4:   mux_2to1 PORT MAP(paral_input(6),paral_input(7),select_input(0),vdd,vss,interS4);

U5:   mux_2to1 PORT MAP(interS1,interS2,select_input(1),vdd,vss,interS5);
U6:   mux_2to1 PORT MAP(interS3,interS4,select_input(1),vdd,vss,interS6);

U7:   mux_2to1 PORT MAP(interS5,interS6,select_input(2),vdd,vss,out_8);

END mux_8to1_2_arch;
------------------------------------------------------------------