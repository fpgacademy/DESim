-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- This module represents an accumulator controlled by a down-counter.  The data being 
-- accumulated is from the SW[4:0] switches. Resetn is the active-low synchronous reset/load
-- input. When Resetn is low the sum is cleared to 0 and the counter is loaded from 
-- switches SW[9:5]. When Resetn is high the circuit accumulates each clock cycle until 
-- the counter reaches 0
ENTITY accumulate IS 
    PORT ( 
        Clock  : IN  STD_LOGIC;
        Resetn : IN  STD_LOGIC;
        SW     : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END accumulate;

ARCHITECTURE Behavior OF accumulate IS
    SIGNAL count : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sum   : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x, y  : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL z     : STD_LOGIC := '0';
BEGIN

    x <= SW(4 DOWNTO 0);
    y <= SW(9 DOWNTO 5);

    -- the accumulator
    PROCESS (Clock)
    BEGIN
        IF (Clock'EVENT AND Clock = '1') THEN
            IF (Resetn = '0') THEN
                sum <= (OTHERS => '0');
            ELSIF (z = '1') THEN
                sum <= sum + x;
            END IF;
        END IF;
    END PROCESS;

    -- the counter
    PROCESS (Clock)
    BEGIN
        IF (Clock'EVENT AND Clock = '1') THEN
            IF (Resetn = '0') THEN
                count <= Y;
            ELSIF (z = '1') THEN
                count <= count - 1;
            END IF;
        END IF;
    END PROCESS;

    z    <= count(4) OR count(3) OR count(2) OR count(1) OR count(0);
    LEDR <= sum;

END Behavior;

