------------------------- SRAM D-trigger based memory cell ------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_dtrig_cell IS
  PORT( data_in,select_in,write : IN STD_LOGIC;
        vdd,vss: IN STD_LOGIC;
        data_out: OUT STD_LOGIC);
END sram_dtrig_cell;

ARCHITECTURE sram_dtrig_cell OF sram_dtrig_cell IS
  SIGNAL interS1,interS2,interS3,interS4: STD_LOGIC;

  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT tri_state_buffer_tg
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
                           data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    basic_and2 PORT MAP(select_in,write,vdd,vss,interS1);

U2:    inverter PORT MAP(interS1,vdd,vss,interS2);
U3:    transmGate PORT MAP(data_in,interS2,interS1,interS3);
U4:    inverter PORT MAP(interS3,vdd,vss,interS4);
U5:    inverter PORT MAP(interS4,vdd,vss,interS3);

U6:    tri_state_buffer_tg PORT MAP(interS3,select_in,vdd,vss,data_out);

END sram_dtrig_cell;
------------------------------------------------------------------