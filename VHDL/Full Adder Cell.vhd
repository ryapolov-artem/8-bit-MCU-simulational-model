------------------------ Full adder with cell based carry -------------------
--Scheme in book Basics of CMOS cell design. Sicard, Bendhia.2007
--Page 241-242

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY full_Adder_Cell IS
  PORT( in_a, in_b, in_carry,vdd,vss: IN STD_LOGIC;
        out_sum, out_carry: OUT STD_LOGIC);
END full_Adder_Cell;

ARCHITECTURE full_Adder_Cell_arch OF full_Adder_Cell IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6: STD_LOGIC;

  COMPONENT basic_xor IS
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out_12: OUT STD_LOGIC);
  END COMPONENT;
   
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  BEGIN
--Sum circuit:
U1:   basic_xor PORT MAP(in_a,in_b,vdd,vss,interS1);
U2:   basic_xor PORT MAP(interS1,in_carry,vdd,vss,out_sum);
--Carry cell:
U3:   pFET PORT MAP (in_carry,vdd,interS2);
U4:   pFET PORT MAP (in_a,interS2,interS3);
U5:   nFET PORT MAP (in_a,interS4,interS3);
U6:   nFET PORT MAP (in_b,vss,interS4);

U7:   pFET PORT MAP (in_a,vdd,interS5);
U8:   pFET PORT MAP (in_b,interS5,interS2);
U9:   pFET PORT MAP (in_b,interS2,interS3);
U10:  nFET PORT MAP (in_carry,interS6,interS3);
U11:  nFET PORT MAP (in_a,vss,interS6);
U12:  nFET PORT MAP (in_b,vss,interS6);

U13:  inverter PORT MAP(interS3,vdd,vss,out_carry);

END full_Adder_Cell_arch;
------------------------------------------------------------------