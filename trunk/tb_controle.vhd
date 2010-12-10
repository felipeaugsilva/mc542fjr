library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_controle is
end tb_controle;

architecture behavior of tb_controle is

    component mips
        generic (nbits : positive := 32);
        port (Instruction : in  std_logic_vector(nbits -1 downto 0);
              Data        : in  std_logic_vector(nbits -1 downto 0);
              clk         : in  std_logic;
              reset       : in  std_logic;
              PCF         : out std_logic_vector(nbits -1 downto 0);
              ALUOutM     : out std_logic_vector(nbits -1 downto 0);
              WriteDataM  : out std_logic_vector(nbits -1 downto 0);
              MemWriteM   : out std_logic);
    end component;


    signal Instruction : std_logic_vector(31 downto 0);
    signal Data        : std_logic_vector(31 downto 0);
    signal clk         : std_logic;
    signal reset       : std_logic;
    signal PCF         : std_logic_vector(31 downto 0);
    signal ALUOutM     : std_logic_vector(31 downto 0);
    signal WriteDataM  : std_logic_vector(31 downto 0);
    signal MemWriteM   : std_logic;


begin

    mips_0: mips port map(Instruction, Data, clk, reset, PCF, ALUOutM, WriteDataM, MemWriteM);

    process 
    begin
        for i in 0 to 100 loop
            clk <= '1'; wait for 5 ns;
            clk <= '0'; wait for 5 ns;
        end loop;
        wait;
    end process;

    process
    begin
        reset <= '1';
        wait for 5 ns;
        reset <= '0';
        wait;
    end process;

    process 
    begin

        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0

        wait;

    end process;

end behavior;


        --wait for 100 ns;
        --reset <= '0';

            --wait FOR 100 ns;
            --instr <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0
            --wait for 900 ns;

        --Instruction <= "100011" & "00000" & "00010" & "0000000000010000";
        --Data <= x"00000001";

        --wait for 100 ns;
        --Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0
        --wait for 900 ns;

        --instr <= "000011" & "00000000000000000000000001";
 
            --instr <= "000000" & "00001" & "00010" & "00011" & "00000" & "100000";
            --RegWriteW <= '1';
            --for i in 0 to 31 loop
            --  ResultW <= std_logic_vector(to_unsigned(i, 32));
            --  WriteRegW  <= std_logic_vector(to_unsigned(i, 5));
            --  wait for 100 ns;
            --end loop;
            --ResultW <= std_logic_vector(to_unsigned(3, 32));
            --WriteRegW  <= std_logic_vector(to_unsigned(4, 5));
            --RegWriteW <= '0';

            
    


            --instr <= "001000" & "00001" & "00011" & "0000000000000100"; -- addi
            --instr <= "100011" & "01000" & "01001" & "0000000000100000"; -- lw
                    --x"AD310004" after 100 ns, -- sw
            --wait for 100 ns;
            --instr <= "000100" & "00011" & "00011" & "0000000000100000"; -- beq com valores iguais
            --wait for 100 ns;

            --instr <= "000100" & "00011" & "00011" & "0000000000000000"; -- beq com valores iguais
            --wait for 100 ns;

            --instr <= "100011" & "01000" & "01001" & "0000000000100000";
            
        





