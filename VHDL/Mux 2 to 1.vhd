--------------------- Multilpexor 2 to 1 ---------------------------
--Scheme in book Basics of CMOS cell design. Sicard, Bendhia.2007
--Page 219

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY mux_2to1 IS
  PORT( in_1,in_2: IN STD_LOGIC;
           sel_in,vdd,vss: IN STD_LOGIC;
           out_12: OUT STD_LOGIC);
END mux_2to1;

ARCHITECTURE mux_2to1_arch OF mux_2to1 IS
  SIGNAL interS1: STD_LOGIC;
  SIGNAL out_12_interS: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
    
  BEGIN
U1:   inverter PORT MAP(sel_in,vdd,vss,interS1);  -- makes inverted SELECT signal
U2:   transmGate PORT MAP(in_1,sel_in,interS1,out_12_interS);
U3:   transmGate PORT MAP(in_2,interS1,sel_in,out_12_interS);
Latens: out_12 <= out_12_interS after 10 ps;

END mux_2to1_arch;
------------------------------------------------------------------