--------------------- Multilpexor 4 to 1 ---------------------------
--Scheme "Mux 8 to 1" in book Basics of CMOS cell design. Sicard, Bendhia.2007
--Page 223

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mux_4to1 IS
  PORT( in_1,in_2,in_3,in_4: IN STD_LOGIC;
       select_input: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       vdd,vss: IN STD_LOGIC;
       out_4: OUT STD_LOGIC);
END mux_4to1;

ARCHITECTURE mux_4to1_arch OF mux_4to1 IS
  SIGNAL interS1,interS2,interS3,interS4: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
 -- Second column of transmission gates
U1:  inverter   PORT MAP(select_input(0),vdd,vss,interS1);
U2:  transmGate PORT MAP(in_1,select_input(0),interS1,interS2);
U3:  transmGate PORT MAP(in_2,interS1,select_input(0),interS2);

U4:  transmGate PORT MAP(in_3,select_input(0),interS1,interS3);
U5:  transmGate PORT MAP(in_4,interS1,select_input(0),interS3);

 -- Output multiplexor
U6:  inverter   PORT MAP(select_input(1),vdd,vss,interS4);
U7:  transmGate PORT MAP(interS2,select_input(1),interS4,out_4);
U8:  transmGate PORT MAP(interS3,interS4,select_input(1),out_4);
 
END mux_4to1_arch;
------------------------------------------------------------------