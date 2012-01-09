------------------ Shifter/rotator with storing -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Page 98 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY shifter_rotator IS
  PORT( data_input      : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       select_operation : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       clk_in,vdd,vss   : IN STD_LOGIC;
       q_out            : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END shifter_rotator;

ARCHITECTURE shifter_rotator_arch OF shifter_rotator IS
  SIGNAL data_in_word: STD_LOGIC_VECTOR(7 DOWNTO 0);
 
  COMPONENT mux_4to1
    PORT( in_1,in_2,in_3,in_4: IN STD_LOGIC;
          select_input  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          vdd,vss       : IN STD_LOGIC;
          out_4         : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT d_trigger
    PORT(d_in: IN STD_LOGIC;
        clk_in,vdd,vss: IN STD_LOGIC;
        q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
U0m:  mux_4to1 PORT MAP(data_input(0),vss,data_input(1),data_input(1),
                select_operation,vdd,vss,data_in_word(0));
U0t:  d_trigger PORT MAP(data_in_word(0),clk_in,vdd,vss,q_out(0));


U1m:  mux_4to1 PORT MAP(data_input(1),data_input(0),data_input(2),
                data_input(2),select_operation,vdd,vss,data_in_word(1));
U1t:  d_trigger PORT MAP(data_in_word(1),clk_in,vdd,vss,q_out(1));


U2m:  mux_4to1 PORT MAP(data_input(2),data_input(1),data_input(3),
                data_input(3),select_operation,vdd,vss,data_in_word(2));
U2t:  d_trigger PORT MAP(data_in_word(2),clk_in,vdd,vss,q_out(2));


U3m:  mux_4to1 PORT MAP(data_input(3),data_input(2),data_input(4),
                data_input(4),select_operation,vdd,vss,data_in_word(3));
U3t:  d_trigger PORT MAP(data_in_word(3),clk_in,vdd,vss,q_out(3));


U4m:  mux_4to1 PORT MAP(data_input(4),data_input(3),data_input(5),
               data_input(5),select_operation,vdd,vss,data_in_word(4));
U4t:  d_trigger PORT MAP(data_in_word(4),clk_in,vdd,vss,q_out(4));


U5m:  mux_4to1 PORT MAP(data_input(5),data_input(4),data_input(6),
                data_input(6),select_operation,vdd,vss,data_in_word(5));
U5t:  d_trigger PORT MAP(data_in_word(5),clk_in,vdd,vss,q_out(5));


U6m:  mux_4to1 PORT MAP(data_input(6),data_input(5),data_input(7),
               data_input(7),select_operation,vdd,vss,data_in_word(6));
U6t:  d_trigger PORT MAP(data_in_word(6),clk_in,vdd,vss,q_out(6));


U7m:  mux_4to1 PORT MAP(data_input(7),data_input(6),vss,data_input(0),
               select_operation,vdd,vss,data_in_word(7));
U7t:  d_trigger PORT MAP(data_in_word(7),clk_in,vdd,vss,q_out(7));
  
END shifter_rotator_arch;
------------------------------------------------------------------