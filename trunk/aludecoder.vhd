library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity aludec is  -- ALU control decoder
    port (funct:      in  STD_LOGIC_VECTOR (5 downto 0);
          aluop:      in  STD_LOGIC_VECTOR (1 downto 0);
          alucontrol: out STD_LOGIC_VECTOR (3 downto 0));
end;

architecture behave of aludec is
begin
    process (aluop, funct) begin

        case aluop is
            when "00" => alucontrol <= "0010"; -- add (for 1b/sb/addi)
            when "01" => alucontrol <= "0110"; -- sub (for beq)
            when others =>                    -- R-type instructions
                case funct is
                    when "100000" => alucontrol <= "0010"; -- add
                    when "100010" => alucontrol <= "0110"; -- sub
                    when "100100" => alucontrol <= "0000"; -- and
                    when "100101" => alucontrol <= "0001"; -- or
                    when "101010" => alucontrol <= "0111"; -- slt
                    when "100110" => alucontrol <= "0011"; -- xor
                    when "100001" => alucontrol <= "1000"; -- addu
                    when "100011" => alucontrol <= "1001"; -- subu
                    when "101011" => alucontrol <= "1010"; -- sltu
                    when others   => alucontrol <= "----"; -- ???
                end case;
        end case;

    end process;
end;
