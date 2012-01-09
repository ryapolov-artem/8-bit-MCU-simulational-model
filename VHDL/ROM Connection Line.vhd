--------------  Connection line for floating gate FETs -----------------------
--                  Unites  FETs' drains
-- Unnatural element, just behavioural model, which simplifies ROM model
--  Schematics similar to the one in book "Proektirovanie cifrovih ustroistv. Ueikerly. vol. 2" p.435

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY rom_connect_line IS
  PORT (in_from_drains,to_vdd: IN STD_LOGIC; to_out_buffers: OUT STD_LOGIC);
END rom_connect_line;

ARCHITECTURE rom_connect_line OF rom_connect_line IS
  BEGIN
    PROCESS (in_from_drains)
      BEGIN
      IF (in_from_drains='0') THEN to_out_buffers<=in_from_drains;
          ELSE to_out_buffers<=to_vdd;
      END IF;
  END PROCESS;
END rom_connect_line;
-----------------------------------------------------------------------------