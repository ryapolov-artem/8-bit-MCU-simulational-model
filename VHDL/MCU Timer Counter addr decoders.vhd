----------------------- Timer/Counter Address decoder ---------------------------- 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY timer_counter_addr_decoder IS
  PORT( addr_in        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        vdd,vss        : IN STD_LOGIC;
        timer_counter  : OUT STD_LOGIC;
        t_c_ctrl_reg   : OUT STD_LOGIC);
END timer_counter_addr_decoder;

ARCHITECTURE timer_counter_addr_decoder OF timer_counter_addr_decoder IS
  SIGNAL inv_addr_bit_7,inv_addr_bit_3,inv_addr_bit_2,inv_addr_bit_1,inv_addr_bit_0: STD_LOGIC;
  
  SIGNAL interS1,interS2,interS3: STD_LOGIC; 

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
U2:   inverter PORT MAP(addr_in(3),vdd,vss,inv_addr_bit_3);
U3:   inverter PORT MAP(addr_in(2),vdd,vss,inv_addr_bit_2);
U4:   inverter PORT MAP(addr_in(1),vdd,vss,inv_addr_bit_1);
U5:   inverter PORT MAP(addr_in(0),vdd,vss,inv_addr_bit_0);

U6:   basic_and3 PORT MAP(inv_addr_bit_7,addr_in(4),inv_addr_bit_3,vdd,vss,interS1);
U7:   basic_and3 PORT MAP(inv_addr_bit_2,inv_addr_bit_1,inv_addr_bit_0,vdd,vss,interS2);
U8:   basic_and3 PORT MAP(inv_addr_bit_2,inv_addr_bit_1,addr_in(0),vdd,vss,interS3);

U9:   basic_and2 PORT MAP(interS1,interS2,vdd,vss,timer_counter);
U10:  basic_and2 PORT MAP(interS1,interS3,vdd,vss,t_c_ctrl_reg);
 
END timer_counter_addr_decoder;
------------------------------------------------------------------------------------------