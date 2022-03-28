-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons

        VGA_X     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0);  -- "VGA" column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- "VGA" row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0);  -- "VGA pixel" colour (0-7)
        plot      : OUT   STD_LOGIC                       -- "Pixel" is drawn when this is pulsed
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    SIGNAL x      : STD_LOGIC_VECTOR( 7 DOWNTO 0);
    SIGNAL y      : STD_LOGIC_VECTOR( 6 DOWNTO 0);
    SIGNAL color  : STD_LOGIC_VECTOR( 2 DOWNTO 0);
    SIGNAL reset  : STD_LOGIC;
BEGIN

    reset     <= NOT KEY(0);

    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (reset = '1') THEN
                x     <= (OTHERS => '0');
                y     <= (OTHERS => '0');
                color <= "001";
            ELSE
                IF (x = "10011111") THEN
                    x <= (OTHERS => '0');
                    IF (y = "1110111") THEN
                        y     <= (OTHERS => '0');
                        color <= color + 1;
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

