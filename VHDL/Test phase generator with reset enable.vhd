------------------------- Phase generator -------------------------------
--                       with reset enable
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY phase_w_res_enalbe IS
  PORT(clk_in,reset,vdd,vss: IN STD_LOGIC;
       phase_out: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END phase_w_res_enalbe;

ARCHITECTURE phase_w_res_enalbe OF phase_w_res_enalbe IS
  SIGNAL interS1,interS2: STD_LOGIC;

  COMPONENT phase_counter
    PORT(clk_in,reset,vdd,vss: IN STD_LOGIC;
                    phase_out: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  BEGIN
U1:    phase_counter PORT MAP(clk_in,interS2,vdd,vss,phase_out);
U2:   basic_andNot2 PORT MAP(interS1,reset,vdd,vss,interS2);
U3:   inverter PORT MAP(clk_in,vdd,vss,interS1);

END phase_w_res_enalbe;
--------------------------------------------------------------------------