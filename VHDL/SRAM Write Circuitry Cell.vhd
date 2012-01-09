--------------------- SRAM memory cell write circuitry ------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_write_circuit IS
  PORT( data_in,write_enable : IN STD_LOGIC;
        vdd,vss              : IN STD_LOGIC;
        bit_line,bit_line_inv: OUT STD_LOGIC);
END sram_write_circuit;

ARCHITECTURE sram_write_circuit_arch OF sram_write_circuit IS
  SIGNAL interS1,interS2,interS3,interS4,interS5: STD_LOGIC;

  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    inverter PORT MAP(data_in,vdd,vss,interS1);
U2:    inverter PORT MAP(interS1,vdd,vss,interS2);

U3:    nFET PORT MAP(write_enable,interS2,interS4); --t1
U4:    nFET PORT MAP(write_enable,interS1,interS3); --t2
U5:    nFET PORT MAP(interS4,interS5,bit_line);     --t3
U6:    nFET PORT MAP(interS3,interS5,bit_line_inv); --t4
U7:    nFET PORT MAP(write_enable,vss,interS5);     --t5
  
END sram_write_circuit_arch;
------------------------------------------------------------------