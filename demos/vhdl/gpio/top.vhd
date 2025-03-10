-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY top IS
    PORT (
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        GPIO      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)   -- DE-series 40-pin header
    );
END top;

ARCHITECTURE Behavior OF top IS
    COMPONENT gpio_demo
        PORT (
            SW   : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);
            GPIO : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;      
BEGIN

    U1: gpio_demo PORT MAP (SW, GPIO);

END Behavior;

