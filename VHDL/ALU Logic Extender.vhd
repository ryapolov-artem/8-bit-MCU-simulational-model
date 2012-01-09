----------------------- ALU logic extender -----------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 12 of 28. Page 86 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY alu_logic_extender IS
  PORT( in_a,in_b,vdd,vss : IN STD_LOGIC;
        operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_x             : OUT STD_LOGIC);
END alu_logic_extender;

ARCHITECTURE alu_logic_extender_arch OF alu_logic_extender IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6,
         interS7,interS8,interS9: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT basic_or2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_or4
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and3
    PORT(in_1,in_2,in_3,vdd,vss: IN STD_LOGIC; out13: OUT STD_LOGIC);
  END COMPONENT;
 
  COMPONENT basic_and4
    PORT(in_1,in_2,in_3,in_4: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out14: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:   basic_and2 PORT MAP(operation_select(2),in_a,vdd,vss,interS6);
U2:   basic_and2 PORT MAP(interS1,in_a,vdd,vss,interS7);
U3:   basic_and3 PORT MAP(interS2,in_a,in_b,vdd,vss,interS8);

U4:   basic_or2 PORT MAP(in_b,operation_select(0),vdd,vss,interS4);
U5:   basic_and4 PORT MAP(interS3,interS4,operation_select(1),interS5,vdd,vss,interS9);
U6:   basic_or4 PORT MAP(interS6,interS7,interS8,interS9,vdd,vss,out_x);

U7:  inverter PORT MAP(operation_select(0),vdd,vss,interS1);
U8:  inverter PORT MAP(operation_select(1),vdd,vss,interS2);
U9:  inverter PORT MAP(in_a,vdd,vss,interS3);
U10: inverter PORT MAP(operation_select(2),vdd,vss,interS5);

END alu_logic_extender_arch;
------------------------------------------------------------------
