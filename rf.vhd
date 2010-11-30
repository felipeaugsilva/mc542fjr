library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

Entity RF is
 Generic(W : natural);
 port(A1       : in std_logic_vector(4 downto 0);
      A2       : in std_logic_vector(4 downto 0);
      A3       : in std_logic_vector(4 downto 0);
      WD3      : in std_logic_vector(W-1 downto 0);
      clk      : in std_logic;
      We3      : in std_logic;
      RD1      : out std_logic_vector(W-1 downto 0);
      RD2      : out std_logic_vector(W-1 downto 0));
End RF;

architecture behaviour of RF is

  type vetregs is array (4 downto 0) of STD_LOGIC_VECTOR (4 downto 0);
  signal regs: vetregs;

begin
  

  -- escrita sincrona
  process(clk) begin
    if clk'event and clk = '1' then
      if We3 = '1' then regs(CONV_INTEGER(A3)) <= WD3;
      end if;
    end if;
  end process;

  -- leitura assincrona
  process (A1, A2) begin

    if (CONV_INTEGER(A1) = 0) then RD1 <= (others => '0'); -- registrador 0 contem zero
    else RD1 <= regs(CONV_INTEGER (A1));
    end if;

    if (CONV_INTEGER(A2) = 0) then RD2 <= (others => '0'); -- registrador 0 contem zero
    else RD2 <= regs(CONV_INTEGER(A2));
    end if;

  end process;
end;

