-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Top IS
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        SW        : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0);  -- DE-series switches
        GPIO      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)   -- DE-series 40-pin header
    );
END Top;

ARCHITECTURE Behavior OF Top IS
    SIGNAL gpio_comb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL gpio_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    GPIO <= gpio_comb;

    PROCESS (SW, gpio_reg)
    BEGIN
        gpio_comb <= gpio_reg;
        CASE SW(9 DOWNTO 8) IS
            WHEN "00"   => gpio_comb( 7 DOWNTO  0) <= SW(7 DOWNTO 0);
            WHEN "01"   => gpio_comb(15 DOWNTO  8) <= SW(7 DOWNTO 0);
            WHEN "10"   => gpio_comb(23 DOWNTO 16) <= SW(7 DOWNTO 0);
            WHEN "11"   => gpio_comb(31 DOWNTO 24) <= SW(7 DOWNTO 0);
            WHEN OTHERS => NULL;
        END CASE;
    END PROCESS;
    
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (KEY(0) = '0') THEN
                gpio_reg <= (OTHERS => '0');
            ELSE
                CASE SW(9 DOWNTO 8) IS
                    WHEN "00"   => gpio_reg( 7 DOWNTO  0) <= SW(7 DOWNTO 0);
                    WHEN "01"   => gpio_reg(15 DOWNTO  8) <= SW(7 DOWNTO 0);
                    WHEN "10"   => gpio_reg(23 DOWNTO 16) <= SW(7 DOWNTO 0);
                    WHEN "11"   => gpio_reg(31 DOWNTO 24) <= SW(7 DOWNTO 0);
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

END Behavior;

