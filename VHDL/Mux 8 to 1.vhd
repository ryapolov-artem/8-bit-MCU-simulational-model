--------------------- Multilpexor 8 to 1 ---------------------------
--Scheme in book Basics of CMOS cell design. Sicard, Bendhia.2007
--Page 223

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mux_8to1 IS
  PORT( paral_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       select_input: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       vdd,vss: IN STD_LOGIC;
       out_8: OUT STD_LOGIC);
END mux_8to1;

ARCHITECTURE mux_8to1_arch OF mux_8to1 IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6,interS7,interS8,interS9: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
  -- First column of transmission gates
U1:   inverter   PORT MAP(select_input(0),vdd,vss,interS1);
U2:   transmGate PORT MAP(paral_input(0),select_input(0),interS1,interS2);
U3:   transmGate PORT MAP(paral_input(1),interS1,select_input(0),interS2);

U4:   transmGate PORT MAP(paral_input(2),select_input(0),interS1,interS3);
U5:   transmGate PORT MAP(paral_input(3),interS1,select_input(0),interS3);

U6:   transmGate PORT MAP(paral_input(4),select_input(0),interS1,interS4);
U7:   transmGate PORT MAP(paral_input(5),interS1,select_input(0),interS4);

U8:   transmGate PORT MAP(paral_input(6),select_input(0),interS1,interS5);
U9:   transmGate PORT MAP(paral_input(7),interS1,select_input(0),interS5);

 -- Second column of transmission gates
U10:  inverter   PORT MAP(select_input(1),vdd,vss,interS6);
U11:  transmGate PORT MAP(interS2,select_input(1),interS6,interS7);
U12:  transmGate PORT MAP(interS3,interS6,select_input(1),interS7);

U13:  transmGate PORT MAP(interS4,select_input(1),interS6,interS8);
U14:  transmGate PORT MAP(interS5,interS6,select_input(1),interS8);

 -- Output multiplexor
U15:  inverter   PORT MAP(select_input(2),vdd,vss,interS9);
U16:  transmGate PORT MAP(interS7,select_input(2),interS9,out_8);
U17:  transmGate PORT MAP(interS8,interS9,select_input(2),out_8);
 
END mux_8to1_arch;
------------------------------------------------------------------