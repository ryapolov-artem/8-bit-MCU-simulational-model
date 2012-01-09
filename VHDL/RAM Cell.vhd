------------------------- Single RAM memory cell ------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY sram_cell IS
  PORT( wordLine : IN STD_LOGIC;
        bitLine,bitLine_inv: INOUT STD_LOGIC;
        vdd,vss: IN STD_LOGIC);
END sram_cell;

ARCHITECTURE sram_cell OF sram_cell IS
  SIGNAL interS1,interS2: STD_LOGIC;

  COMPONENT sram_nFET
    PORT (gate: IN std_logic; source,drain: INOUT std_logic);
  END COMPONENT;
  
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:    sram_nFET PORT MAP(wordLine,bitLine,interS1);
U2:    sram_nFET PORT MAP(wordLine,bitLine_inv,interS2);

U3:    inverter PORT MAP(interS1,vdd,vss,interS2);
U4:    inverter PORT MAP(interS2,vdd,vss,interS1);
-- U5:    inverter PORT MAP(bitLine,vdd,vss,bitLine_inv);      -- makes inverted bit line signal
  
END sram_cell;
------------------------------------------------------------------