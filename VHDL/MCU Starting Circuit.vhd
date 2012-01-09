----------------------- Starting circuit --------------------------------
--                            Moore FSM
-- Starts with reset (0->1), then sets following signals
-- 1st clk period: PC - count=0,load=0,clear=0; IR - load=0,clear=0; Program memory read=0
-- 2nd clk period: PC - clear=1; IR - load=1,clear=1; Program memory read=1;
-- 3rd clk period: Hand over control to uCommand unit: IR - load; PC - count,load; Program memory read.
--    A   B   C
--   (2) (1) (0)
--1st 0   0   0
--2nd 0   1   0
--3rd 0   1   0
--4th 1   1   0

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY starting_circuit IS
  PORT(clk_in         : IN STD_LOGIC;
       reset          : IN STD_LOGIC; -- active level 0
       vdd,vss        : IN STD_LOGIC;
       abc_out        : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END starting_circuit;

ARCHITECTURE starting_circuit OF  starting_circuit IS
  SIGNAL interS1,interS2,interS3,interS4,interS5,interS6,
        interS7,interS8,interS9,interS10,interS11: STD_LOGIC;

  COMPONENT basic_and2
    PORT(in_1,in_2,vdd,vss: IN STD_LOGIC; out12: OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT inverter
    PORT(in_inv,vdd,vss: IN STD_LOGIC; out_inv: OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT d_trigger_res
    PORT(d_in: IN STD_LOGIC; clk_in,reset,vdd,vss: IN STD_LOGIC;
       q_out,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT basic_or3
    PORT(in_1,in_2,in_3: IN STD_LOGIC;
                vdd,vss: IN STD_LOGIC;
                  out13: OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT basic_or2
    PORT(in_1,in_2: IN STD_LOGIC;
           vdd,vss: IN STD_LOGIC;
             out12: OUT STD_LOGIC);
  END COMPONENT;

  BEGIN
U1:     inverter PORT MAP(vdd,vdd,vss,abc_out(0));              --C
U2:     d_trigger_res PORT MAP(interS5,clk_in,reset,vdd,vss,interS1);         --Q1
U3:     d_trigger_res PORT MAP(interS9,clk_in,reset,vdd,vss,interS2,interS3); --Q0,invert.Q0

U4:     basic_and2 PORT MAP(interS2,vdd,vdd,vss,interS4);
U5:     basic_and2 PORT MAP(interS2,abc_out(0),vdd,vss,interS6);
U6:     basic_and2 PORT MAP(interS3,vdd,vdd,vss,interS7);
U7:     basic_and2 PORT MAP(interS1,interS2,vdd,vss,abc_out(2));  --A

U8:     basic_or2 PORT MAP(interS1,interS4,vdd,vss,interS5);
U9:     basic_or3 PORT MAP(interS6,interS7,abc_out(2),vdd,vss,interS9);

U10:    basic_or2 PORT MAP(interS1,interS2,vdd,vss,abc_out(1));  --B

END  starting_circuit;
------------------------------------------------------------------