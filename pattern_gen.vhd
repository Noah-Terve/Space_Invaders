library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
	port (
		clk : in std_logic;
		valid : in std_logic;
		
		-- row and col that the vga is looking for
		row : in unsigned(9 downto 0);
		col : in unsigned(9 downto 0);
		
		-- output val
		rgb : out std_logic_vector(5 downto 0);
		
		-- Player position, given as input
		player_x : in unsigned(9 downto 0);
		player_y : in unsigned(9 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is

-- Output Color
signal output : std_logic_vector(5 downto 0);

signal player_width : unsigned(5 downto 0);
signal player_height : unsigned(5 downto 0);
signal player_pixel : std_logic_vector(5 downto 0);
signal drawing_player_x : std_logic;
signal drawing_player_y : std_logic;

signal player_diff_x_vector : std_logic_vector(9 downto 0);
signal player_diff_y_vector : std_logic_vector(9 downto 0);
signal player_diff_x : unsigned(9 downto 0);
signal player_diff_y : unsigned(9 downto 0);

component player_sprite is
	port(
		clk : in std_logic;
		xaddr : in unsigned(3 downto 0);
		yaddr : in unsigned(3 downto 0);
		rgb : out std_logic_vector(5 downto 0)
	);
end component;
	
begin
	player_sprite_map : player_sprite port map (
		clk => clk,
		xaddr => player_diff_x(3 downto 0),
		yaddr => player_diff_y(3 downto 0),
		--xaddr => unsigned(player_diff_x_vector(3 downto 0)),
		--yaddr => unsigned(player_diff_y_vector(3 downto 0)),
		rgb => player_pixel
	);
	
	player_width <= 6d"13";
	player_height <= 6d"13";
	
	player_diff_x <= col - player_x;
	player_diff_y <= row - player_y;
	
	-- player_diff_x_vector <= std_logic_vector(unsigned(player_width) - unsigned(player_diff_x));
	-- player_diff_y_vector <= std_logic_vector(unsigned(player_width) - unsigned(player_diff_y));
	
	drawing_player_x <= '1' when (col >= player_x and col <= player_x + player_width) else '0';
	drawing_player_y <= '1' when (row >= player_y and row <= player_y + player_height) else '0';
		
	output <= player_pixel when drawing_player_x and drawing_player_y else 6b"0";
	
	
	rgb <= output when (valid = '1') else 6b"0";
end;
