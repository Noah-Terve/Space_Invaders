library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity player_sprite is
  port(
    clk : in std_logic;
    xaddr : in unsigned(4 downto 0);
    yaddr : in unsigned(5 downto 0);
	rgb : out std_logic_vector(5 downto 0)
  );
end player_sprite;

architecture synth of player_sprite is
    signal addr : std_logic_vector(10 downto 0);         
    begin
        process(clk) is begin
            if rising_edge(clk) then
                case addr is
                    when "0000000000" => rgb <= "000000";
					when "0000000001" => rgb <= "000000";
					when "0000000010" => rgb <= "000000";
					when "0000000011" => rgb <= "000000";
					when "0000000100" => rgb <= "000000";
					when "0000000101" => rgb <= "000000";
					when "0000000110" => rgb <= "101111";
					when "0000000111" => rgb <= "000000";
					when "0000001000" => rgb <= "000000";
					when "0000001001" => rgb <= "000000";
					when "0000001010" => rgb <= "000000";
					when "0000001011" => rgb <= "000000";
					when "0000001100" => rgb <= "000000";
					when "0001000000" => rgb <= "000000";
					when "0001000001" => rgb <= "000000";
					when "0001000010" => rgb <= "000000";
					when "0001000011" => rgb <= "000000";
					when "0001000100" => rgb <= "000000";
					when "0001000101" => rgb <= "000000";
					when "0001000110" => rgb <= "101111";
					when "0001000111" => rgb <= "000000";
					when "0001001000" => rgb <= "000000";
					when "0001001001" => rgb <= "000000";
					when "0001001010" => rgb <= "000000";
					when "0001001011" => rgb <= "000000";
					when "0001001100" => rgb <= "000000";
					when "0010000000" => rgb <= "000000";
					when "0010000001" => rgb <= "000000";
					when "0010000010" => rgb <= "000000";
					when "0010000011" => rgb <= "000000";
					when "0010000100" => rgb <= "000000";
					when "0010000101" => rgb <= "000000";
					when "0010000110" => rgb <= "101111";
					when "0010000111" => rgb <= "000000";
					when "0010001000" => rgb <= "000000";
					when "0010001001" => rgb <= "000000";
					when "0010001010" => rgb <= "000000";
					when "0010001011" => rgb <= "000000";
					when "0010001100" => rgb <= "000000";
					when "0011000000" => rgb <= "000000";
					when "0011000001" => rgb <= "000000";
					when "0011000010" => rgb <= "000000";
					when "0011000011" => rgb <= "000000";
					when "0011000100" => rgb <= "000000";
					when "0011000101" => rgb <= "101111";
					when "0011000110" => rgb <= "101111";
					when "0011000111" => rgb <= "101111";
					when "0011001000" => rgb <= "000000";
					when "0011001001" => rgb <= "000000";
					when "0011001010" => rgb <= "000000";
					when "0011001011" => rgb <= "000000";
					when "0011001100" => rgb <= "000000";
					when "0100000000" => rgb <= "000000";
					when "0100000001" => rgb <= "000000";
					when "0100000010" => rgb <= "000000";
					when "0100000011" => rgb <= "000000";
					when "0100000100" => rgb <= "000000";
					when "0100000101" => rgb <= "101111";
					when "0100000110" => rgb <= "101111";
					when "0100000111" => rgb <= "101111";
					when "0100001000" => rgb <= "000000";
					when "0100001001" => rgb <= "000000";
					when "0100001010" => rgb <= "000000";
					when "0100001011" => rgb <= "000000";
					when "0100001100" => rgb <= "000000";
					when "0101000000" => rgb <= "000000";
					when "0101000001" => rgb <= "000000";
					when "0101000010" => rgb <= "000000";
					when "0101000011" => rgb <= "110101";
					when "0101000100" => rgb <= "000000";
					when "0101000101" => rgb <= "101111";
					when "0101000110" => rgb <= "101111";
					when "0101000111" => rgb <= "101111";
					when "0101001000" => rgb <= "000000";
					when "0101001001" => rgb <= "110101";
					when "0101001010" => rgb <= "000000";
					when "0101001011" => rgb <= "000000";
					when "0101001100" => rgb <= "000000";
					when "0110000000" => rgb <= "000000";
					when "0110000001" => rgb <= "000000";
					when "0110000010" => rgb <= "000000";
					when "0110000011" => rgb <= "101111";
					when "0110000100" => rgb <= "000000";
					when "0110000101" => rgb <= "101111";
					when "0110000110" => rgb <= "101111";
					when "0110000111" => rgb <= "101111";
					when "0110001000" => rgb <= "000000";
					when "0110001001" => rgb <= "101111";
					when "0110001010" => rgb <= "000000";
					when "0110001011" => rgb <= "000000";
					when "0110001100" => rgb <= "000000";
					when "0111000000" => rgb <= "110101";
					when "0111000001" => rgb <= "000000";
					when "0111000010" => rgb <= "000000";
					when "0111000011" => rgb <= "101111";
					when "0111000100" => rgb <= "000000";
					when "0111000101" => rgb <= "101111";
					when "0111000110" => rgb <= "110101";
					when "0111000111" => rgb <= "101111";
					when "0111001000" => rgb <= "000000";
					when "0111001001" => rgb <= "101111";
					when "0111001010" => rgb <= "000000";
					when "0111001011" => rgb <= "000000";
					when "0111001100" => rgb <= "110101";
					when "1000000000" => rgb <= "101111";
					when "1000000001" => rgb <= "000000";
					when "1000000010" => rgb <= "000000";
					when "1000000011" => rgb <= "101111";
					when "1000000100" => rgb <= "101111";
					when "1000000101" => rgb <= "101111";
					when "1000000110" => rgb <= "110101";
					when "1000000111" => rgb <= "101111";
					when "1000001000" => rgb <= "101111";
					when "1000001001" => rgb <= "101111";
					when "1000001010" => rgb <= "000000";
					when "1000001011" => rgb <= "000000";
					when "1000001100" => rgb <= "101111";
					when "1001000000" => rgb <= "101111";
					when "1001000001" => rgb <= "000000";
					when "1001000010" => rgb <= "101111";
					when "1001000011" => rgb <= "101111";
					when "1001000100" => rgb <= "101111";
					when "1001000101" => rgb <= "110101";
					when "1001000110" => rgb <= "101111";
					when "1001000111" => rgb <= "110101";
					when "1001001000" => rgb <= "101111";
					when "1001001001" => rgb <= "101111";
					when "1001001010" => rgb <= "101111";
					when "1001001011" => rgb <= "000000";
					when "1001001100" => rgb <= "101111";
					when "1010000000" => rgb <= "101111";
					when "1010000001" => rgb <= "101111";
					when "1010000010" => rgb <= "101111";
					when "1010000011" => rgb <= "101111";
					when "1010000100" => rgb <= "101111";
					when "1010000101" => rgb <= "101111";
					when "1010000110" => rgb <= "101111";
					when "1010000111" => rgb <= "101111";
					when "1010001000" => rgb <= "101111";
					when "1010001001" => rgb <= "101111";
					when "1010001010" => rgb <= "101111";
					when "1010001011" => rgb <= "101111";
					when "1010001100" => rgb <= "101111";
					when "1011000000" => rgb <= "000000";
					when "1011000001" => rgb <= "000000";
					when "1011000010" => rgb <= "101111";
					when "1011000011" => rgb <= "101111";
					when "1011000100" => rgb <= "101111";
					when "1011000101" => rgb <= "110101";
					when "1011000110" => rgb <= "101111";
					when "1011000111" => rgb <= "110101";
					when "1011001000" => rgb <= "101111";
					when "1011001001" => rgb <= "101111";
					when "1011001010" => rgb <= "101111";
					when "1011001011" => rgb <= "000000";
					when "1011001100" => rgb <= "000000";
					when "1100000000" => rgb <= "000000";
					when "1100000001" => rgb <= "000000";
					when "1100000010" => rgb <= "000000";
					when "1100000011" => rgb <= "000000";
					when "1100000100" => rgb <= "110101";
					when "1100000101" => rgb <= "000000";
					when "1100000110" => rgb <= "101111";
					when "1100000111" => rgb <= "000000";
					when "1100001000" => rgb <= "110101";
					when "1100001001" => rgb <= "000000";
					when "1100001010" => rgb <= "000000";
					when "1100001011" => rgb <= "000000";
					when "1100001100" => rgb <= "000000";
					when others => rgb <= "000000";
                end case;
            end if;
        end process;   
        addr <=  std_logic_vector(yaddr) & std_logic_vector(xaddr);   
    end;
