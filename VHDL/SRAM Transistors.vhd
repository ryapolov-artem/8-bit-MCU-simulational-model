------------------------  n-channel FET  -----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY sram_nFET IS
    PORT (gate: IN STD_LOGIC; source,drain: INOUT STD_LOGIC);
END sram_nFET;

ARCHITECTURE sram_nFET_arch OF sram_nFET IS
    BEGIN
      PROCESS (gate,source)                           --one direction
        BEGIN
      IF (gate='1' AND source='0') THEN drain<=source;
        ELSIF (gate='1' AND source='1') THEN drain<='H';
      ELSE drain<='Z';
      END IF;
      END PROCESS;
      
      PROCESS (gate,drain)                           --another direction
        BEGIN
      IF (gate='1' AND drain='0') THEN source<=drain;
        ELSIF (gate='1' AND drain='1') THEN source<='H';
      ELSE source<='Z';
      END IF;
     END PROCESS;
END sram_nFET_arch;
------------------------------------------------------------------


------------------------- p-channel FET  ----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY sram_pFET IS
    PORT (gate: IN STD_LOGIC; source,drain: INOUT STD_LOGIC);
END sram_pFET;

ARCHITECTURE sram_pFET_arch OF sram_pFET IS
    BEGIN
      PROCESS (gate,source)                           --one direction
        BEGIN
      IF (gate='0' AND source='1') THEN drain<=source;
        ELSIF (gate='0' AND source='0') THEN drain<='L';
      ELSE  drain<='Z';
      END IF;
      END PROCESS;
      
      PROCESS (gate,drain)                           --another direction
        BEGIN
      IF (gate='0' AND drain='1') THEN source<=drain;
        ELSIF (gate='0' AND drain='0') THEN source<='L';
      ELSE source<='Z';
      END IF;
      END PROCESS;
END sram_pFET_arch;
-------------------------------------------------------------------