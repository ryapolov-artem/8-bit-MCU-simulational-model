------------------------------ WD Control register address decoder ---------------------------- 
-- WD address is '0000 0111'

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY wd_ctrl_reg_addr_decoder IS
  PORT( addr_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        vdd,vss   : IN STD_LOGIC;
        out_signal: OUT STD_LOGIC);
END wd_ctrl_reg_addr_decoder;

ARCHITECTURE wd_ctrl_reg_addr_decoder OF wd_ctrl_reg_addr_decoder IS
  SIGNAL inv_addr_bit_7,inv_addr_bit_4,inv_addr_bit_3: STD_LOGIC;
  SIGNAL interS1: STD_LOGIC;
  SIGNAL interS2: STD_LOGIC;

  COMPONENT basic_and3
    PORT(in_1,in_2,in_3: IN STD_LOGIC;
         vdd,vss: IN STD_LOGIC;
         out13: OUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_and2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;
 
  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
U1:   inverter PORT MAP(addr_in(7),vdd,vss,inv_addr_bit_7);
U2:   inverter PORT MAP(addr_in(4),vdd,vss,inv_addr_bit_4);
U3:   inverter PORT MAP(addr_in(3),vdd,vss,inv_addr_bit_3);
U5:   basic_and3 PORT MAP(inv_addr_bit_7,inv_addr_bit_4,inv_addr_bit_3,vdd,vss,interS1);
U6:   basic_and3 PORT MAP(addr_in(2),addr_in(1),addr_in(0),vdd,vss,interS2);
U7:   basic_and2 PORT MAP(interS1,interS2,vdd,vss,out_signal);
 
END wd_ctrl_reg_addr_decoder;
-----------------------------------------------------------------------------------------------