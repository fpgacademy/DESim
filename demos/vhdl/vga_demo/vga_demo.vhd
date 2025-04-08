-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY vga_demo IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        VGA_X     : OUT   STD_LOGIC_VECTOR( 8 DOWNTO 0);  -- "VGA" column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0);  -- "VGA" row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR(23 DOWNTO 0);  -- "VGA pixel" colour
        plot      : OUT   STD_LOGIC                       -- "Pixel" is drawn when this is pulsed
    );
END vga_demo;

ARCHITECTURE Behavior OF vga_demo IS
    COMPONENT hex7seg
        PORT (
            hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL x      : STD_LOGIC_VECTOR( 8 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y      : STD_LOGIC_VECTOR( 7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL color  : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"FF0000";
    SIGNAL Resetn  : STD_LOGIC := '1';
BEGIN

    Resetn  <= KEY(0);

    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (Resetn = '0') THEN
                x     <= (OTHERS => '0');
                y     <= (OTHERS => '0');
                color <= X"FF0000";
            ELSE
                IF (x = "100111111") THEN
                    x <= (OTHERS => '0');
                    IF (y = "10011111") THEN
                        y     <= (OTHERS => '0');
                        if (color = X"FF0000") THEN
                            color <= X"FF7700";
                        ELSIF (color = X"FF7700") THEN
                            color <= X"FFFF00";
                        ELSIF (color = X"FFFF00") THEN
                            color <= X"77FF00";
                        ELSIF (color = X"77FF00") THEN
                            color <= X"00FF00";
                        ELSIF (color = X"00FF00") THEN
                            color <= X"00FF77";
                        ELSIF (color = X"00FF77") THEN
                            color <= X"00FFFF";
                        ELSIF (color = X"00FFFF") THEN
                            color <= X"0077FF";
                        ELSIF (color = X"0077FF") THEN
                            color <= X"0000FF";
                        ELSIF (color = X"0000FF") THEN
                            color <= X"7700FF";
                        ELSIF (color = X"7700FF") THEN
                            color <= X"FF00FF";
                        ELSIF (color = X"FF00FF") THEN
                            color <= X"FF0077";
                        ELSIF (color = X"FF0077") THEN
                            color <= X"FF0000";
                        END IF;
                    ELSE
                        y     <= y + 1;
                    END IF;
                ELSE
                    x <= x + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    H0: hex7seg PORT MAP (color(3 DOWNTO 0), HEX0);
    H1: hex7seg PORT MAP (color(7 DOWNTO 4), HEX1);
    H2: hex7seg PORT MAP (color(11 DOWNTO 8), HEX2);
    H3: hex7seg PORT MAP (color(15 DOWNTO 12), HEX3);
    H4: hex7seg PORT MAP (color(19 DOWNTO 16), HEX4);
    H5: hex7seg PORT MAP (color(23 DOWNTO 20), HEX5);

    VGA_X     <= x;
    VGA_Y     <= y;
    VGA_COLOR <= color;
    plot      <= '1';

END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY hex7seg IS
    PORT (
        hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END hex7seg;

ARCHITECTURE Behavior OF hex7seg IS
    -- 
    --        0  
    --       ---  
    --      |   |
    --     5|   |1
    --      | 6 |
    --       ---  
    --      |   |
    --     4|   |2
    --      |   |
    --       ---  
    --        3  
    -- 
BEGIN
    PROCESS (hex)
    BEGIN
        CASE hex IS
            WHEN "0000" => display <= "1000000";
            WHEN "0001" => display <= "1111001";
            WHEN "0010" => display <= "0100100";
            WHEN "0011" => display <= "0110000";
            WHEN "0100" => display <= "0011001";
            WHEN "0101" => display <= "0010010";
            WHEN "0110" => display <= "0000010";
            WHEN "0111" => display <= "1111000";
            WHEN "1000" => display <= "0000000";
            WHEN "1001" => display <= "0011000";
            WHEN "1010" => display <= "0001000";
            WHEN "1011" => display <= "0000011";
            WHEN "1100" => display <= "1000110";
            WHEN "1101" => display <= "0100001";
            WHEN "1110" => display <= "0000110";
            WHEN "1111" => display <= "0001110";
            WHEN OTHERS => display <= "XXXXXXX";
        END CASE;
    END PROCESS;

END Behavior;
