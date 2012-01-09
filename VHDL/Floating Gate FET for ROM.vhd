--------------  n-channel floating gate FET for PROM -----------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY floating_gate_FET IS
  PORT (gate,floating_gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
END floating_gate_FET;

ARCHITECTURE floating_gate_FET OF floating_gate_FET IS
  BEGIN
    PROCESS (gate,floating_gate,source)
      BEGIN
      IF (gate='1') AND (source='0') THEN
        
        IF floating_gate='0' THEN drain<=source;
          ELSE drain<='Z';
        END IF;
        
      ELSIF (gate='H' AND source='0') THEN 
         IF floating_gate='0' THEN drain<=source;
            ELSE drain<='Z';
          END IF;
        
      ELSIF (gate='0' OR gate='Z' OR gate='U') THEN drain<='Z';
      END IF;
  END PROCESS;
END floating_gate_FET;
-----------------------------------------------------------------------------