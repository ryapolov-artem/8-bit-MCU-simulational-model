------------------------------ PC Address decoder ---------------------------- 
-- PC address is '0000 0110'
-- Particular case of 6-bit decoder
-- When address bit 7 equals '0', then it is the address of register and not a memory cell

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY pc_addr_decoder IS
  PORT( addr_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        vdd,vss   : IN STD_LOGIC;
        out_signal: OUT STD_LOGIC);
END pc_addr_decoder;

ARCHITECTURE pc_addr_decoder OF pc_addr_decoder IS
  SIGNAL inv_addr_bit_7,inv_addr_bit_4,inv_addr_bit_3,inv_addr_bit_0: STD_LOGIC;
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
U4:   inverter PORT MAP(addr_in(0),vdd,vss,inv_addr_bit_0);
U5:   basic_and3 PORT MAP(inv_addr_bit_7,inv_addr_bit_4,inv_addr_bit_3,vdd,vss,interS1);
U6:   basic_and3 PORT MAP(addr_in(2),addr_in(1),inv_addr_bit_0,vdd,vss,interS2);
U7:   basic_and2 PORT MAP(interS1,interS2,vdd,vss,out_signal);
 
END pc_addr_decoder;
  