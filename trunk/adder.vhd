library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- use IEEE.STD_LOGIC_UNSIGNED.all;   // UNSIGNED????? - verificar

entity adder is -- adder
    generic (W: integer := 32);
    port (a, b: in  STD_LOGIC_VECTOR(W-1 downto 0);
          y:    out STD_LOGIC_VECTOR(W-1 downto 0));
end;

architecture behave of adder is
begin
    y <= a + b;
end;
