library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity datapath is
    port (clk         : in  std_logic;
          reset       : in  std_logic;
          instr       : in  std_logic_vector(31 downto 0);
          Data        : in  std_logic_vector(31 downto 0);
          PCF         : out std_logic_vector(31 downto 0);
          ALUOutM     : out std_logic_vector(31 downto 0);
          WriteDataM  : out std_logic_vector(31 downto 0);
          MemWriteM   : out std_logic);
end datapath;


architecture struct of datapath is

    component adder
        generic (width: integer);
        port (a, b: in  STD_LOGIC_VECTOR (31 downto 0);
              y   : out STD_LOGIC_VECTOR (31 downto 0));
    end component adder;


    component flopr
        generic (width: integer);
        port (clk, reset: in  STD_LOGIC;
              d:          in  STD_LOGIC_VECTOR (width-1 downto 0);
              q:          out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;


    component mux2
        generic (width: integer);
        port (d0, d1: in  STD_LOGIC_VECTOR (width-1 downto 0);
              s:      in  STD_LOGIC;
              y:      out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;


    component signimm 
        port (a: in  STD_LOGIC_VECTOR (15 downto 0);
              y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;


    component equal
        generic (W: integer);
        port (a, b: in  STD_LOGIC_VECTOR(W-1 downto 0);
              y:    out STD_LOGIC);
    end component;


    component RF
        generic (W: natural);
        port (A1  : in  std_logic_vector(4 downto 0);
              A2  : in  std_logic_vector(4 downto 0);
              A3  : in  std_logic_vector(4 downto 0);
              WD3 : in  std_logic_vector(W-1 downto 0);
              clk : in  std_logic;
              We3 : in  std_logic;
              RD1 : out std_logic_vector(W-1 downto 0);
              RD2 : out std_logic_vector(W-1 downto 0));
    end component;


    component sl2
        generic (W: integer);
        port (a: in  STD_LOGIC_VECTOR (W-1 downto 0);
              y: out STD_LOGIC_VECTOR (W-1 downto 0));
    end component;


    component ALU
        generic (W : natural := 32);
        port (SrcA      : in  std_logic_vector(W-1  downto 0);
              SrcB      : in  std_logic_vector(W-1  downto 0);
              AluControl: in  std_logic_vector(3 downto 0);
              AluResult : out std_logic_vector(W-1  downto 0);
              Zero      : out std_logic;
              Overflow  : out std_logic;
              CarryOut  : out std_logic);
    end component;


    component controller
        port (Op, Funct:   in  STD_LOGIC_VECTOR (5 downto 0);
              RegWriteD:   out STD_LOGIC;
              MemtoRegD:   out STD_LOGIC; 
              MemWriteD:   out STD_LOGIC;
              ALUControlD: out STD_LOGIC_VECTOR (3 downto 0);
              ALUSrcD:     out STD_LOGIC;
              RegDstD:     out STD_LOGIC;
              BranchD:     out STD_LOGIC;
              Jump:        out STD_LOGIC;
              Jal:         out STD_LOGIC);
    end component;


    signal PC, PCPlus4F, sigPCF    : STD_LOGIC_VECTOR (31  downto 0);
    signal PCBranchD, PCPlus4D     : STD_LOGIC_VECTOR (31  downto 0);
    signal PCPlus4E, PCPlus4M      : STD_LOGIC_VECTOR (31  downto 0);
    signal PCPlus4W                : STD_LOGIC_VECTOR (31  downto 0);
    signal InstrD                  : STD_LOGIC_VECTOR (31  downto 0); 
    signal regFetch, saidaFlopF    : STD_LOGIC_VECTOR (63  downto 0);
    signal regDecode, SaidaFlopD   : STD_LOGIC_VECTOR (148 downto 0); 
    signal regExecute, SaidaFlopE  : STD_LOGIC_VECTOR (104 downto 0); 
    signal regMemory, SaidaFlopM   : STD_LOGIC_VECTOR (103 downto 0);
    signal SrcAE, SrcBE, SrcB      : STD_LOGIC_VECTOR (31  downto 0);
    signal RD1, RD2                : STD_LOGIC_VECTOR (31  downto 0);
    signal shiftOut                : STD_LOGIC_VECTOR (31  downto 0);
    signal WriteDataE              : STD_LOGIC_VECTOR (31  downto 0);
    signal SignImmD, SignImmE      : STD_LOGIC_VECTOR (31  downto 0);
    signal AluResult, ALUOutW      : STD_LOGIC_VECTOR (31  downto 0); 
    signal ReadDataW, ResultW      : STD_LOGIC_VECTOR (31  downto 0);
    signal PCX, PCJumpFinal        : STD_LOGIC_VECTOR (31  downto 0);
    signal ResultWAux              : STD_LOGIC_VECTOR (31  downto 0);
    signal PCJump, shiftj          : STD_LOGIC_VECTOR (27  downto 0);
    signal RtD, RdD, RtE, RdE      : STD_LOGIC_VECTOR (4   downto 0); 
    signal WriteRegE, WriteRegM    : STD_LOGIC_VECTOR (4   downto 0);
    signal WriteRegW, WriteRegWAux : STD_LOGIC_VECTOR (4   downto 0); 
    signal ALUControlD, ALUControlE: STD_LOGIC_VECTOR (3   downto 0);
    signal equalD, BranchD, PCSrcD : STD_LOGIC; 
    signal RegWriteD, RegWriteE    : STD_LOGIC;
    signal RegWriteM, RegWriteW    : STD_LOGIC;
    signal MemtoRegD, MemtoRegE    : STD_LOGIC; 
    signal MemtoRegM, MemtoRegW    : STD_LOGIC;
    signal MemWriteD, MemWriteE    : STD_LOGIC;
    signal ALUSrcD, ALUSrcE        : STD_LOGIC;
    signal RegDstD, RegDstE        : STD_LOGIC;
    signal Jump                    : STD_LOGIC;

    signal JalD, JalE, JalM, JalW  : STD_LOGIC;

    --signal resetFloprF  : STD_LOGIC;


begin

-- Fetch -------------------------------------------------------------------------

    mux2F1:   mux2 generic map (32) port map (PCPlus4F, PCBranchD, PCSrcD, PCX);

    mux2F2:   mux2 generic map (32) port map (PCX, PCJumpFinal, Jump, PC);
    
    ShiftJump: sl2 generic map (28) port map ( shiftj, PCJump);

    adderF:  adder generic map (32) port map (sigPCF, X"00000004", PCPlus4F);

    floprPC: flopr generic map (32) port map (clk, reset, PC, sigPCF);

    floprF:  flopr generic map (64) port map (clk, reset, regFetch, saidaFlopF);


    PCJumpFinal <= PCPlus4F(31 downto 28) & PCJump;

    shiftj <= "00" & InstrD(25 downto 0);

    PCF <= sigPCF;

    regFetch <= instr & PCPlus4F;

    --stall
    --resetFloprF <= reset or PCSrcD; --or Jump;


-- Decode -------------------------------------------------------------------------


    rfD:     rf   generic map (32) port map (InstrD(25 downto 21), InstrD(20 downto 16), WriteRegW,
                                             ResultW, clk, RegWriteW, RD1, RD2);

    signExt: signimm port map (InstrD(15 downto 0), SignImmD);

    shift:   sl2   generic map (32)  port map (SignImmD, shiftOut);

    adderD:  adder generic map (32)  port map (shiftOut, PCPlus4D, PCBranchD);

    equalD0: equal generic map (32)  port map (RD1, RD2, equalD);

    floprD:  flopr generic map (149) port map (clk, reset, regDecode, SaidaFlopD);

    contr:   controller port map (InstrD(31 downto 26), InstrD(5 downto 0), RegWriteD, MemtoRegD, MemWriteD,
                                  ALUControlD, ALUSrcD, RegDstD, BranchD, Jump, JalD);

    InstrD   <= saidaFlopF(63 downto 32);
    PCPlus4D <= saidaFlopF(31 downto 0);

    RtD <= InstrD(20 downto 16);
    RdD <= InstrD(15 downto 11);

    PCSrcD <= BranchD and equalD;

    regDecode <= JalD & PCPlus4D & RegWriteD & MemtoRegD & MemWriteD & ALUControlD & ALUSrcD & RegDstD & BranchD
                 & RD1 & RD2 & RtD & RdD & SignImmD;


-- Execute -------------------------------------------------------------------------

    mux2E1: mux2  generic map (5) port map (RtE, RdE, RegDstE, WriteRegE);

    mux2E2: mux2  generic map (32) port map (SrcB, SignImmE, ALUSrcE, SrcBE);

    ALUE:   ALU port map (SrcAE, SrcBE, ALUControlE, AluResult);

    floprE: flopr generic map (105) port map (clk, reset, regExecute, SaidaFlopE);

    JalE        <= SaidaFlopD(148);
    PCPlus4E    <= SaidaFlopD(147 downto 116);
    regWriteE   <= SaidaFlopD(115);
    MemtoRegE   <= SaidaFlopD(114);
    MemWriteE   <= SaidaFlopD(113);
    ALUControlE <= SaidaFlopD(112 downto 109);
    ALUSrcE     <= SaidaFlopD(108);
    RegDstE     <= SaidaFlopD(107);
    SrcAE       <= SaidaFlopD(105 downto 74);
    SrcB        <= SaidaFlopD(73 downto 42);
    RtE         <= SaidaFlopD(41 downto 37);
    RdE         <= SaidaFlopD(36 downto 32);
    SignImmE    <= SaidaFlopD(31 downto 0);
    WriteDataE  <= SrcB;

    regExecute <= JalE & PCPlus4E & regWriteE & MemtoRegE & MemWriteE & AluResult & WriteDataE & WriteRegE;


-- Memory -------------------------------------------------------------------------

    floprM:  flopr generic map (104) port map (clk, reset, regMemory, SaidaFlopM);

    JalM       <= SaidaFlopE(104);
    PCPlus4M   <= SaidaFlopE(103 downto 72);
    RegWriteM  <= SaidaFlopE(71);
    MemtoRegM  <= SaidaFlopE(70);
    MemWriteM  <= SaidaFlopE(69);
    ALUOutM    <= SaidaFlopE(68 downto 37);
    WriteDataM <= SaidaFlopE(36 downto 5);
    WriteRegM  <= SaidaFlopE(4  downto 0);

    regMemory  <= JalM & PCPlus4M & RegWriteM & MemtoRegM & Data & SaidaFlopE(68 downto 37) & WriteRegM;


-- Writeback -------------------------------------------------------------------------

    mux2W1:   mux2  generic map (32) port map (ALUOutW, ReadDataW, MemtoRegW, ResultWAux);

    mux2W2:   mux2  generic map (32) port map (ResultWAux, PCPlus4W, JalW, ResultW);

    mux2W3:   mux2  generic map (5) port map (WriteRegWAux, "11111", JalW, WriteRegW);

    JalW         <= SaidaFlopM(103);
    PCPlus4W     <= SaidaFlopM(102 downto 71);
    RegWriteW    <= SaidaFlopM(70);
    MemtoRegW    <= SaidaFlopM(69);
    ReadDataW    <= SaidaFlopM(68 downto 37);
    ALUOutW      <= SaidaFlopM(36 downto 5);
    WriteRegWAux <= SaidaFlopM(4  downto 0);


end;

