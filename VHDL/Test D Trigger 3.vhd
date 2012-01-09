------------------------ Testing D-trigger 3 -------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY test_d_trigger_3 IS
  PORT(data_in,enable: IN STD_LOGIC;
       vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
END test_d_trigger_3;

ARCHITECTURE test_d_trigger_3 OF test_d_trigger_3 IS
  SIGNAL enable_inv: STD_LOGIC;
  SIGNAL interS1_S1,interS1_S2: STD_LOGIC;
  SIGNAL interS2_S1,interS2_S2: STD_LOGIC;

  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT test_d_trigger_2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC;
             S1_out,S2_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  BEGIN
U1:    inverter PORT MAP(enable,vdd,vss,enable_inv);
U2:    transmGate PORT MAP(data_in,enable_inv,enable,q_out);
U4:    inverter PORT MAP(q_out,vdd,vss,q_inv_out);
U5:    inverter PORT MAP(q_inv_out,vdd,vss,q_out);

U6:    test_d_trigger_2 PORT MAP(q_out,q_inv_out,vdd,vss,interS1_S1,interS1_S2);
U7:    test_d_trigger_2 PORT MAP(q_inv_out,q_out,vdd,vss,interS2_S1,interS2_S2);

U8:    nFET PORT MAP(interS2_S2,vdd,q_out);
U9:    pFET PORT MAP(interS1_S1,vss,q_out);

U10:   nFET PORT MAP(interS1_S2,vdd,q_inv_out);
U11:   pFET PORT MAP(interS2_S1,vss,q_inv_out);

END test_d_trigger_3;
------------------------------------------------------------------