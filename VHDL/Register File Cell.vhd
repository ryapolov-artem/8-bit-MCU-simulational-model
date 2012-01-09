------------------ Register File Cell -------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY regiter_file_cell IS
  PORT( data_in              : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        write                : IN STD_LOGIC;
        read_a,read_b,vdd,vss: IN STD_LOGIC;
        data_out_a,data_out_b: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END regiter_file_cell;

ARCHITECTURE regiter_file_cell_arch OF regiter_file_cell IS
 
  COMPONENT reg_file_cell_dtrig
    PORT( data_in,write : IN STD_LOGIC;
          read_a,read_b,vdd,vss: IN STD_LOGIC;
          data_out_a,data_out_b: INOUT STD_LOGIC);
  END COMPONENT;
   
  BEGIN
  reg_file_cell_dtrigs: FOR i IN 7 DOWNTO 0 GENERATE
      U1to8: reg_file_cell_dtrig  PORT MAP(data_in(i),write,read_a,read_b,vdd,vss,data_out_a(i),data_out_b(i));
  END GENERATE reg_file_cell_dtrigs;
  
END regiter_file_cell_arch;
------------------------------------------------------------------