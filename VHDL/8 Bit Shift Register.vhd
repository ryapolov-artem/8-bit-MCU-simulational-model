------------------------ 8 bit Shift Register  (4014 chip) -------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY shiftRegister IS
  PORT( serial_input : INOUT STD_LOGIC;
        paral_input: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clock,ps_control: IN STD_LOGIC;
        vdd,vss: INOUT STD_LOGIC;
        q_out: INOUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END shiftRegister;

ARCHITECTURE shiftRegister_arch OF shiftRegister IS
  SIGNAL q_interS: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL p_invertedS: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL d_inv0S: STD_LOGIC; -- serial data signal for first cell
  SIGNAL ps_interS: STD_LOGIC; --Paral/Serial contol signal after inverter
 
  COMPONENT inverter
    PORT(in_inv: IN STD_LOGIC; vdd,vss,out_inv: INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT shiftReg_cell
  PORT(d_inv_in,p_in: INOUT STD_LOGIC;
    clk_in,ps_switch: IN STD_LOGIC; 
    vdd,vss,q_inv_out: INOUT STD_LOGIC);
  END COMPONENT;
  
  BEGIN
--Inverts input signal
U0:    inverter PORT MAP(serial_input,vdd,vss,d_inv0S);
--Makes inverted P/S control signal
U1:    inverter PORT MAP(ps_control,vdd,vss,ps_interS);
--Generates 8 inverters that invert parallel input signal
Inverters: FOR i IN 0 TO 7 GENERATE
  U2to9: inverter PORT MAP(paral_input(i),vdd,vss,p_invertedS(i));
END GENERATE Inverters;
--Generates first shift reg cell
U10:  shiftReg_cell  PORT MAP(d_inv0S,p_invertedS(0),clock,
                        ps_interS,vdd,vss,q_interS(0));
--Generate other seven shift reg cells
ShiftRegCells: FOR i IN 1 TO 7 GENERATE
  U11to18: shiftReg_cell  PORT MAP(q_interS(i-1),p_invertedS(i),clock,
                        ps_interS,vdd,vss,q_interS(i));
END GENERATE ShiftRegCells;

U19:   inverter PORT MAP(q_interS(5),vdd,vss,q_out(0));
U20:   inverter PORT MAP(q_interS(6),vdd,vss,q_out(1));
U21:   inverter PORT MAP(q_interS(7),vdd,vss,q_out(2));

END shiftRegister_arch;
------------------------------------------------------------------
