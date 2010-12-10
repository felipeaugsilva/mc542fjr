library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
    generic(W: natural);
    port (A1 : in std_logic_vector(4 downto 0);
          A2 : in std_logic_vector(4 downto 0);
          A3 : in std_logic_vector(4 downto 0);
          WD3: in std_logic_vector(W-1 downto 0);
          clk: in std_logic;
          We3: in std_logic;
          RD1: out std_logic_vector(W-1 downto 0);
          RD2: out std_logic_vector(W-1 downto 0));
end RF;

architecture behavior of RF is

    -- Banco de registradores: 32 registradores de W-1 bits cada
    type registradores is array (0 to 31) of std_logic_vector(W-1 downto 0);

begin

    process(clk, A1, A2)

    variable reg: registradores;

    begin

        reg(0) := (others => '0');      -- Registrador 0 eh sempre zero

        if clk' event and clk = '1' and We3 = '1' then      -- Escreve
            if to_integer(unsigned(A3)) /= 0 then           -- Nao permite escrita no reg 0
                reg(to_integer(unsigned(A3))) := WD3;
            end if;
        end if;

        RD1 <= reg(to_integer(unsigned(A1)));
        RD2 <= reg(to_integer(unsigned(A2)));

    end process;

end behavior;

