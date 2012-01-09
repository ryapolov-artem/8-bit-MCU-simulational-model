------------------------- Register File Cell D Trigger ------------------
-- Scheme in book Ueikerli, Proektirovanie cifrovih ustroistv. vol 1, p.434
-- Scheme without tri-state buffer on output

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY reg_file_cell_dtrig IS
  PORT( data_in,write        : IN STD_LOGIC;
        read_a,read_b,vdd,vss: IN STD_LOGIC;
        data_out_a,data_out_b: INOUT STD_LOGIC);
END reg_file_cell_dtrig;

ARCHITECTURE reg_file_cell_dtrig OF reg_file_cell_dtrig IS
  SIGNAL interS1,interS2,interS3: STD_LOGIC;

  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
    
  COMPONENT tri_state_buffer_tg
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
                           data_out: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U0:    inverter PORT MAP(write,vdd,vss,interS1);
U1:    transmGate PORT MAP(data_in,interS1,write,interS2);
U2:    inverter PORT MAP(interS2,vdd,vss,interS3);
U3:    inverter PORT MAP(interS3,vdd,vss,interS2);
U4:    tri_state_buffer_tg PORT MAP(interS2,read_a,vdd,vss,data_out_a);
U5:    tri_state_buffer_tg PORT MAP(interS2,read_b,vdd,vss,data_out_b);

END reg_file_cell_dtrig;
------------------------------------------------------------------