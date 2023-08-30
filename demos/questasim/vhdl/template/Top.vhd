-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        GPIO      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- DE-series 40-pin header
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX displays 
        HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX2      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX3      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX4      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX5      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series LEDs 

        PS2_CLK   : INOUT STD_LOGIC;                      -- PS/2 Clock
        PS2_DAT   : INOUT STD_LOGIC;                      -- PS/2 Data

        VGA_X     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0);  -- "VGA" column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- "VGA" row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0);  -- "VGA pixel" colour (0-7)
        plot      : OUT   STD_LOGIC                       -- "Pixel" is drawn when this is pulsed
    );
END Top;

ARCHITECTURE Behavior OF Top IS
BEGIN

    GPIO      <= (OTHERS => 'Z');

    HEX0      <= "1000000";
    HEX1      <= "1000111";
    HEX2      <= "1000111";
    HEX3      <= "0000110";
    HEX4      <= "0001001";
    HEX5      <= "1111111";

    LEDR      <= "0101010101";

    PS2_CLK   <= 'Z';
    PS2_DAT   <= 'Z';

    VGA_X     <= "0000" & SW(3 DOWNTO 0);
    VGA_Y     <= "000" & SW(7 DOWNTO 4);
    VGA_COLOR <= KEY(3 DOWNTO 1);
    plot      <= KEY(0);

END Behavior;

