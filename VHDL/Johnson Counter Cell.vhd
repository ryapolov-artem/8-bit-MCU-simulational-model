------------------------ Johnson counter Cell w/ preset ---------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY johnCount_cell IS
  PORT(d_in : INOUT STD_LOGIC;
       clk_in,pe_in,pe_inv_in,j_in,res_inv_in: IN STD_LOGIC;
       vdd,vss,q_out,q_inv_out: INOUT STD_LOGIC);
END johnCount_cell;

ARCHITECTURE johnCount_cell_arch OF johnCount_cell IS
  SIGNAL interS0,interS1,interS2,interS3,interS4,interS5,interS6: STD_LOGIC;
 
  COMPONENT basic_andNot2 
    PORT(in_1,in_2: IN STD_LOGIC; vdd,vss: INOUT STD_LOGIC; out12: INOUT STD_LOGIC);
  END COMPONENT;
      
  COMPONENT inverter
    PORT(in_inv: IN STD_LOGIC; vdd,vss,out_inv: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: INOUT STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: INOUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    basic_andNot2 PORT MAP(res_inv_in,j_in,vdd,vss,interS1);
U2:    transmGate PORT MAP(interS1,pe_inv_in,pe_in,interS4);

U3:    transmGate PORT MAP(d_in,clk_in,interS0,interS2);
U4:    inverter PORT MAP(interS2,vdd,vss,interS3);
U5:    transmGate PORT MAP(interS3,pe_in,pe_inv_in,interS4);
U6:    inverter PORT MAP(interS4,vdd,vss,interS5);
U7:    transmGate PORT MAP(interS5,interS0,clk_in,interS2);

U8:    transmGate PORT MAP(interS5,interS0,clk_in,interS6);
U9:    inverter PORT MAP(interS6,vdd,vss,q_inv_out);
U10:   inverter PORT MAP(q_inv_out,vdd,vss,q_out);
U11:   transmGate PORT MAP(q_out,clk_in,interS0,interS6);

U12:    inverter PORT MAP(clk_in,vdd,vss,interS0);         --makes inverted clk signal


END johnCount_cell_arch;
------------------------------------------------------------------