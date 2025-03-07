-- Copyright (c) 2020 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        VGA_X     : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- VGA column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( 8 DOWNTO 0);  -- VGA row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0);  -- VGA pixel color
        plot      : OUT   STD_LOGIC                       -- VGA control
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT vga_demo
        PORT ( 
            CLOCK_50  : IN    STD_LOGIC;                     
            KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0); 
            VGA_X     : OUT   STD_LOGIC_VECTOR( 8 DOWNTO 0); 
            VGA_Y     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0); 
            VGA_COLOR : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0); 
            plot      : OUT   STD_LOGIC                      
        );
    END COMPONENT;
    SIGNAL Resetn : STD_LOGIC;
BEGIN

    VGA_X(9) <= '0';
    VGA_Y(8) <= '0';
    U1: vga_demo PORT MAP (CLOCK_50, KEY, VGA_X(8 DOWNTO 0), VGA_Y(7 DOWNTO 0), VGA_COLOR, plot);

END Behavior;

