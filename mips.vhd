-- MC542 - Projeto: MIPS pipelined      Data: 10/12/2010

-- Jesse de Moura Tavano Moretto  RA: 081704
-- Felipe Augusto da Silva        RA: 096993
-- Rodrigo Augusto Folegatti      RA: 097085


library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mips is
    generic (nbits : positive := 32);
    port (Instruction : in  std_logic_vector(nbits -1 downto 0);
          Data        : in  std_logic_vector(nbits -1 downto 0);
          clk         : in  std_logic;
          reset       : in  std_logic;
          PCF         : out std_logic_vector(nbits -1 downto 0);
          ALUOutM     : out std_logic_vector(nbits -1 downto 0);
          WriteDataM  : out std_logic_vector(nbits -1 downto 0);
          MemWriteM   : out std_logic);
end mips;


architecture struct of mips is


    component datapath
        port (clk         : in  std_logic;
              reset       : in  std_logic;
              instr       : in  std_logic_vector(31 downto 0);
              Data        : in  std_logic_vector(31 downto 0);
              PCF         : out std_logic_vector(31 downto 0);
              ALUOutM     : out std_logic_vector(31 downto 0);
              WriteDataM  : out std_logic_vector(31 downto 0);
              MemWriteM   : out std_logic);
    end component;


begin

    dp : datapath port map (clk, reset, Instruction, Data, PCF, ALUOutM, WriteDataM, MemWriteM);

end struct;



