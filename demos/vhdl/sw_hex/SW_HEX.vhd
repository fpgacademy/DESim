-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- Uses SW to set HEX display patterns
--     SW are displayed on LEDR
--     KEY[0] is the synchronous reset. It sets the HEX-display selector to 0.
--     KEY[1] provides the active-low enable for the HEX-display selector
--     SW[9:7] selects a HEX display (from 0 to 5) 
ENTITY SW_HEX IS 
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
END SW_HEX;

ARCHITECTURE Behavior OF SW_HEX IS
    SIGNAL addr : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
BEGIN

    LEDR <= SW;

    PROCESS (CLOCK)
    BEGIN
        IF (CLOCK'EVENT AND CLOCK = '1') THEN
            IF (KEY(0) = '0') THEN
                addr <= (OTHERS => '0');
            ELSIF (KEY(1) = '0') THEN
                addr <= SW(9 DOWNTO 7);
            END IF;
        END IF;
    END PROCESS;

    PROCESS (CLOCK)
    BEGIN
        IF (CLOCK'EVENT AND CLOCK = '1') THEN
            CASE addr IS
                WHEN "000"  => HEX0 <= SW(6 DOWNTO 0);
                WHEN "001"  => HEX1 <= SW(6 DOWNTO 0);
                WHEN "010"  => HEX2 <= SW(6 DOWNTO 0);
                WHEN "011"  => HEX3 <= SW(6 DOWNTO 0);
                WHEN "100"  => HEX4 <= SW(6 DOWNTO 0);
                WHEN "101"  => HEX5 <= SW(6 DOWNTO 0);
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    END PROCESS;

END Behavior;

