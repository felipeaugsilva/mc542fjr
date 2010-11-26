library IEEE;
use IEEE.STD_LOGIC_1164.all;

Entity mips is
    generic (nbits : positive := 32);
    port (Instruction : in  std_logic_vector(nbits -1 downto 0);
          Data        : in  std_logic_vector(nbits -1 downto 0);
          clk         : in  std_logic;
          reset       : in  std_logic;
          PCF         : out std_logic_vector(nbits -1 downto 0);
          ALUOutM     : out std_logic_vector(nbits -1 downto 0);
          WriteDataM  : out std_logic_vector(nbits -1 downto 0);
          MemWriteM   : out std_logic);
End mips;

Architecture struct of mips is

	Component controller
    port( op, funct         : in  STD_LOGIC_VECTOR(5 downto 0);
          zero              : in  STD_LOGIC;
          memtoreg, memwrite: out STD_LOGIC;
          pcsrc, alusrc     : out STD_LOGIC;
          regdst, regwrite  : out STD_LOGIC;
          jump              : out STD_LOGIC;
          alucontrol        : out STD_LOGIC_VECTOR(2 downto 0));
	End component controller;

	Component datapath
    port( clk, reset        : in      STD_LOGIC;
          memtoreg, pcsrc   : in      STD_LOGIC;
          alusrc, regdst    : in      STD_LOGIC;
          regwrite, jump    : in      STD_LOGIC;
          alucontrol        : in      STD_LOGIC_VECTOR (2 downto 0);
          zero              : out     STD_LOGIC;
          pc                : buffer  STD_LOGIC_VECTOR (31 downto 0);
          instr             : in      STD_LOGIC_VECTOR (31 downto 0);
          aluout, writedata : buffer  STD_LOGIC_VECTOR (31 downto 0);
          readdata          : in      STD_LOGIC_VECTOR (31 downto 0));
	End component datapath;

	signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc, zero: STD_LOGIC;
	signal alucontrol: STD_LOGIC_VECTOR (2 downto 0);

begin
	cont  : controller  port map (instr (31 downto 26), instr(5 downto 0), zero,
                                  memtoreg, memwrite, pcsrc, alusrc, regdst,
                                  regwrite, jump, alucontrol);
	dp    : datapath    port map (clk, reset, memtoreg, pcsrc, alusrc, regdst,
                                  regwrite, jump, alucontrol, zero, pc, instr,
                                  aluout, writedata, readdata);
End struct;



