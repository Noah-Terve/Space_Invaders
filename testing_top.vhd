library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port(
        nes_data           : in std_logic;
	    nes_clk            : out std_logic;
		temp  			   : out std_logic_vector (7 downto 0);
        nes_latch          : out std_logic;
		
		disp 			   : out std_logic_vector(6 downto 0);
		top_two 		   : out std_logic_vector(1 downto 0);
		led 			   : out std_logic_vector(1 downto 0)
    );
end top;

architecture synth of top is

signal clk     			  : std_logic;
signal nes_result  		  : std_logic_vector (7 downto 0);
signal valid   			  : std_logic := '0';
signal logic_aliens       : std_logic_vector (19 downto 0);
signal logic_alienx       : unsigned (9 downto 0);
signal logic_alieny       : unsigned (8 downto 0);
        
signal logic_playerx      : unsigned (9 downto 0);
signal logic_playery      : unsigned (8 downto 0);

signal logic_bulletx      : unsigned (9 downto 0);
signal logic_bullety      : unsigned (8 downto 0);
signal logic_bulletvalid  : std_logic;


component dddd is
    port(
        display_clk : in std_logic;
        position : in unsigned(7 downto 0);
        display_val : out std_logic_vector(6 downto 0);
        leds : out std_logic_vector(1 downto 0)

    );
end component;


-- END TESTING --
component HSOSC is
	generic (CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2^N (0-3)
	port(
		CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up
		CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
		CLKHF : out std_logic := 'X'); -- Clock output
end component;

component controller is
    port(
        in_clk : in std_logic := '0';
	    controller_clk : out std_logic := '0';
        latch : out std_logic := '0';
        data : in std_logic := '0';
        result : out std_logic_vector(7 downto 0) := 8b"0"
    );
end component;

component game_logic is
    port(
	    given_clk             : in std_logic := '0';
        controller_data       : in std_logic_vector (7 downto 0) := 8b"0";

        -- position data
        aliens                : out std_logic_vector (19 downto 0) :=  20b"11111111111111111111";
        alienx                : out unsigned (9 downto 0) := 10d"31";
        alieny                : out unsigned (8 downto 0) := 9d"432";
        
        playerx               : out unsigned (9 downto 0) := 10d"240";
        playery               : out unsigned (8 downto 0) := 9d"61";

        bulletx               : out unsigned (9 downto 0) := 10b"0";
        bullety               : out unsigned (8 downto 0) := 9b"0";
        bulletvalid           : out std_logic := '0'
    );
end component;

begin
    osc : HSOSC generic map ( CLKHF_DIV => "0b00")
                   port map (CLKHFPU => '1',
                             CLKHFEN => '1',
                             CLKHF => clk);
	nes : controller port map ( in_clk => clk, controller_clk => nes_clk, latch => nes_latch, data => nes_data, result => nes_result);
    logic : game_logic port map (
        given_clk => nes_clk, controller_data => nes_result,
        aliens => logic_aliens, alienx => logic_alienx, alieny => logic_alieny,
        playerx => logic_playerx, playery => logic_playery,
        bulletx => logic_bulletx, bullety => logic_bullety, bulletvalid => logic_bulletvalid
    );
	display : dddd port map (display_clk => clk, position => logic_bullety(7 downto 0), display_val => disp, leds => led);
	temp <= nes_result;
	top_two(0) <= logic_bullety(8);
	top_two(1) <= logic_bulletvalid;

    -- create instances of the various needed modules and map their ports appropriately
end synth;