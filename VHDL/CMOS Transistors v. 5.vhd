------------------------  n-channel FET  -----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY nFET IS
    PORT (gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
END nFET;

ARCHITECTURE nFET OF nFET IS

    BEGIN
      PROCESS (gate,source)                
        BEGIN
      IF (gate='1' AND source='0') OR 
         (gate='H' AND source='0') OR 
         (gate='1' AND source='L') OR 
         (gate='H' AND source='L') THEN drain<=source;
      ELSIF (gate='1' AND source='H') OR 
            (gate='1' AND source='1') OR 
            (gate='H' AND source='H') THEN drain<='H';
      ELSE drain<='Z'; -- gate=0 or L; gate=H and source=1
      END IF;
      END PROCESS;

END nFET;
------------------------------------------------------------------


------------------------- p-channel FET  ----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY pFET IS
    PORT (gate,source: IN STD_LOGIC; drain: OUT STD_LOGIC);
END pFET;

ARCHITECTURE pFET OF pFET IS

    BEGIN
      PROCESS (gate,source)                          
        BEGIN
      IF (gate='0' AND source='1') OR
         (gate='L' AND source='1') OR
         (gate='0' AND source='H') OR
         (gate='L' AND source='H') THEN drain<=source;
      ELSIF (gate='0' AND source='L') OR
            (gate='0' AND source='0') OR 
            (gate='L' AND source='L') THEN drain<='L'; --??
      ELSE  drain<='Z';
      END IF;
      END PROCESS;

END pFET;
-------------------------------------------------------------------