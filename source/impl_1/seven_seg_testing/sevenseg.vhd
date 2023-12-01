library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sevenseg is
	port(
		res : in unsigned(3 downto 0);
		segments : out std_logic_vector(6 downto 0)
	);
end sevenseg;

architecture synth of sevenseg is
begin
    -- outputs for seven seg display based on
    -- table made in prelab 5
    segments <= "0000001" when res = x"0" else
                "1001111" when res = x"1" else
                "0010010" when res = x"2" else
                "0000110" when res = x"3" else
                "1001100" when res = x"4" else
                "0100100" when res = x"5" else
                "0100000" when res = x"6" else
                "0001111" when res = x"7" else
                "0000000" when res = x"8" else
                "0001100" when res = x"9" else
                "0001000" when res = x"a" else
                "1100000" when res = x"b" else
                "0110001" when res = x"c" else
                "1000010" when res = x"d" else
                "0110000" when res = x"e" else
                "0111000" when res = x"f";
end;
