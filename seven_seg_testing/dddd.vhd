library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dddd is
    port(
        display_clk : in std_logic;
        position : in unsigned(7 downto 0);
        display_val : out std_logic_vector(6 downto 0);
        leds : out std_logic_vector(1 downto 0)

    );
end dddd;

architecture sim of dddd is
signal lowBCD : unsigned(3 downto 0);
signal highBCD : unsigned(3 downto 0);
signal tensplace : unsigned(12 downto 0);
signal counter : unsigned(12 downto 0) := 13b"0";
signal tensdigit : std_logic_vector(6 downto 0);
signal onesdigit : std_logic_vector(6 downto 0);

component sevenseg is
    port(
	    res : in unsigned(3 downto 0);
	    segments : out std_logic_vector(6 downto 0)
    );
end component;

begin
    process (display_clk) begin
        if rising_edge(display_clk) then
            counter <= counter + 1;
            leds <= "01" when counter(8) = '0' else
                    "10";
        end if;
    end process;

    ones : sevenseg port map(res => lowBCD, segments => onesdigit);
    tens : sevenseg port map(res => highBCD, segments => tensdigit);
    
    display_val <= onesdigit when (leds(0) = '0') else tensdigit;

    -- Low digit result is 4 bit unsigned
    lowBCD <= position (3 downto 0);
    highBCD <= position (7 downto 4);
end;

