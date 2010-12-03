library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ALU is
  Generic(
    W           : natural := 32
  );
  port(
    SrcA        : in  std_logic_vector(W-1 downto 0);
    SrcB        : in  std_logic_vector(W-1 downto 0);
    AluControl  : in  std_logic_vector(2 downto 0);
    AluResult   : out std_logic_vector(W-1 downto 0);
    Zero        : out std_logic;
    Overflow    : out std_logic;
    CarryOut    : out std_logic
  );
End Entity ALU;

Architecture behaviour of ALU is
begin

  ALUfunction : process(AluControl, SrcA, SrcB)
  variable temp : std_logic_vector(W downto 0);
  begin

    case AluControl is
      when "000" => --AND
        temp := ('0' & SrcA) and ('0' & SrcB);
      when "001" => --OR
        temp := ('0' & SrcA)  or ('0' & SrcB);
      when "010" => --ADD
        temp := std_logic_vector(signed('0' & SrcA) + signed('0' & SrcB));
      when "100" => --ANDNOT
        temp := ('0' & SrcA) and (not ('0' & SrcB));
      when "101" => --ORNOT
        temp := ('0' & SrcA)  or (not ('0' & SrcB));
      when "110" => --SUB
        temp := std_logic_vector(signed(('0' & SrcA)) - signed('0' & SrcB));        
      when "111" => --SLT
        if signed(SrcA) < signed(SrcB) then
          temp := (0 => '1', others => '0');
        else
          temp := (others => '0');
        end if;
      when others => null;
    end case;

    AluResult <= temp(W-1 downto 0);
    if signed(temp(W-1 downto 0)) = 0 then
      Zero <= '1';
    else
      Zero <= '0';
    end if;
    Overflow <= temp(W) xor SrcA(W-1) xor SrcB(W-1) xor temp(W-1);
    CarryOut <= temp(W);

  end process ALUfunction;

end behaviour;
