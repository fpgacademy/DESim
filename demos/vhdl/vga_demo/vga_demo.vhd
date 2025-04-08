-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY vga_demo IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons

        VGA_X     : OUT   STD_LOGIC_VECTOR( 8 DOWNTO 0);  -- "VGA" column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0);  -- "VGA" row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR(23 DOWNTO 0);  -- "VGA pixel" colour
        plot      : OUT   STD_LOGIC                       -- "Pixel" is drawn when this is pulsed
    );
END vga_demo;

ARCHITECTURE Behavior OF vga_demo IS
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

    VGA_X     <= x;
    VGA_Y     <= y;
    VGA_COLOR <= color;
    plot      <= '1';

END Behavior;

