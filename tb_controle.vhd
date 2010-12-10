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

        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 15 ns;
        Instruction <= "100011" & "00000" & "00001" & "0000000000000000"; -- lw em r1

        wait for 10 ns;
        Instruction <= "100011" & "00000" & "00010" & "0000000000000000"; -- lw em r2

        wait for 10 ns;
        Instruction <= "100011" & "00000" & "00011" & "0000000000000000"; -- lw em r3

        wait for 10 ns;
        Data <= X"00000001"; -- load 1
        Instruction <= "100011" & "00000" & "00100" & "0000000000000000"; -- lw em r4

        wait for 10 ns;
        Data <= X"00000002"; -- load 2
        Instruction <= "100011" & "00000" & "00101" & "0000000000000000"; -- lw em r5

        wait for 10 ns;
        Data <= X"00000003"; -- load 3
        Instruction <= "100011" & "00000" & "00110" & "0000000000000000"; -- lw em r6

        wait for 10 ns;
        Data <= X"00000004"; -- load 4
        Instruction <= "100011" & "00000" & "00111" & "0000000000000000"; -- lw em r7

        wait for 10 ns;
        Data <= X"00000005"; -- load 5
        Instruction <= "100011" & "00000" & "01000" & "0000000000000000"; -- lw em r8

        wait for 10 ns;
        Data <= X"00000006"; -- load 6
        Instruction <= "100011" & "00000" & "01001" & "0000000000000000"; -- lw em r9

        wait for 10 ns;
        Data <= X"00000007"; -- load 7
        Instruction <= "100011" & "00000" & "01010" & "0000000000000000"; -- lw em r10

        wait for 10 ns;
        Data <= X"00000008"; -- load 8
        Instruction <= "000000" & "00001" & "00010" & "01011" & "00000" & "100000"; -- add r11, r1, r2

        wait for 10 ns;
        Data <= X"00000009"; -- load 9
        Instruction <= "000000" & "00011" & "00100" & "01100" & "00000" & "100010"; -- sub r12, r3, r4

        wait for 10 ns;
        Data <= X"0000000A"; -- load 10
        Instruction <= "001000" & "00101" & "01101" & "0000000000001000"; -- addi r13, r5, 8

        wait for 10 ns;
        Instruction <= "111010" & "00110" & "01110" & "1111111111111000"; -- subi r14, r6, -8

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01011" & "0000000000000000"; -- sw r11

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01100" & "0000000000000000"; -- sw r12

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01101" & "0000000000000000"; -- sw r13

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01110" & "0000000000000000"; -- sw r14
            assert WriteDataM = x"00000003" report "add failed."; --check add

        wait for 10 ns;
        Instruction <= "000000" & "00001" & "00010" & "01011" & "00000" & "100100"; -- and r11, r1, r2
            assert WriteDataM = x"FFFFFFFF" report "sub failed."; --check sub

        wait for 10 ns;
        Instruction <= "000000" & "00011" & "00100" & "01100" & "00000" & "100101"; -- or  r12, r3, r4
            assert WriteDataM = x"0000000D" report "addi failed."; --check addi

        wait for 10 ns;
        Instruction <= "000000" & "00101" & "00110" & "01101" & "00000" & "100110"; -- xor r13, r5, r6
            assert WriteDataM = x"0000000E" report "subi failed."; --check subi

        wait for 10 ns;
        Instruction <= "000000" & "00111" & "01000" & "01110" & "00000" & "101010"; -- slt r14, r7, r8

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01011" & "0000000000000000"; -- sw r11

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01100" & "0000000000000000"; -- sw r12

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01101" & "0000000000000000"; -- sw r13

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "01110" & "0000000000000000"; -- sw r14
            assert WriteDataM = x"00000000" report "and failed."; --check and

        wait for 10 ns;
        Instruction <= "100011" & "00000" & "01111" & "0000000000000000"; -- lw em r15
            assert WriteDataM = x"00000007" report "or failed."; --check or

        wait for 10 ns;
        Instruction <= "100011" & "00000" & "10000" & "0000000000000000"; -- lw em r16
            assert WriteDataM = x"00000003" report "xor failed."; --check xor

        wait for 10 ns;
        Instruction <= "100011" & "00000" & "10001" & "0000000000000000"; -- lw em r17
            assert WriteDataM = x"00000001" report "slt failed."; --check slt

        wait for 10 ns;
        Data <= X"0000000F"; -- load 15
        Instruction <= "100011" & "00000" & "10010" & "0000000000000000"; -- lw em r18

        wait for 10 ns;
        Data <= X"FFFFFFF0"; -- load 16
        Instruction <= "100011" & "00000" & "10011" & "0000000000000000"; -- lw em r19

        wait for 10 ns;
        Data <= X"0000000F"; -- load 17
        Instruction <= "100011" & "00000" & "10100" & "0000000000000000"; -- lw em r20

        --nop
        wait for 10 ns;
        Data <= X"00000010"; -- load 18
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 10 ns;
        Data <= X"00000000"; -- load 19
        Instruction <= "000000" & "01111" & "10000" & "10101" & "00000" & "100001"; -- addu r21, r15, r16

        wait for 10 ns;
        Data <= X"FFFFFFFF"; -- load 20
        Instruction <= "000000" & "10001" & "10010" & "10110" & "00000" & "100011"; -- subu r22, r17, r18

        wait for 10 ns;
        Instruction <= "000000" & "10011" & "10100" & "10111" & "00000" & "101011"; -- sltu r23, r19, r20

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "10101" & "0000000000000000"; -- sw r21

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "10110" & "0000000000000000"; -- sw r22

        wait for 10 ns;
        Instruction <= "101011" & "00000" & "10111" & "0000000000000000"; -- sw r23

        wait for 10 ns;
            assert WriteDataM = x"FFFFFFFF" report "addu failed."; --check addu

        wait for 10 ns;
            assert WriteDataM = x"FFFFFFFF" report "subu failed."; --check subu

        wait for 10 ns;
            assert WriteDataM = x"00000001" report "sltu failed."; --check sltu

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 10 ns;
        Instruction <= "000100" & "00001" & "00010" & "0000000000000000"; -- beq r1, r2, 0

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 20 ns;

        wait for 10 ns;
        Instruction <= "000100" & "00001" & "00001" & "0000000000000010"; -- beq r1, r1, 0

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 20 ns;

        Instruction <= "000010" & "00000000000000000000000000"; -- j 0

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        Instruction <= "000011" & "00000000000000000000100000"; -- jal 0

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait for 30 ns;
        Instruction <= "101011" & "00000" & "11111" & "0000000000000000"; -- sw r31

        --nop
        wait for 10 ns;
        Instruction <= "001000" & "00000" & "00000" & "0000000000000000"; -- addi r0, r0, 0

        wait;

    end process;

end behavior;


