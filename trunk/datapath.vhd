library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

Entity datapath is
  port (clk, reset: in    STD_LOGIC;
        PCF:        inout STD_LOGIC_VECTOR(31 downto 0);  
        instr:      in    STD_LOGIC_VECTOR(31 downto 0); 
        WriteRegW: in     STD_LOGIC_VECTOR(4 downto 0);
        ResultW :  in     STD_LOGIC_VECTOR(31 downto 0); 
        RegWriteW: in     STD_LOGIC;
        --AluOutM: in STD_LOGIC_VECTOR(31 downto 0); 
        --SaidaFlopD: out STD_LOGIC_VECTOR(115 downto 0)); 
        SaidaFlopE: out STD_LOGIC_VECTOR(71 downto 0)); 
End datapath;


Architecture struct of datapath is



    component adder generic (width: integer);
        port (a, b: in  STD_LOGIC_VECTOR (31 downto 0);
              y   : out STD_LOGIC_VECTOR (31 downto 0));
    end component adder;

    component flopr generic (width: integer);
        port (clk, reset: in  STD_LOGIC;
              d:          in  STD_LOGIC_VECTOR (width-1 downto 0);
              q:          out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    component mux2 generic (width: integer);
        port (d0, d1: in  STD_LOGIC_VECTOR (width-1 downto 0);
              s:      in  STD_LOGIC;
              y:      out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    component signimm 
        port (a: in  STD_LOGIC_VECTOR (15 downto 0);
              y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component equal generic (W: integer);
        port (a, b: in  STD_LOGIC_VECTOR(W-1 downto 0);
              y:    out STD_LOGIC);
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
          ALUControlD: out STD_LOGIC_VECTOR (2 downto 0);
          ALUSrcD:     out STD_LOGIC;
          RegDstD:     out STD_LOGIC;
          BranchD:     out STD_LOGIC;
          Jump:        out STD_LOGIC);
    end component;

    component ALU
    generic(W : natural := 32;
            Cw: natural := 3);
    port(SrcA      : in  std_logic_vector(W-1  downto 0);
         SrcB      : in  std_logic_vector(W-1  downto 0);
         AluControl: in  std_logic_vector(2 downto 0);
         AluResult : out std_logic_vector(W-1  downto 0);
         Zero      : out std_logic;
         Overflow  : out std_logic;
         CarryOut  : out std_logic);
    end component;

    signal PC, PCPlus4F: STD_LOGIC_VECTOR (31 downto 0);
    signal regFetch, saidaFlopF : STD_LOGIC_VECTOR (63 downto 0);
    signal PCBranchD:     STD_LOGIC_VECTOR(31 downto 0); 
    signal InstrD, PCPlus4D: STD_LOGIC_VECTOR(31 downto 0); 
    signal RD1, RD2, SignImmD:     STD_LOGIC_VECTOR(31 downto 0); 
    signal RtD, RdD, RtE, RdE: STD_LOGIC_VECTOR(4 downto 0); 
    signal shiftOut: STD_LOGIC_VECTOR(31 downto 0); 
    signal equalD: STD_LOGIC; 
    signal regDecode: STD_LOGIC_VECTOR(114 downto 0); 
    signal RegWriteD: STD_LOGIC;
    signal MemtoRegD:    STD_LOGIC; 
    signal MemWriteD:    STD_LOGIC;
    signal ALUControlD:  STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrcD:      STD_LOGIC;
    signal RegDstD:      STD_LOGIC;
    signal BranchD:      STD_LOGIC;
    signal Jump:         STD_LOGIC;
    signal PCSrcD:       STD_LOGIC;     
    signal SaidaFlopD:  STD_LOGIC_VECTOR(114 downto 0);
    signal RegWriteE: STD_LOGIC;
    signal MemtoRegE:    STD_LOGIC; 
    signal MemWriteE:    STD_LOGIC;
    signal ALUControlE:  STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrcE:      STD_LOGIC;
    signal RegDstE:      STD_LOGIC;
    signal SrcAE, SrcBE, SrcB:  STD_LOGIC_VECTOR(31 downto 0); 
    signal WriteDataE:  STD_LOGIC_VECTOR(31 downto 0); 
    signal WriteRegE : STD_LOGIC_VECTOR(4 downto 0); 
    signal SignImmE: STD_LOGIC_VECTOR(31 downto 0); 
    signal AluResult: STD_LOGIC_VECTOR(31 downto 0); 
    signal regExecute: STD_LOGIC_VECTOR(71 downto 0); 



begin

-- Fetch -------------------------------------------------------------------------

    mux2F:   mux2  generic map (32) port map (PCPlus4F, PCBranchD, PCSrcD, PC);

    adderF:  adder generic map (32) port map (PCF, X"00000004", PCPlus4F);

    floprPC: flopr generic map (32) port map (clk, reset, PC, PCF);

    regFetch <= instr & PCPlus4F;

    floprF:  flopr generic map (64) port map (clk, reset, regFetch, saidaFlopF);

-- Decode -------------------------------------------------------------------------

    InstrD <= saidaFlopF(63 downto 32);
    PCPlus4D <= saidaFlopF(31 downto 0);

    rfD: rf generic map (32) port map (InstrD(25 downto 21), InstrD(20 downto 16), WriteRegW,
                                       ResultW, clk, RegWriteW, RD1, RD2);

    RtD <= InstrD(20 downto 16);
    RdD <= InstrD(15 downto 11);

    signExt: signimm port map (InstrD(15 downto 0), SignImmD);

    shift: sl2 port map (SignImmD, shiftOut);

    adderD:  adder generic map (32) port map (shiftOut, PCPlus4D, PCBranchD);

    equalD0:  equal generic map (32) port map (RD1, RD2, equalD);

    floprD:  flopr generic map (115) port map (clk, reset, regDecode, SaidaFlopD);

    contr: controller port map (InstrD(31 downto 26), InstrD(5 downto 0), RegWriteD, MemtoRegD, MemWriteD,
                                ALUControlD, ALUSrcD, RegDstD, BranchD, Jump);

    PCSrcD <= BranchD and equalD;

    regDecode <= RegWriteD & MemtoRegD & MemWriteD & ALUControlD & ALUSrcD & RegDstD & BranchD
                 & RD1 & RD2 & RtD & RdD & SignImmD;

-- Execute -------------------------------------------------------------------------

    mux2E1:   mux2  generic map (5) port map (RtE, RdE, RegDstE, WriteRegE);

    mux2E2:   mux2  generic map (32) port map (SrcB, SignImmE, ALUSrcE, SrcBE);

    ALUE: ALU port map (SrcAE, SrcBE, ALUControlE, AluResult);

    floprE:  flopr generic map (72) port map (clk, reset, regExecute, SaidaFlopE);

    regWriteE <= SaidaFlopD(114);
    MemtoRegE <= SaidaFlopD(113);
    MemWriteE <= SaidaFlopD(112);
    ALUControlE <= SaidaFlopD(111 downto 109);
    ALUSrcE <= SaidaFlopD(108);
    RegDstE <= SaidaFlopD(107);
    SrcAE <= SaidaFlopD(105 downto 74);
    SrcB <= SaidaFlopD(73 downto 42);
    RtE <= SaidaFlopD(41 downto 37);
    RdE <= SaidaFlopD(36 downto 32);
    SignImmE <= SaidaFlopD(31 downto 0);
    WriteDataE <= SrcB;

    regExecute <= regWriteE & MemtoRegE & MemWriteE & AluResult & WriteDataE & WriteRegE;

    


-- Memory -------------------------------------------------------------------------

end;








