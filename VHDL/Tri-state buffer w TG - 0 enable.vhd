----------------- Tri-state transmission gate based buffer ---------------------
-- One Transmission gate, one inverter
-- Output ON when enable=0

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY tri_state_buffer_tg0 IS 
PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
                       data_out: OUT STD_LOGIC);
END tri_state_buffer_tg0;

ARCHITECTURE tri_state_buffer_tg0 OF tri_state_buffer_tg0 IS
  SIGNAL interS1: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    transmGate PORT MAP(data_in,enable,interS1,data_out);
U2:    inverter PORT MAP(enable,vdd,vss,interS1);         --makes inverted enable signal

END tri_state_buffer_tg0;