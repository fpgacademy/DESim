-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- This module implements an n-bit counter. Upper bits of the counter, driven by the 
-- 50 MHz clock signal, are displayed on the LEDR lights. The counter can be reset to 0
-- using KEY[0]. 
ENTITY Counter IS 
    GENERIC (
        n    : INTEGER := 24
    );
    PORT ( 
        CLOCK  : IN  STD_LOGIC;
        RESETn : IN  STD_LOGIC;
        LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END Counter;

ARCHITECTURE Behavior OF Counter IS
    SIGNAL count : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

    -- the counter
    PROCESS (CLOCK)
    BEGIN
        IF (CLOCK'EVENT AND CLOCK = '1') THEN
            IF (RESETn = '0') THEN
                count <= (OTHERS => '0');
			ELSE
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;

    LEDR <= count(n-1 DOWNTO n-10);

END Behavior;

