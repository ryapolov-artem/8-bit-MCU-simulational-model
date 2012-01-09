------------------------ 8 bit tri-state buffer ---------------------
-- Based on scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 21 of 28. Page 95 in PDF file

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY tri_state_buffer_8bit IS 
PORT (data_input      :   IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      enable,vdd,vss  :   IN STD_LOGIC;
      data_output     :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END tri_state_buffer_8bit;

ARCHITECTURE tri_state_buffer_8bit_arch OF tri_state_buffer_8bit IS
   
  COMPONENT tri_state_buffer IS 
    PORT (data_in, enable, vdd, vss: IN STD_LOGIC; data_out: OUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
Buffers:  FOR k IN 7 DOWNTO 0 GENERATE
  Uk: tri_state_buffer PORT MAP(data_input(k),enable,vdd,vss,data_output(k));
  END GENERATE Buffers;

END tri_state_buffer_8bit_arch;