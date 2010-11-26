library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity equal is -- 
    generic (W: integer := 32);
    port (a, b: in  STD_LOGIC_VECTOR(W-1 downto 0);
          y:    out STD_LOGIC_VECTOR);
end;

architecture behave of equal is
begin
    y <= '1' when a = b else '0';
end;
