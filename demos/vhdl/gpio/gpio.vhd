-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY gpio_demo IS
    PORT (
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        GPIO      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)   -- DE-series 40-pin header
    );
END gpio_demo;

ARCHITECTURE Behavior OF gpio_demo IS
BEGIN

    PROCESS (SW, GPIO)
    BEGIN
        IF (SW(1 DOWNTO 0) = "00") THEN
            GPIO(31 DOWNTO 24) <= GPIO(15 DOWNTO 8);
        ELSE
            GPIO(31 DOWNTO 24) <= (OTHERS => '0');
        END IF;
        
        IF (SW(1 DOWNTO 0) = "00") THEN
            GPIO(23 DOWNTO 16) <= GPIO( 7 DOWNTO 0);
        ELSIF (SW(1 DOWNTO 0) = "01") THEN
            GPIO(23 DOWNTO 16) <= GPIO(15 DOWNTO 8) OR GPIO( 7 DOWNTO 0);
        ELSIF (SW(1 DOWNTO 0) = "10") THEN
            GPIO(23 DOWNTO 16) <= GPIO(15 DOWNTO 8) AND GPIO( 7 DOWNTO 0);
        ELSE
            GPIO(23 DOWNTO 16) <= GPIO(15 DOWNTO 8) XOR GPIO( 7 DOWNTO 0);
        END IF;
    END PROCESS;
    
    GPIO(15 DOWNTO  0) <= (OTHERS => 'Z');

END Behavior;

