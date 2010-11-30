library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

Entity datapath is
  port( clk, reset: in    STD_LOGIC;
        --pcsrcD:     in    STD_LOGIC;     
        --pcbranchD:  in    STD_LOGIC_VECTOR(31 downto 0); 
        PCF:        inout STD_LOGIC_VECTOR(31 downto 0);  
        instr:      in    STD_LOGIC_VECTOR(31 downto 0); 
        --saidaFlopF: out   STD_LOGIC_VECTOR (63 downto 0));
        WriteRegW: in STD_LOGIC_VECTOR(4 downto 0);
        ResultW, RegWriteW: in    STD_LOGIC;
        AluOutM: in STD_LOGIC_VECTOR(31 downto 0); 
        SaidaFlopD: out STD_LOGIC_VECTOR(117 downto 0); 
End datapath;


Architecture struct of datapath is



    component adder generic (width: integer);
        port( a, b: in  STD_LOGIC_VECTOR (31 downto 0);
              y   : out STD_LOGIC_VECTOR (31 downto 0));
    end component adder;

    component flopr generic (width: integer);
        port( clk, reset: in  STD_LOGIC;
              d:          in  STD_LOGIC_VECTOR (width-1 downto 0);
              q:          out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    component mux2 generic (width: integer);
        port (d0, d1: in  STD_LOGIC_VECTOR (width-1 downto 0);
              s:      in  STD_LOGIC;
              y:      out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    component signimm 
        port( a: in  STD_LOGIC_VECTOR (15 downto 0);
              y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component equal generic (W: integer);
        port (a, b: in  STD_LOGIC_VECTOR(W-1 downto 0);
              y:    out STD_LOGIC_VECTOR);
    end component;

    component RF generic (W: natural);
        port (A1       : in std_logic_vector(4 downto 0);
              A2       : in std_logic_vector(4 downto 0);
              A3       : in std_logic_vector(4 downto 0);
              WD3      : in std_logic_vector(W-1 downto 0);
              clk      : in std_logic;
              We3      : in std_logic;
              RD1      : out std_logic_vector(W-1 downto 0);
              RD2      : out std_logic_vector(W-1 downto 0));
    end component;

    component sl2
        port (a: in  STD_LOGIC_VECTOR (31 downto 0);
              y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component controller
    port (Op, Funct:   in  STD_LOGIC_VECTOR (5 downto 0);
          RegWriteD:   out STD_LOGIC;
          MemtoRegD:   out STD_LOGIC; 
          MemWriteD:   out STD_LOGIC;
          ALUControlD: out STD_LOGIC_VECTOR (2 downto 0));
          ALUSrcD:     out STD_LOGIC;
          RegDstD:     out STD_LOGIC;
          BranchD:     out STD_LOGIC;
          Jump:        out STD_LOGIC);
    end component;

    signal pc, PCPlus4F: STD_LOGIC_VECTOR (31 downto 0);
    signal regFetch, saidaFlopF : STD_LOGIC_VECTOR (63 downto 0);
    signal PCBranchD:     STD_LOGIC_VECTOR(31 downto 0); 
    signal InstrD, PCPlus4D: STD_LOGIC_VECTOR(31 downto 0); 
    signal RD1, RD2, SignImmD:     STD_LOGIC_VECTOR(31 downto 0); 
    signal RtD, RdD: STD_LOGIC_VECTOR(4 downto 0); 
    signal shiftOut: STD_LOGIC_VECTOR(31 downto 0); 
    signal equalD: STD_LOGIC; 
    signal regDecode: STD_LOGIC_VECTOR(115 downto 0); 
    signal RegWriteD: STD_LOGIC;
    signal MemtoRegD:    STD_LOGIC; 
    signal MemWriteD:    STD_LOGIC;
    signal ALUControlD:  STD_LOGIC_VECTOR (2 downto 0));
    signal ALUSrcD:      STD_LOGIC;
    signal RegDstD:      STD_LOGIC;
    signal BranchD:      STD_LOGIC;
    signal Jump:         STD_LOGIC;
    signal PCSrcD:       STD_LOGIC;     



begin

-- Fetch -----------------------------------------------------------

    mux2F:   mux2  generic map (32) port map (PCPlus4F, PCBranchD, PCSrcD, pc);

    adderF:  adder generic map (32) port map (PCF, X"00000004", PCPlus4F);

    floprPC: flopr generic map (32) port map (clk, reset, pc, PCF);

    regFetch <= instr & PCPlus4F;

    floprF:  flopr generic map (64) port map (clk, reset, regFetch, saidaFlopF);

------------------------------------------------------------------------------------

    InstrD <= saidaFlopF(31 downto 0);
    PCPlus4D <= saidaFlopF(63 downto 32);

    rfD: rf generic map (32) port map (InstrD(25 downto 21), InstrD(20 downto 16), WriteRegW,
                                       ResultW, clk, We3, RD1, RD2).

    RtD <= InstrD(20 downto 16);
    RdD <= InstrD(15 downto 11);

    signExt: signimm port map (InstrD(15 downto 0), SignImmD);

    shift: sl2 port map (SignImmD, shiftOut);

    adderD:  adder generic map (32) port map (shiftOut, PCPlus4D, PCBranchD);

    equalD0:  equal generic map (32) port map (RD1, RD2, equalD);

    floprD:  flopr generic map (116) port map (clk, reset, regDecode, SaidaFlopD);

    contr: controller port map (InstrD(31 downto 26), InstrD(5 downto 0), RegWriteD, MemtoRegD, MemWriteD,
                                ALUControlD, ALUSrcD, RegDstD, BranchD, Jump);

    PCSrcD <= BranchD and equalD;

    regDecode <= RegWriteD & MemtoRegD & MemWriteD & ALUControlD & ALUSrcD & RegDstD & BranchD & Jump
                 & RD1 & RD2 & RtD & RdD & SignImmD;


end;








