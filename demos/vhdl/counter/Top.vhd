-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- DE-series LEDs 
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT counter
        PORT ( 
            CLOCK  : IN STD_LOGIC;
            RESETn : IN STD_LOGIC;
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL rst_n : STD_LOGIC;
BEGIN

    rst_n <= KEY(0);

    U1: counter PORT MAP (CLOCK_50, rst_n, LEDR);
    -- LEDR <= "1110101010";

END Behavior;

