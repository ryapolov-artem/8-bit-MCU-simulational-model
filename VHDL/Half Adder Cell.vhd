------------------------ Half  adder ----------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 8, page 9 of 30. Page 210 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY half_adder_cell IS
  PORT( in_a,in_carry,vdd,vss: IN STD_LOGIC;
        out_carry, out_sum: OUT STD_LOGIC);
END half_adder_cell;

ARCHITECTURE half_adder_cell_arch OF half_adder_cell IS
  
  COMPONENT basic_xor IS
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out_12: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT basic_and2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT; 
  
  BEGIN
U1:   basic_xor PORT MAP(in_a,in_carry,vdd,vss,out_sum);
U2:   basic_and2 PORT MAP(in_a,in_carry,vdd,vss,out_carry);

END half_adder_cell_arch;
------------------------------------------------------------------
