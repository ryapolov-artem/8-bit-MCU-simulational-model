------------------------- Datapath unit -------------------------------
-- Scheme in book Hwang-Microprocessor design with VHDL
-- Chapter 9, page 239 / 341 in PDF file
-- 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
ENTITY datapath_unit IS
  PORT(in_word : IN STD_LOGIC_VECTOR(7 DOWNTO 0);           -- 8-bit word from Data bus
       out_word: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);           -- 8-bit word to Data bus
       clk_in,vdd,vss: IN STD_LOGIC;
       input_enable  : IN STD_LOGIC;
       write_A_enable: IN STD_LOGIC;
       read_A_enable : IN STD_LOGIC;
       read_B_enable : IN STD_LOGIC;
       alu_control   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       shifter_contr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       store_accumul : IN STD_LOGIC;
       output_enable : IN STD_LOGIC;
       RBAddr,RAAddr,WAAddr: IN STD_LOGIC_VECTOR(1 DOWNTO 0));
END datapath_unit;

ARCHITECTURE datapath_unit OF datapath_unit IS
  SIGNAL mux_regfile: STD_LOGIC_VECTOR(7 DOWNTO 0);         -- signal between Input multiplexer and Register file
  SIGNAL regfileA_aluA: STD_LOGIC_VECTOR(7 DOWNTO 0);       -- signal between Register file's out A and ALU's in A
  SIGNAL regfileB_aluB: STD_LOGIC_VECTOR(7 DOWNTO 0);       -- signal between Register file's out B and ALU's in B
  SIGNAL alu_shifter: STD_LOGIC_VECTOR(7 DOWNTO 0);         -- signal between ALU and Shifter/Rotator/Accumulator
  SIGNAL shifter_outbuffer: STD_LOGIC_VECTOR(7 DOWNTO 0);   -- signal between Shifter/Rotator and Output Tri-state buffer

  COMPONENT mux_8bit_2to1                                   -- Input Multiplexor
    PORT( word_a,word_b: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         in_select     : IN STD_LOGIC;
         vdd,vss       : IN STD_LOGIC;
         output_word   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT regiter_file_4on8_bit                           -- General Purpose Registers
    PORT(data_input     :   IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         vdd,vss        :   IN STD_LOGIC;
         wa_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         we_in          :   IN STD_LOGIC;
         ra_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         rae_in         :   IN STD_LOGIC;
         rb_in          :   IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         rbe_in         :   IN STD_LOGIC;
         port_a_out     :   INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         port_b_out     :   INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT alu_unit                                        -- ALU 
    PORT( a_word            : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          b_word            : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          operation_select  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          vdd,vss           : IN STD_LOGIC;
          out_word          : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          unsigned_overflow : INOUT STD_LOGIC;
          signed_overflow   : INOUT STD_LOGIC);
  END COMPONENT;
  
  COMPONENT shifter_rotator                                 -- Shifter/Rotator/Accumulator
    PORT( data_input       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          select_operation : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          clk_in,vdd,vss   : IN STD_LOGIC;
          q_out            : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT tri_state_buffer_8bit                           -- Output Tri-state buffer to Data bus
    PORT (data_input      :   IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          enable,vdd,vss  :   IN STD_LOGIC;
          data_output     :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;
  
BEGIN
-- Input Multiplexor
U1:     mux_8bit_2to1
            PORT MAP( shifter_outbuffer,in_word,input_enable,vdd,vss,mux_regfile);
-- General Purpose Registers          
U2:     regiter_file_4on8_bit
          PORT MAP(mux_regfile,vdd,vss,
               WAAddr,write_A_enable, RAAddr,read_A_enable, RBAddr,read_B_enable,
               regfileA_aluA, regfileB_aluB);
-- ALU 
U3:     alu_unit
          PORT MAP( regfileA_aluA, regfileB_aluB, alu_control,
                    vdd,vss, alu_shifter); -- unsigned_overflow, signed_overflow ARE UNUSED
                    
-- Shifter/Rotator/Accumulator
U4:     shifter_rotator                                
          PORT MAP( alu_shifter, shifter_contr, store_accumul,vdd,vss, shifter_outbuffer);
          
-- Output Tri-state buffer to Data bus
U5:     tri_state_buffer_8bit                           
          PORT MAP (shifter_outbuffer,output_enable,vdd,vss, out_word);
 
END datapath_unit;
------------------------------------------------------------------