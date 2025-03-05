-- Copyright (c) 2020 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs 
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT accumulate
        PORT ( 
            Clock  : IN STD_LOGIC;
            Resetn : IN STD_LOGIC;
            SW     : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Resetn : STD_LOGIC;
BEGIN

    Resetn <= KEY(0);

    U1: accumulate PORT MAP (CLOCK_50, Resetn, SW, LEDR);

END Behavior;

