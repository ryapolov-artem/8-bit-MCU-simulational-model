------------------------ Carry extender -------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 12 of 28. Page 86 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY alu_carry_extender IS
  PORT( vdd,vss           : IN STD_LOGIC;
        operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_c0            : OUT STD_LOGIC);
END alu_carry_extender;

ARCHITECTURE alu_carry_extender_arch OF alu_carry_extender IS
  SIGNAL interS1: STD_LOGIC;

  COMPONENT basic_xor IS
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out_12: OUT STD_LOGIC);
  END COMPONENT;
   
  COMPONENT basic_and2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
 
  BEGIN
U1:   basic_xor PORT MAP(operation_select(0),operation_select(1),vdd,vss,interS1);
U2:   basic_and2 PORT MAP(interS1,operation_select(2),vdd,vss,out_c0);

END alu_carry_extender_arch;
------------------------------------------------------------------