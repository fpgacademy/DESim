-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX0 display
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    COMPONENT Display
        PORT ( 
            CLOCK  : IN  STD_LOGIC;
            RESETn : IN  STD_LOGIC;
            HEX0   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL clock : STD_LOGIC;
    SIGNAL rst_n : STD_LOGIC;
BEGIN

    clock <= KEY(0);
    rst_n <= SW(0);

    U1: Display PORT MAP (clock, rst_n, HEX0, LEDR);

END Behavior;

