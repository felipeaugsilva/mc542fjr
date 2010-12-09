library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_datapath is
end tb_datapath;

architecture behavior of tb_datapath is

component datapath is
  port( clk, reset: in    STD_LOGIC;
        PCF:        inout STD_LOGIC_VECTOR(31 downto 0);  
        instr:      in    STD_LOGIC_VECTOR(31 downto 0); 
        Data:  in  STD_LOGIC_VECTOR(31 downto 0); 
        WriteDataM : out STD_LOGIC_VECTOR(31 downto 0); 
        MemWriteM:  out STD_LOGIC);
End component;


    signal clk                : STD_LOGIC := '0';
    signal reset              : STD_LOGIC := '1';    
    signal instr              : STD_LOGIC_VECTOR(31 downto 0);
    --signal saidaFlopD         : STD_LOGIC_VECTOR (115 downto 0);
    signal PCF                : STD_LOGIC_VECTOR(31 downto 0);  
    --signal WriteRegW          : STD_LOGIC_VECTOR(4 downto 0); 
    --signal ResultW            : STD_LOGIC_VECTOR(31 downto 0);
    --signal RegWriteW          : STD_LOGIC;
    signal Data:    STD_LOGIC_VECTOR(31 downto 0); 
    signal WriteDataM : STD_LOGIC_VECTOR(31 downto 0); 
    signal MemWriteM:   STD_LOGIC;
    --signal SaidaFlopM: STD_LOGIC_VECTOR(70 downto 0);

    
    begin

        datapath_0: datapath port map(clk, reset, PCF, instr, Data, WriteDataM, MemWriteM);

        process 
        begin
            for i in 0 to 100 loop
              clk <= '1'; wait for 50 ns;
              clk <= '0'; wait for 50 ns;
            end loop;
            wait;
        end process;

        process 
        begin
        --Seta valores aos registradores
            --wait for 100 ns;

            instr <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0

            wait for 100 ns;
            reset <= '0';

            --wait FOR 100 ns;
            --instr <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0
            --wait for 900 ns;

            instr <= "100011" & "00000" & "00010" & "0000000000010000";
            Data <= x"00000001";

            wait FOR 100 ns;
            instr <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi 0
            wait for 900 ns;

            instr <= "000011" & "00000000000000000000000001";
 
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
            
            wait;    
        end process;
    
end behavior;



