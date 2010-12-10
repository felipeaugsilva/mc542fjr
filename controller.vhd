library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controller is -- control decoder
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
end;

architecture struct of controller is

    component maindec
    port (op:                 in  STD_LOGIC_VECTOR (5 downto 0);
          memtoreg, memwrite: out STD_LOGIC;
          branch, alusrc:     out STD_LOGIC;
          regdst, regwrite:   out STD_LOGIC;
          jump:               out STD_LOGIC;
          aluop:              out STD_LOGIC_VECTOR (1 downto 0);
          Jal:                out STD_LOGIC);
    end component;

    component aludec
        port (funct:      in  STD_LOGIC_VECTOR (5 downto 0);
              aluop:      in  STD_LOGIC_VECTOR (1 downto 0);
              alucontrol: out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal ALUOp: STD_LOGIC_VECTOR (1 downto 0);

begin

    md: maindec port map (Op, MemtoRegD, MemWriteD, BranchD, ALUSrcD, RegDstD, RegWriteD, Jump, ALUOp, Jal);
    ad: aludec  port map (Funct, ALUOp, ALUControlD);

end;



