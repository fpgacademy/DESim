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
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX displays 
        HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series LEDs 

        PS2_CLK   : INOUT STD_LOGIC;                      -- PS/2 Clock
        PS2_DAT   : INOUT STD_LOGIC                       -- PS/2 Data
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    COMPONENT PS2_Comm
        PORT ( 
            CLOCK_50  : IN    STD_LOGIC;
            KEY       : IN    STD_LOGIC_VECTOR( 1 DOWNTO 0);
            SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);

            PS2_CLK   : INOUT STD_LOGIC;
            PS2_DAT   : INOUT STD_LOGIC;

            HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    LEDR <= SW;

    comm: PS2_Comm PORT MAP (CLOCK_50, KEY(1 DOWNTO 0), SW, PS2_CLK, PS2_DAT, HEX0, HEX1);

END Behavior;

