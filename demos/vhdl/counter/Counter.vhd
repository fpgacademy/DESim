-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- This module implements an n-bit counter. Upper bits of the counter, driven by the 
-- 50 MHz clock signal, are displayed on LEDR. The counter can be reset to 0 using Resetn
-- and it is enabled using En. 
ENTITY counter IS 
    GENERIC (n : INTEGER := 24);
    PORT ( 
        Clock  : IN  STD_LOGIC;
        Resetn : IN  STD_LOGIC;
        En     : IN  STD_LOGIC;
        LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END counter;

ARCHITECTURE Behavior OF counter IS
    SIGNAL count : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');
BEGIN

    -- the counter
    PROCESS (Clock)
    BEGIN
        IF (Clock'EVENT AND Clock = '1') THEN
            IF (Resetn = '0') THEN
                count <= (OTHERS => '0');
            ELSIF (En = '1') THEN
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;

    LEDR <= count(n-1 DOWNTO n-10);

END Behavior;

