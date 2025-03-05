-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);  -- DE-series HEX displays 
        HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX2      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX3      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX4      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        HEX5      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
        LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series LEDs 

        ps2_clk   : IN    STD_LOGIC;                      -- PS/2 Clock
        ps2_dat   : IN    STD_LOGIC                       -- PS/2 Data
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT ps2_demo
        PORT ( 
            CLOCK_50  : IN    STD_LOGIC;
            KEY       : IN    STD_LOGIC_VECTOR( 0 DOWNTO 0);
            ps2_clk   : IN    STD_LOGIC;
            ps2_dat   : IN    STD_LOGIC;
            LEDR      : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);
            HEX0      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX1      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX2      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX3      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX4      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0);
            HEX5      : OUT   STD_LOGIC_VECTOR( 6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    U1: ps2_demo PORT MAP (CLOCK_50, KEY(0 DOWNTO 0), ps2_clk, ps2_dat, LEDR, 
                           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

END Behavior;

