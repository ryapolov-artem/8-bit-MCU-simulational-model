--------------------- SRAM sense amplifier ------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_sense_amp IS
  PORT( bit_line,bit_line_inv : IN STD_LOGIC;
        read_enable,read_enable_inv: IN STD_LOGIC;
        vdd,vss               : IN STD_LOGIC;
        data_out              : OUT STD_LOGIC);
END sram_sense_amp;

ARCHITECTURE sram_sense_amp_arch OF sram_sense_amp IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6,interS7: STD_LOGIC;

  COMPONENT nFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT pFET
    PORT (gate,source: IN std_logic; drain: OUT std_logic);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT transmGate
    PORT(in_1: IN STD_LOGIC; p_gate,n_gate: IN STD_LOGIC; out_1: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
    
U1:    pFET PORT MAP(bit_line_inv,bit_line,interS1);
U2:    pFET PORT MAP(bit_line,bit_line_inv,interS1);
U3:    nFET PORT MAP(read_enable,vss,interS1);
U4:    transmGate PORT MAP(bit_line_inv,read_enable,read_enable_inv,interS2);
U5:    transmGate PORT MAP(bit_line,read_enable,read_enable_inv,interS3);

U6:    pFET PORT MAP(interS4,vdd,interS4);
U7:    nFET PORT MAP(interS2,interS7,interS4);
U8:    pFET PORT MAP(interS4,vdd,interS5);
U9:    nFET PORT MAP(interS3,interS7,interS5);
   
U10:   inverter PORT MAP(interS5,vdd,vss,interS6);
U11:   inverter PORT MAP(interS6,vdd,vss,data_out);

U12:   nFET PORT MAP(read_enable,vss,interS7);
  
END sram_sense_amp_arch;
------------------------------------------------------------------
