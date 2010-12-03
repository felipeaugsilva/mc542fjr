library ieee;
use ieee.std_logic_1164.all;

entity tb_datapath is
end tb_datapath;

architecture behavior of tb_datapath is

component datapath is
  port( clk, reset        : in      STD_LOGIC;
        pcsrcD: in      STD_LOGIC;   
        pcbranchD   : in      STD_LOGIC_VECTOR(31 downto 0); 
        PCF           : inout      STD_LOGIC_VECTOR(31 downto 0);  
        instr  : in      STD_LOGIC_VECTOR(31 downto 0); 
        saidaFlopF : out STD_LOGIC_VECTOR (63 downto 0));
End component;


    signal clk               : STD_LOGIC := '0';
    signal reset               : STD_LOGIC := '1';
    signal pcsrcD : STD_LOGIC;
    signal pcbranchD  : STD_LOGIC_VECTOR(31 downto 0);
    signal instr             : STD_LOGIC_VECTOR(31 downto 0);
    signal saidaFlopF: STD_LOGIC_VECTOR (63 downto 0);
    signal  PCF           :       STD_LOGIC_VECTOR(31 downto 0);  

    signal erro: boolean := false;  -- Para terminar a simulacao
    
    begin

        datapath_0: datapath port map(clk, reset, pcsrcD, pcbranchD, PCF,
                                      instr, saidaFlopF);
        -- Clock
        clk <= not clk after 50 ns;

        reset <= '0' after 10 ns;

        pcsrcD <= '0', '1' after 200 ns;


        instr <= X"AAAAAAAA", X"FFFFFFFF" after 100 ns;

        

        process
        begin
            wait for 900 ns;
            erro <= true;   -- Termina simulacao
        end process;
        
    assert not erro report "Fim da Simulacao" severity failure;
    
end behavior;



