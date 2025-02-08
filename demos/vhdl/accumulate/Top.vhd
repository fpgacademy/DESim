-- Copyright (c) 2020 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs 
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    COMPONENT Accumulate
        PORT ( 
            CLOCK  : IN STD_LOGIC;
            RESETn : IN STD_LOGIC;
            SW     : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL rst_n : STD_LOGIC;
BEGIN

    rst_n <= KEY(0);

    U1: Accumulate PORT MAP (CLOCK_50, rst_n, SW, LEDR);

END Behavior;

