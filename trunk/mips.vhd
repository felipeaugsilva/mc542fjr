library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mips is
    generic (nbits : positive := 32);
    port (Instruction : in  std_logic_vector(nbits -1 downto 0);
          Data        : in  std_logic_vector(nbits -1 downto 0);
          clk         : in  std_logic;
          reset       : in  std_logic;
          PCF         : out std_logic_vector(nbits -1 downto 0);
          ALUOutM     : out std_logic_vector(nbits -1 downto 0);
          WriteDataM  : out std_logic_vector(nbits -1 downto 0);
          MemWriteM   : out std_logic);
end mips;


architecture struct of mips is


    --component controller
    --   port (Op, Funct:   in  STD_LOGIC_VECTOR (5 downto 0);
    --          RegWriteD:   out STD_LOGIC;
    --          MemtoRegD:   out STD_LOGIC; 
    --          MemWriteD:   out STD_LOGIC;
    --          ALUControlD: out STD_LOGIC_VECTOR (2 downto 0);
    --          ALUSrcD:     out STD_LOGIC;
    --         RegDstD:     out STD_LOGIC;
    --          BranchD:     out STD_LOGIC;
    --          Jump:        out STD_LOGIC;
    --          Jal:         out STD_LOGIC);
    --end component;


    component datapath
        port (clk         : in  std_logic;
              reset       : in  std_logic;
              instr       : in  std_logic_vector(31 downto 0);
              Data        : in  std_logic_vector(31 downto 0);
              PCF         : out std_logic_vector(31 downto 0);
              ALUOutM     : out std_logic_vector(31 downto 0);
              WriteDataM  : out std_logic_vector(31 downto 0);
              MemWriteM   : out std_logic);
    end component;


    --signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc, zero: STD_LOGIC;
    --signal alucontrol: STD_LOGIC_VECTOR (2 downto 0);


begin

    --cont : controller  port map (Instruction (31 downto 26), Instruction(5 downto 0),
    --                              memtoreg, memwrite, pcsrc, alusrc, regdst,
    --                              regwrite, jump, alucontrol);
    dp : datapath port map (clk, reset, Instruction, Data, PCF, ALUOutM, WriteDataM, MemWriteM);


end struct;



