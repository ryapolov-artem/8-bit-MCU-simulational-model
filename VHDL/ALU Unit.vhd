-------------------------- ALU unit ------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 10 of 28. Page 84 in PDF file

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY alu_unit IS
  PORT( a_word            : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        b_word            : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        vdd,vss           : IN STD_LOGIC;
        out_word          : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        unsigned_overflow : INOUT STD_LOGIC;
        signed_overflow   : INOUT STD_LOGIC);
END alu_unit;

ARCHITECTURE alu_unit_arch OF alu_unit IS
  SIGNAL x_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL y_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL carry_word : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
  COMPONENT full_Adder_Cell
    PORT( in_a, in_b, in_carry,vdd,vss: IN STD_LOGIC;
                    out_sum, out_carry: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT alu_logic_extender
    PORT( in_a,in_b,vdd,vss : IN STD_LOGIC;
          operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          out_x             : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT alu_arithmetic_extender
    PORT( in_b,vdd,vss      : IN STD_LOGIC;
          operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          out_y             : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT alu_carry_extender
    PORT( vdd,vss           : IN STD_LOGIC;
          operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          out_c0            : OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_xor
    PORT( in_1,in_2,vdd,vss : IN STD_LOGIC;
                      out_12: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
Extenders_cells: FOR i IN 7 DOWNTO 0 GENERATE
    
    LogicExtenders:   alu_logic_extender PORT MAP( 
          a_word(i), b_word(i), vdd, vss,
          operation_select, x_word(i));
          
    ArithExtenders:   alu_arithmetic_extender PORT MAP(
          b_word(i), vdd, vss, operation_select, y_word(i));
               
  END GENERATE Extenders_cells;
  
Adders_cells: FOR i IN 6 DOWNTO 0 GENERATE
    
      FullAdderCells:   full_Adder_Cell PORT MAP( 
          x_word(i), y_word(i), carry_word(i), vdd, vss,
          out_word(i), carry_word(i+1));
                         
  END GENERATE Adders_cells;
  
AdderCell_bit7:   full_Adder_Cell PORT MAP( 
          x_word(7), y_word(7), carry_word(7), vdd, vss,
          out_word(7), unsigned_overflow);
  
CarryExtender: alu_carry_extender PORT MAP(
          vdd, vss, operation_select, carry_word(0));
    
SingnedOverflow: basic_xor PORT MAP(
          carry_word(7), unsigned_overflow, vdd, vss, signed_overflow);

END alu_unit_arch;
------------------------------------------------------------------
