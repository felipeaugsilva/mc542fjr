library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

Entity datapath is
  port( clk, reset: in    STD_LOGIC;
        pcsrcD:     in    STD_LOGIC;     
        pcbranchD:  in    STD_LOGIC_VECTOR(31 downto 0); 
        PCF:        inout STD_LOGIC_VECTOR(31 downto 0);  
        instr:      in    STD_LOGIC_VECTOR(31 downto 0); 
        saidaFlopF: out   STD_LOGIC_VECTOR (63 downto 0));
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

    signal pc, PCPlus4F: STD_LOGIC_VECTOR (31 downto 0);
    signal temp : STD_LOGIC_VECTOR (63 downto 0);


begin

    mux2F:   mux2  generic map (32) port map (PCPlus4F, pcbranchD, pcsrcD, pc);

    adderF:  adder generic map (32) port map (PCF, X"00000004", PCPlus4F);

    floprPC: flopr generic map (32) port map (clk, reset, pc, PCF);

    temp <= instr & PCPlus4F;

    floprF:  flopr generic map (64) port map (clk, reset, temp, saidaFlopF);

end;




