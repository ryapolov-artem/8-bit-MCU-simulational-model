------------------------  n-channel FET  -----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY nFET_v5 IS
    PORT (gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
END nFET_v5;

ARCHITECTURE nFET_v5 OF nFET_v5 IS
    BEGIN
      PROCESS (gate,source)                
        BEGIN
      IF (gate='1' AND source='0') THEN drain<=source;
        ELSIF (gate='H' AND source='0') THEN drain<=source;
        ELSIF (gate='H' AND source='L') THEN drain<=source;
        ELSIF (gate='1' AND source='1') THEN drain<='H';
        ELSIF (gate='H' AND source='1') THEN drain<='H';
      ELSE drain<='Z';
      END IF;
      END PROCESS;
END nFET_v5;
------------------------------------------------------------------


------------------------- p-channel FET  ----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY pFET_v5 IS
    PORT (gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
END pFET_v5;

ARCHITECTURE pFET_v5 OF pFET_v5 IS
    BEGIN
      PROCESS (gate,source)                          
        BEGIN
      IF (gate='0' AND source='1') THEN drain<=source;
        ELSIF (gate='L' AND source='1') THEN drain<=source;
        ELSIF (gate='L' AND source='H') THEN drain<=source;       
        ELSIF (gate='0' AND source='0') THEN drain<='L';
        ELSIF (gate='L' AND source='0') THEN drain<='L'; 
      ELSE  drain<='Z';
      END IF;
      END PROCESS;

END pFET_v5;
-------------------------------------------------------------------
