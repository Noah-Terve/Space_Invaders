library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
    port(
	    given_clk             : in std_logic;
        controller_data       : in std_logic_vector (7 downto 0);

        -- position data
        aliens                : out std_logic_vector (19 downto 0);
        alienx                : out unsigned (9 downto 0);
        alieny                : out unsigned (8 downto 0);
        
        playerx               : out unsigned (9 downto 0);
        playery               : out unsigned (8 downto 0);

        bulletx               : out unsigned (9 downto 0);
        bullety               : out unsigned (8 downto 0);
        bulletvalid           : out std_logic
    );
end game_logic;

architecture synth of game_logic is

-- this is a 2d array thats 10 by 6 which stores the alien positions
-- i.e. each position is 1 if an alien is there and 0 if not
signal alien_positions    : std_logic_vector (19 downto 0);
signal alien_xposition    : unsigned (9 downto 0);
signal alien_yposition    : unsigned (8 downto 0);
signal alien_direction    : std_logic; -- 1 for moving right, 0 for moving left

signal player_xposition   : unsigned (9 downto 0);
signal player_yposition   : unsigned (8 downto 0);

signal bullet_xposition   : unsigned (9 downto 0);
signal bullet_yposition   : unsigned (8 downto 0);
signal bullet_present     : std_logic; -- 0 no bullet present, 1 bullet present

signal alien_clock        : unsigned (15 downto 0) := 16b"0";
signal bullet_clock       : unsigned (15 downto 0) := 16b"0";
-- signal : new_aliens_counter : unsigned (10 downto 0);

begin

    aliens <= alien_positions;
    alienx <= alien_xposition;
    alieny <= alien_yposition;
    playerx <= player_xposition;
    playery <= player_yposition;
    bulletx <= bullet_xposition;
    bullety <= bullet_yposition;
    bulletvalid <= bullet_present;

    process (given_clk) begin
        if rising_edge (given_clk) then

                -- counter for alien movement and bullet movement
                alien_clock <= alien_clock + 1;
                bullet_clock <= bullet_clock + 1;

                -- player left/right movement, mins and maxes out at 30px from each side
                --player move left
                if (controller_data(1) = '1') 
                    then player_xposition <= player_xposition - 1 when player_xposition > 30 else 
                                            player_xposition;
                end if;
                
                -- player move right
                if (controller_data(0) = '1') 
                                                                -- 640 - 30 - 13 (13 is player width)
                    then player_xposition <= player_xposition + 1 when player_xposition < 597 else 
                                            player_xposition;
                end if;

                -- player trying to shoot, if there is a bullet present dont shoot, if not shoot
                if (controller_data(6) = '1') then
                    if (bullet_present = '0') then 
                        -- shoot bullet
                        bullet_present <= '1';
                        bullet_xposition <= player_xposition + 5; -- middle of player cause bullets are 3 wide
                        bullet_yposition <= player_yposition + 12; -- right on top of player cause bullets are 12 tall
                    end if;
                end if;

                -- check bullet collision and move it
                if (bullet_present = '1') then
                    -- check bullet collision

                    --move bullet
                    if (bullet_clock(4) = '1') then
                        bullet_yposition <= bullet_yposition + 1;
                        bullet_clock <= 16b"0";
                    end if;

                    -- bullet goes off the screen
                    if (bullet_yposition > 468) then 
                        bullet_present <= '0';
                    end if;
                end if;

                -- every x cycles update the alien positions
                if (alien_clock(5) = '1') then
                    -- move aliens
                    if (alien_direction = '1') then
                        alien_xposition <= alien_xposition + 10b"1";
                    else alien_xposition <= alien_xposition - 10b"1";
                    end if;

                    if (alien_xposition = 10b"11111") then
                        alien_yposition <= alien_yposition - 15;
                    end if;
                    if (alien_xposition = 10d"409") then
                        alien_yposition <= alien_yposition - 15;
                    end if;
                    
                    alien_clock <= 16b"0";
                end if;
                
                
                -- check alien collisions with player to trigger loss
            -- end if;
        end if;
    end process;
	
	alien_direction <= '0' when (alien_xposition > 10d"408")
				  else '1' when (alien_xposition < 10b"100000") 
				  else alien_direction;

	-- process (alien_direction) begin
	-- 	-- 10 aliens in a row, with 9 spaces between them take up 200
    --     -- then 30 from end of screen, if the x pos > 640 - 200 - 30 go the other way
	-- 	alien_yposition <= alien_yposition - 15;
	-- end process;
	
end synth;