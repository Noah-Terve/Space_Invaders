library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gamestate is
    port(
	gamestate_clk         : in std_logic;
	controller_data       : in std_logic_vector (7 downto 0);
	gameover			  : in std_logic;
	curr_gamestate		  : out std_logic
    );
end gamestate;


architecture synth of gamestate is

signal cooldown_clk        : unsigned (15 downto 0);
signal state_lock		   : std_logic;

begin

process (gamestate_clk) begin
	if (rising_edge(gamestate_clk)) then
		
		-- start button is pressed while game is not in play
		if (controller_data(4) = '1' and curr_gamestate = '0') then
		curr_gamestate <= '1';
		end if;
		
		-- game is in play and gameover flag is thrown
		if (gameover = '1' and curr_gamestate = '1') then
		curr_gamestate <= '0';
		end if;
		
	end if;

end process;

end synth;
