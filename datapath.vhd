library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

Entity datapath is
  port( clk, reset        : in      STD_LOGIC;
        memtoreg, pcsrc   : in      STD_LOGIC;
        alusrc, regdst    : in      STD_LOGIC;
        regwrite, jump    : in      STD_LOGIC;
        alucontrol        : in      STD_LOGIC_VECTOR(2 downto 0);
        zero              : out     STD_LOGIC;
        pc                : buffer  STD_LOGIC_VECTOR(31 downto 0);
        instr             : in      STD_LOGIC_VECTOR(31 downto 0);
        aluout, writedata : buffer  STD_LOGIC_VECTOR(31 downto 0);
        readdata          : in      STD_LOGIC_VECTOR(31 downto 0));
End datapath;

Architecture struct of datapath is

  Component ALU is
    Generic(W : natural = 32; Cw: natural 3);
    port( SrcA        : in  std_logic_vector(W-1 downto 0);
          SrcB        : in  std_logic_vector(W-1 downto 0);
          AluControl  : in  std_logic_vector(Cw-1 downto 0);
          AluResult   : out std_logic_vector(W-1 downto 0);
          Zero        : out std_logic;
          Overflow    : out std_logic
          CarryOut    : out std_logic);
  End Component ALU;

  Component RF is
    Generic(W : natural = 32);
    port( A1  : in  std_logic_vector(4 downto 0);
          A2  : in  std_logic_vector(4 downto 0);
          A3  : in  std_logic_vector(4 downto 0);
          WD3 : in  std_logic_vector(W-1 downto 0);
          clk : in  std_logic;
          We3 : in  std_logic;
          RD1 : out std_logic_vector(W-1 downto 0);
          RD2 : out std_logic_vector(W-1 downto 0));
  End Component RF;

  component adder
    port( a, b: in STD_LOGIC_VECTOR (31 downto 0);
          y   : out STD_LOGIC_VECTOR (31 downto 0));
  end component adder;

  component sl2
    port( a: in   STD_LOGIC_VECTOR (31 downto 0);
          y: out  STD_LOGIC_VECTOR (31 downto 0));
  end component sl2;

  component signext
    port( a: in   STD_LOGIC_VECTOR (15 downto 0);
          y: out  STD_LOGIC_VECTOR (31 downto 0));
  end component signext;

  component flopr generic (width: integer);
    port(
      clk, reset: in STD_LOGIC;
      d: in STD_LOGIC_VECTOR (width-1 downto 0);
      q: out STD_LOGIC_VECTOR (width-1 downto 0)
    );
  end component;

  component mux2 generic (width: integer);
    port(
      d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
      s: in STD_LOGIC;
      y: out STD_LOGIC_VECTOR (width-1 downto 0)
    );
  end component;

  signal writereg: STD_LOGIC_VECTOR (4 downto 0);
  signal pcjump, pcnext, pcnextbr,
  pcplus4, pcbranch: STD_LOGIC_VECTOR (31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR (31 downto 0);
  signal srca, srcb, result: STD_LOGIC_VECTOR (31 downto 0);

  begin

    --next PC logic
    pcjump  pcplus4 (31 downto 28) & instr (25 downto 0) & "00";
    pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
    pcadd1: adder port map(pc, X"00000004", pcplus4);
    immsh: sl2 port map(signimm, signimmsh);
    pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
    pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);
    pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);

    --register file logic
    rf: regfile port map(clk, regwrite, instr(25 downto 21),
    instr(20 downto 16), writereg, result, srca, writedata);
    wrmux: mux2 generic map(5) port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg);
    resmux: mux2 generic map(32) port map(aluout, readdata, memtoreg, result);
    se: signext port map(instr(15 downto 0), signimm);

    --ALU logic
    srcbmux: mux2 generic map (32) port map(writedata, signimm, alusrc, srcb);
    mainalu: alu port map(srca, srcb, alucontrol, aluout, zero);

end;
