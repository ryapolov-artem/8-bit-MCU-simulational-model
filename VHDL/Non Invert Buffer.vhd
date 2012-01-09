----------------- Non inverting Buffer ---------------------
-- Two inverters

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY non_inv_buffer IS 
PORT (data_in,vdd,vss: IN STD_LOGIC;
        data_out: OUT STD_LOGIC);
END non_inv_buffer;

ARCHITECTURE non_inv_buffer OF non_inv_buffer IS
  SIGNAL interS1: STD_LOGIC;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;

  BEGIN
U1:    inverter PORT MAP(data_in,vdd,vss,interS1);
U2:    inverter PORT MAP(interS1,vdd,vss,data_out);

END non_inv_buffer;