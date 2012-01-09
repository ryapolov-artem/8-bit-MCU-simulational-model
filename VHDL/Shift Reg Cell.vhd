------------------------ Shift Register Cell  -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY shiftReg_cell IS
  PORT(d_inv_in,p_in : INOUT STD_LOGIC;
       clk_in,ps_switch: IN STD_LOGIC;
       vdd,vss,q_inv_out: INOUT STD_LOGIC);
END shiftReg_cell;

ARCHITECTURE shiftReg_cell_arch OF shiftReg_cell IS
  SIGNAL interS0,interS1,interS2,interS3,interS4,interS5,interS6,interS7: STD_LOGIC;
 
  COMPONENT inverter
    PORT(in_inv: IN STD_LOGIC; vdd,vss,out_inv: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: INOUT STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: INOUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    inverter PORT MAP(ps_switch,vdd,vss,interS1);
U2:    transmGate PORT MAP(p_in,ps_switch,interS1,interS2);
U3:    transmGate PORT MAP(d_inv_in,interS1,ps_switch,interS2);

U4:    transmGate PORT MAP(interS2,clk_in,interS0,interS3);
U5:    inverter PORT MAP(interS3,vdd,vss,interS4);
U6:    inverter PORT MAP(interS4,vdd,vss,interS5);
U7:    transmGate PORT MAP(interS5,interS0,clk_in,interS3);

U8:    transmGate PORT MAP(interS4,interS0,clk_in,interS6);
U9:    inverter PORT MAP(interS6,vdd,vss,q_inv_out);
U10:   inverter PORT MAP(q_inv_out,vdd,vss,interS7);
U11:   transmGate PORT MAP(interS7,clk_in,interS0,interS6);

U12:    inverter PORT MAP(clk_in,vdd,vss,interS0);         --makes inverted clk signal


END shiftReg_cell_arch;
------------------------------------------------------------------

