-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- A multi-bit adder
ENTITY Addern IS 
    GENERIC (
        n    : INTEGER := 4
    );
    PORT (
        Cin  : IN  STD_LOGIC;
        X, Y : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        Sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        Cout : OUT STD_LOGIC
    );
END Addern;

ARCHITECTURE Behavior OF Addern IS
    SIGNAL z : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN

    z    <= ('0' & X) + Y + Cin;

    Cout <= z(n);
    Sum  <= z(n-1 DOWNTO 0);

END Behavior;

