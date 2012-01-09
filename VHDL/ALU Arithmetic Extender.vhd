----------------------- ALU arithmetic extender -----------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 12 of 28. Page 86 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY alu_arithmetic_extender IS
  PORT( in_b,vdd,vss      : IN STD_LOGIC;
        operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_y             : OUT STD_LOGIC);
END alu_arithmetic_extender;

ARCHITECTURE alu_arithmetic_extender_arch OF alu_arithmetic_extender IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT basic_or2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and3
    PORT(in_1,in_2,in_3,vdd,vss: IN STD_LOGIC; out13: OUT STD_LOGIC);
  END COMPONENT;
 
  COMPONENT basic_and4
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
    
U1:   basic_or2 PORT MAP(operation_select(1),interS2,vdd,vss,interS1);
U2:   basic_and3 PORT MAP(operation_select(2),operation_select(0),interS1,vdd,vss,interS5);
U3:   basic_and4 PORT MAP(operation_select(2),interS3,interS4,in_b,vdd,vss,interS6);

U4:  inverter PORT MAP(in_b,vdd,vss,interS2);
U5:  inverter PORT MAP(operation_select(1),vdd,vss,interS3);
U6:  inverter PORT MAP(operation_select(0),vdd,vss,interS4);

U7:  basic_or2 PORT MAP(interS5,interS6,vdd,vss,out_y);

END alu_arithmetic_extender_arch;
------------------------------------------------------------------
