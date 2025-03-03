-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- A multi-bit adder
ENTITY adder IS 
    PORT (
        Cin  : IN  STD_LOGIC;
        X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        S    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Cout : OUT STD_LOGIC
    );
END adder;

ARCHITECTURE Behavior OF adder IS
    SIGNAL sum : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN

    sum <= ('0' & X) + Y + Cin;     -- 5-bit result, with carry-out

    Cout <= sum(4);
    S <= sum(3 DOWNTO 0);

END Behavior;

