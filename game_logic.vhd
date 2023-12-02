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
        bulletvalid           : out std_logic;

        game_over             : out std_logic
    );
end game_logic;

architecture synth of game_logic is

-- this is a 2d array thats 10 by 6 which stores the alien positions
-- i.e. each position is 0 if an alien is there and 1 if not
signal alien_positions    : std_logic_vector (19 downto 0);
signal alien_xposition    : unsigned (9 downto 0);
signal alien_yposition    : unsigned (8 downto 0);
signal alien_direction    : std_logic; -- 1 for moving right, 0 for moving left

signal player_xposition   : unsigned (9 downto 0);
signal player_yposition   : unsigned (8 downto 0);

signal bullet_xposition   : unsigned (9 downto 0);
signal bullet_yposition   : unsigned (8 downto 0);
signal bullet_present     : std_logic; -- 0 no bullet present, 1 bullet present

signal alien_clock        : unsigned (15 downto 0);
signal bullet_clock       : unsigned (15 downto 0);

signal alien_x_offset     : unsigned (4 downto 0);
signal alien_y_offset     : unsigned (3 downto 0);
signal gameover           : std_logic;

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
    game_over <= gameover;

    process (given_clk) begin
        if rising_edge (given_clk) then
            if (gameover = '0' and alien_positions = "11111111111111111111") then
                gameover <= '1';
                -- alien_xposition <= 10b"0";
                -- alien_yposition <= 9b"0";
                -- alien_direction <= '0';
                -- player_xposition <= 10b"0";
            else
                gameover <= '0';
            end if;
            
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
            
            if (bullet_present = '1') then

                -- collision for first alien
                if (alien_positions(0) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition and bullet_xposition < (alien_xposition + 11)) then
                            alien_positions(0) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 2nd alien
                if (alien_positions(1) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + alien_x_offset and bullet_xposition < (alien_xposition + 11 + alien_x_offset)) then
                            alien_positions(1) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 3rd alien
                if (alien_positions(2) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 2) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 2))) then
                            alien_positions(2) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 4th alien
                if (alien_positions(3) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 3) and bullet_xposition < (alien_xposition + 11 + alien_x_offset*3)) then
                            alien_positions(3) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
                
                -- 5th alien
                if (alien_positions(4) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 4) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 4))) then
                            alien_positions(4) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
                
                -- 6th alien
                if (alien_positions(5) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 5) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 5))) then
                            alien_positions(5) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
            
                -- 7th alien
                if (alien_positions(6) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 6) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 6))) then
                            alien_positions(6) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 8th alien
                if (alien_positions(7) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 7) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 7))) then
                            alien_positions(7) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 9th alien
                if (alien_positions(8) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 8) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 8))) then
                            alien_positions(8) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 10th alien
                if (alien_positions(9) = '0') then
                    if (bullet_yposition < (alien_yposition + 7) and (bullet_yposition + 12) > alien_yposition) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 9) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 9))) then
                            alien_positions(9) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- SECOND ROW =)

                -- 11th alien
                if (alien_positions(10) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition and bullet_xposition < (alien_xposition + 11)) then
                            alien_positions(10) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 12th alien
                if (alien_positions(11) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + alien_x_offset and bullet_xposition < (alien_xposition + 11 + alien_x_offset)) then
                            alien_positions(11) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 13th alien
                if (alien_positions(12) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 2) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 2))) then
                            alien_positions(12) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 14th alien
                if (alien_positions(13) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 3) and bullet_xposition < (alien_xposition + 11 + alien_x_offset*3)) then
                            alien_positions(13) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
                
                -- 15th alien
                if (alien_positions(14) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 4) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 4))) then
                            alien_positions(14) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
                
                -- 16th alien
                if (alien_positions(15) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 5) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 5))) then
                            alien_positions(15) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
            
                -- 17th alien
                if (alien_positions(16) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 6) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 6))) then
                            alien_positions(16) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 18th alien
                if (alien_positions(17) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 7) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 7))) then
                            alien_positions(17) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 19th alien
                if (alien_positions(18) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 8) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 8))) then
                            alien_positions(18) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;

                -- 20th alien
                if (alien_positions(19) = '0') then
                    if (bullet_yposition < (alien_yposition + 7 + alien_y_offset) and (bullet_yposition + 12) > alien_yposition + alien_y_offset) then
                        if ((bullet_xposition + 5) > alien_xposition + (alien_x_offset * 9) and bullet_xposition < (alien_xposition + 11 + (alien_x_offset * 9))) then
                            alien_positions(19) <= '1';
                            bullet_present <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    alien_x_offset <= 5d"20";
    alien_y_offset <= 4d"15";

    player_yposition <= 9d"61";

	alien_direction <= '0' when (alien_xposition > 10d"408")
				  else '1' when (alien_xposition < 10b"100000") 
				  else alien_direction;

	-- process (alien_direction) begin
	-- 	-- 10 aliens in a row, with 9 spaces between them take up 200
    --     -- then 30 from end of screen, if the x pos > 640 - 200 - 30 go the other way
	-- 	alien_yposition <= alien_yposition - 15;
	-- end process;
	
end synth;