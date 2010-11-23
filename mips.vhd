library ieee;
use ieee.std_logic_1164.all;


Entity mips is
  generic(
    nbits : positive := 32
  );
  port(
    Instruction : in  std_logic_vector(nbits -1 downto 0);
    Data        : in  std_logic_vector(nbits -1 downto 0);
    clk         : in  std_logic;
    reset       : in  std_logic;
    PCF         : out std_logic_vector(nbits -1 downto 0);
    ALUOutM     : out std_logic_vector(nbits -1 downto 0));
    WriteDataM  : out std_logic_vector(nbits -1 downto 0);
    MemWriteM   : out std_logic
  );
End mips;

Architecture Behaviour of mips is

  Component RF
    Generic(
      W : natural := 5
    );
    port(
      A1  : in  std_logic_vector(4 downto 0);
      A2  : in  std_logic_vector(4 downto 0);
      A3  : in  std_logic_vector(4 downto 0);
      WD3 : in  std_logic_vector(W-1 downto 0);
      clk : in  std_logic;
      We3 : in  std_logic;
      RD1 : out std_logic_vector(W-1 downto 0);
      RD2 : out std_logic_vector(W-1 downto 0)
    );
  End Component;

  constant W   : natural := 5;
  signal   A1  : std_logic_vector(4 downto 0);
  signal   A2  : std_logic_vector(4 downto 0);
  signal   A3  : std_logic_vector(4 downto 0);
  signal   WD3 : std_logic_vector(W-1 downto 0);
  signal   clk : std_logic;
  signal   We3 : std_logic;
  signal   RD1 : std_logic_vector(W-1 downto 0);
  signal   RD2 : std_logic_vector(W-1 downto 0);

  Component ALU
    Generic(
      W           : natural := 4
    );
    port(
      SrcA        : in  std_logic_vector(W-1 downto 0);
      SrcB        : in  std_logic_vector(W-1 downto 0);
      AluControl  : in  std_logic_vector(2 downto 0);
      AluResult   : out std_logic_vector(W-1 downto 0);
      Zero        : out std_logic;
      Overflow    : out std_logic;
      CarryOut    : out std_logic
    );
  End Component;

  constant W         : natural := 4;
  signal SrcA        : std_logic_vector(W-1 downto 0);
  signal SrcB        : std_logic_vector(W-1 downto 0);
  signal AluControl  : std_logic_vector(2 downto 0);
  signal AluResult   : std_logic_vector(W-1 downto 0);
  signal Zero        : std_logic;
  signal Overflow    : std_logic;
  signal CarryOut    : std_logic;

  Begin

    R: RF port map (A1, A2, A3, WD3, clk, We3, RD1, RD2);
    A: ALU port map (SrcA, SrcB, AluControl, AluResult, Zero, Overflow, CarryOut);

End Behaviour;