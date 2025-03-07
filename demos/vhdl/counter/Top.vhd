-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        CLOCK_50 : IN  STD_LOGIC;                      -- 50 MHz clock signal
        KEY      : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- pushbuttons
        SW       : IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- slide switches
        LEDR     : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0)   -- LEDs 
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT counter
        PORT ( 
            Clock  : IN STD_LOGIC;
            Resetn : IN STD_LOGIC;
            En     : IN STD_LOGIC;
            LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Resetn : STD_LOGIC := '1';
    SIGNAL En : STD_LOGIC := '0';
BEGIN

    Resetn <= KEY(0);
    En <= SW(0);

    U1: counter PORT MAP (CLOCK_50, Resetn, En, LEDR);

END Behavior;

