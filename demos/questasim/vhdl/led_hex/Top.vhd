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
        HEX2      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX3      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX4      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX5      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs 
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    COMPONENT LED_HEX
        PORT ( 
            CLOCK  : IN  STD_LOGIC;
            KEY    : IN    STD_LOGIC_VECTOR( 1 DOWNTO 0);
            SW     : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);
            HEX0   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX1   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX2   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX3   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX4   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX5   : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            LEDR   : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    U1: LED_HEX PORT MAP (CLOCK_50, KEY(1 DOWNTO 0), SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

END Behavior;

