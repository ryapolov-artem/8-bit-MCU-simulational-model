----------------------- Port A Registers Address decoder ---------------------------- 
-- Port A Data Register Address is '0000 1100'

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY port_b_regs_decoders IS
  PORT( addr_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        vdd,vss   : IN STD_LOGIC;
        data_reg  : OUT STD_LOGIC;
        dir_reg   : OUT STD_LOGIC;
        read_reg  : OUT STD_LOGIC);
END port_b_regs_decoders;

ARCHITECTURE port_b_regs_decoders OF port_b_regs_decoders IS
  SIGNAL inv_addr_bit_7,inv_addr_bit_4,inv_addr_bit_1,inv_addr_bit_0: STD_LOGIC;
  SIGNAL interS1,interS2,interS3,interS4: STD_LOGIC; 

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
U3:   inverter PORT MAP(addr_in(1),vdd,vss,inv_addr_bit_1);
U4:   inverter PORT MAP(addr_in(0),vdd,vss,inv_addr_bit_0);

U5:   basic_and3 PORT MAP(inv_addr_bit_7,inv_addr_bit_4,addr_in(3),vdd,vss,interS1);
U6:   basic_and3 PORT MAP(addr_in(2),inv_addr_bit_1,inv_addr_bit_0,vdd,vss,interS2);
U7:   basic_and3 PORT MAP(addr_in(2),inv_addr_bit_1,addr_in(0),vdd,vss,interS3);
U8:   basic_and3 PORT MAP(addr_in(2),addr_in(1),inv_addr_bit_0,vdd,vss,interS4);

U9:   basic_and2 PORT MAP(interS1,interS2,vdd,vss,data_reg);  -- '0000 1100'
U10:   basic_and2 PORT MAP(interS1,interS3,vdd,vss,dir_reg);  -- '0000 1101'
U11:   basic_and2 PORT MAP(interS1,interS4,vdd,vss,read_reg); -- '0000 1110'
 
END port_b_regs_decoders;
------------------------------------------------------------------------------------------

  