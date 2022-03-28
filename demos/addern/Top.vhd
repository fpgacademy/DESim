-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs 
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    COMPONENT Addern
        GENERIC (
            n    : INTEGER := 4
        );
        PORT ( 
            Cin  : IN  STD_LOGIC;
            X, Y : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            Sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            Cout : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN

    U1: Addern PORT MAP (SW(9), SW(3 DOWNTO 0), SW(7 DOWNTO 4), LEDR(3 DOWNTO 0), LEDR(4));

    LEDR(9 DOWNTO 5) <= (OTHERS => '0');

END Behavior;

