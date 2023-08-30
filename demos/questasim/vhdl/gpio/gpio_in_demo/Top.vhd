-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        GPIO      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- DE-series 40-pin header
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX displays 
        HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX2      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX3      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0)
    );
END Top;

ARCHITECTURE Behavior OF Top IS
BEGIN

    HEX0 <= GPIO( 6 DOWNTO  0);
    HEX1 <= GPIO(14 DOWNTO  8);
    HEX2 <= GPIO(22 DOWNTO 16);
    HEX3 <= GPIO(30 DOWNTO 24);

    GPIO <= (OTHERS => 'Z');

END Behavior;

