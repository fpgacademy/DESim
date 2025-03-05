-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX0 display
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT display
        PORT ( 
            CLOCK  : IN  STD_LOGIC;
            RESETn : IN  STD_LOGIC;
            HEX0   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Clock : STD_LOGIC;
    SIGNAL Resetn : STD_LOGIC;
BEGIN

    Clock <= KEY(0);
    Resetn <= SW(0);

    U1: display PORT MAP (Clock, Resetn, HEX0, LEDR);

END Behavior;

