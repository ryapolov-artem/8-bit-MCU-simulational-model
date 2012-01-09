------------------------  n-channel FET  -----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY nFET IS
    PORT (gate,source: IN STD_LOGIC; drain: INOUT STD_LOGIC);
END nFET;

ARCHITECTURE nFET OF nFET IS
    BEGIN
      PROCESS (gate,source)                           --one direction
        BEGIN
      IF (gate='1' AND source='0') THEN drain<=source;
        ELSIF (gate='H' AND source='0') THEN drain<=source;
        ELSIF (gate='H' AND source='L') THEN drain<=source;     -- gate=H AND source=L ---????
        ELSIF (gate='1' AND source='1') THEN drain<='H';
      ELSE drain<='Z';
      END IF;
      END PROCESS;
--      PROCESS (gate,drain)                           --another direction
--        BEGIN
--      IF (gate='1' AND drain='0') THEN source<=drain;
--        ELSIF (gate='1' AND drain='1') THEN source<='H';
--      ELSE source<='Z';
--      END IF;
--     END PROCESS;
END nFET;
------------------------------------------------------------------


------------------------- p-channel FET  ----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY pFET IS
    PORT (gate,source: IN STD_LOGIC; drain: INOUT STD_LOGIC);
END pFET;

ARCHITECTURE pFET OF pFET IS
    BEGIN
      PROCESS (gate,source)                           --one direction
        BEGIN
      IF (gate='0' AND source='1') THEN drain<=source;
        ELSIF (gate='L' AND source='1') THEN drain<=source;
        ELSIF (gate='L' AND source='H') THEN drain<=source;        -- gate=L AND source=H -?????        
        ELSIF (gate='0' AND source='0') THEN drain<='L';
      ELSE  drain<='Z';
      END IF;
      END PROCESS;
--      PROCESS (gate,drain)                           --another direction
--        BEGIN
--      IF (gate='0' AND drain='1') THEN source<=drain;
--        ELSIF (gate='0' AND drain='0') THEN source<='L';
--      ELSE source<='Z';
--      END IF;
--      END PROCESS;
END pFET;
-------------------------------------------------------------------