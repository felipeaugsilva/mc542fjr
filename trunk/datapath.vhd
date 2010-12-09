library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

Entity datapath is
  port (clk, reset: in    STD_LOGIC;
        PCF:        inout STD_LOGIC_VECTOR(31 downto 0);  
        instr:      in    STD_LOGIC_VECTOR(31 downto 0); 
        Data:  in  STD_LOGIC_VECTOR(31 downto 0); 
        WriteDataM : out STD_LOGIC_VECTOR(31 downto 0); 
        MemWriteM:  out STD_LOGIC);
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
          generic (W: integer);
          port (a: in  STD_LOGIC_VECTOR (W-1 downto 0);
          y: out STD_LOGIC_VECTOR (W-1 downto 0));
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
    signal SaidaFlopE:  STD_LOGIC_VECTOR(71 downto 0);
    signal regMemory:  STD_LOGIC_VECTOR(70 downto 0);
    signal RegWriteM: STD_LOGIC;
    signal MemtoRegM:  STD_LOGIC;
    signal ALUOutM: STD_LOGIC_VECTOR(31 downto 0); 
    signal WriteRegM: STD_LOGIC_VECTOR(4 downto 0); 
    signal RegWriteW:STD_LOGIC;
    signal MemtoRegW:STD_LOGIC;
    signal ReadDataW:STD_LOGIC_VECTOR(31 downto 0); 
    signal ALUOutW:STD_LOGIC_VECTOR(31 downto 0); 
    signal WriteRegW: STD_LOGIC_VECTOR(4 downto 0); 
    signal SaidaFlopM: STD_LOGIC_VECTOR(70 downto 0);
    signal ResultW: STD_LOGIC_VECTOR(31 downto 0);
    --Jump
    signal Jump         : STD_LOGIC;
    signal PCX          : STD_LOGIC_VECTOR(31 downto 0);
    signal PCJump       : STD_LOGIC_VECTOR(27 downto 0);
    signal PCJumpFinal  : STD_LOGIC_VECTOR(31 downto 0);
    --concatena o shift
    signal shiftj        : STD_LOGIC_VECTOR(27 downto 0);

    signal resetFloprF  :STD_LOGIC;


begin

-- Fetch -------------------------------------------------------------------------

    mux2F1:   mux2  generic map (32) port map (PCPlus4F, PCBranchD, PCSrcD, PCX);

    --Jump
    PCJumpFinal <= PCPlus4F(31 downto 28) & PCJump;
    mux2F2:   mux2  generic map (32) port map (PCX, PCJumpFinal, Jump, PC);
    --Jump
    shiftj <= "00" & InstrD(25 downto 0);
    ShiftJump: sl2 generic map (28) port map ( shiftj, PCJump);

    adderF:  adder generic map (32) port map (PCF, X"00000004", PCPlus4F);

    floprPC: flopr generic map (32) port map (clk, reset, PC, PCF);

    regFetch <= instr & PCPlus4F;

    floprF:  flopr generic map (64) port map (clk, resetFloprF, regFetch, saidaFlopF);

    --stall
    resetFloprF <= reset or PCSrcD; --or Jump;

-- Decode -------------------------------------------------------------------------

    InstrD <= saidaFlopF(63 downto 32);
    PCPlus4D <= saidaFlopF(31 downto 0);

    rfD: rf generic map (32) port map (InstrD(25 downto 21), InstrD(20 downto 16), WriteRegW,
                                       ResultW, clk, RegWriteW, RD1, RD2);

    RtD <= InstrD(20 downto 16);
    RdD <= InstrD(15 downto 11);

    signExt: signimm port map (InstrD(15 downto 0), SignImmD);

    shift: sl2 generic map (32) port map (SignImmD, shiftOut);

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

    floprM:  flopr generic map (71) port map (clk, reset, regMemory, SaidaFlopM);

    RegWriteM <= SaidaFlopE(71);
    MemtoRegM <= SaidaFlopE(70);
    MemWriteM <= SaidaFlopE(69);
    ALUOutM <= SaidaFlopE(68 downto 37);
    WriteDataM <= SaidaFlopE(36 downto 5);
    WriteRegM <= SaidaFlopE(4 downto 0);

    regMemory <= RegWriteM & MemtoRegM & Data & ALUOutM & WriteRegM;

-- Writeback -------------------------------------------------------------------------

    mux2W:   mux2  generic map (32) port map (ALUOutW, ReadDataW, MemtoRegW, ResultW);

    RegWriteW <= SaidaFlopM(70);
    MemtoRegW <= SaidaFlopM(69);
    ReadDataW <= SaidaFlopM(68 downto 37);
    ALUOutW <= SaidaFlopM(36 downto 5);
    WriteRegW <= SaidaFlopM(4 downto 0);


end;








