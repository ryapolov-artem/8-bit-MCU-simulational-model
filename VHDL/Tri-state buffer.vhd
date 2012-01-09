----------------- Tri-state one directional buffer ---------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 4, page 21 of 28. Page 95 in PDF file

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY tri_state_buffer IS 
PORT (data_in, enable, vdd, vss: IN STD_LOGIC;
                       data_out: OUT STD_LOGIC);
END tri_state_buffer;

ARCHITECTURE tri_state_buffer_arch OF tri_state_buffer IS
  SIGNAL interS1,interS2,interS3: STD_LOGIC;
  
  COMPONENT basic_andNot2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC; vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
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
U1:    basic_andNot2 PORT MAP(data_in,enable,vdd,vss,interS1);
U2:    inverter PORT MAP(data_in,vdd,vss,interS2); 
U3:    basic_and2 PORT MAP(interS2,enable,vdd,vss,interS3);
U4:    pFET PORT MAP(interS1,vdd,data_out);
U5:    nFET PORT MAP(interS3,vss,data_out);

END tri_state_buffer_arch;
    