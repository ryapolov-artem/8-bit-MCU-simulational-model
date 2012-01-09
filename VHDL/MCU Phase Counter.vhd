------------------------- Phase counter -------------------------------
-- Scheme in book Advanced CMOS Cell Design. Sicard, Bendhia 2007
-- Page 72 of 383 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY phase_counter IS
  PORT(clk_in,reset,vdd,vss: IN STD_LOGIC;
       phase_out: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END phase_counter;

ARCHITECTURE phase_counter OF phase_counter IS
  SIGNAL q_outS, q_invS: STD_LOGIC_VECTOR(3 DOWNTO 0);
 
  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC;
        clk_in,reset,vdd,vss: IN STD_LOGIC;
        q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_xor
    PORT( in_1,in_2,vdd,vss: IN STD_LOGIC;
          out_12: OUT STD_LOGIC);
  END COMPONENT;

  BEGIN
U1:     d_trigger_res PORT MAP(q_invS(3),clk_in,reset,vdd,vss,q_outS(0),q_invS(0));
U2:     basic_xor PORT MAP(q_outS(3),q_invS(0),vdd,vss,phase_out(0));
U3:     d_trigger_res PORT MAP(q_outS(0),clk_in,reset,vdd,vss,q_outS(1),q_invS(1));
U4:     basic_xor PORT MAP(q_outS(0),q_outS(1),vdd,vss,phase_out(1));
U5:     d_trigger_res PORT MAP(q_outS(1),clk_in,reset,vdd,vss,q_outS(2),q_invS(2));
U6:     basic_xor PORT MAP(q_outS(1),q_outS(2),vdd,vss,phase_out(2));
U7:     d_trigger_res PORT MAP(q_outS(2),clk_in,reset,vdd,vss,q_outS(3),q_invS(3));
U8:     basic_xor PORT MAP(q_outS(2),q_outS(3),vdd,vss,phase_out(3));

END phase_counter;
------------------------------------------------------------------