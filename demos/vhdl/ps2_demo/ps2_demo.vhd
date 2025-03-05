-- Copyright (c) 2020 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

-- This module uses ps2_clk and ps2_dat to capture the last three bytes of data received 
-- from the PS/2 keyboard. It displays this data on the HEX displays, and also displays the
-- last byte of data received, along with its PARITY bit, on LEDR.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ps2_demo IS
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
END ps2_demo;

ARCHITECTURE Behavior OF ps2_demo IS
    COMPONENT hex7seg
        PORT (
            hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Resetn          : STD_LOGIC := '1';
    SIGNAL negedge_ps2_clk : STD_LOGIC := '0';

    -- Declare shift register to hold the PS/2 data packets. Each one has 11 bits: 
    --     STOP (1) PARITY d7 d6 d5 d4 d3 d2 d1 d0 START (0)
    SIGNAL Serial          : STD_LOGIC_VECTOR(32 DOWNTO 0) := (OTHERS => '0'); 
    SIGNAL prev_ps2_clk    : STD_LOGIC := '0'; -- ps2_clk in the previous CLOCK_50 cycle
BEGIN

    Resetn <= KEY(0);

    -- record previous ps2_clk 
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            prev_ps2_clk <= ps2_clk;
        END IF;
    END PROCESS;

    -- check when ps2_clk has changed from 1 to 0
    negedge_ps2_clk <= prev_ps2_clk AND (NOT ps2_clk);

    -- the shift register
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (Resetn = '0') THEN
                Serial <= (OTHERS => '0');
            ELSIF (negedge_ps2_clk = '1') THEN
                Serial(31 DOWNTO 0) <= Serial(32 DOWNTO 1);
                Serial(32) <= ps2_dat;
            END IF;
        END IF;
    END PROCESS;

    LEDR <= Serial(32 DOWNTO 23);        -- STOP, PARITY, Data for the last byte received

    H0: hex7seg PORT MAP (Serial(4 DOWNTO 1), HEX0);
    H1: hex7seg PORT MAP (Serial(8 DOWNTO 5), HEX1);
    H2: hex7seg PORT MAP (Serial(15 DOWNTO 12), HEX2);
    H3: hex7seg PORT MAP (Serial(19 DOWNTO 16), HEX3);
    H4: hex7seg PORT MAP (Serial(26 DOWNTO 23), HEX4);
    H5: hex7seg PORT MAP (Serial(30 DOWNTO 27), HEX5);

END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY hex7seg IS
    PORT (
        hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END hex7seg;

ARCHITECTURE Behavior OF hex7seg IS
    -- 
    --        0  
    --       ---  
    --      |   |
    --     5|   |1
    --      | 6 |
    --       ---  
    --      |   |
    --     4|   |2
    --      |   |
    --       ---  
    --        3  
    -- 
BEGIN
    PROCESS (hex)
    BEGIN
        CASE hex IS
            WHEN "0000" => display <= "1000000";
            WHEN "0001" => display <= "1111001";
            WHEN "0010" => display <= "0100100";
            WHEN "0011" => display <= "0110000";
            WHEN "0100" => display <= "0011001";
            WHEN "0101" => display <= "0010010";
            WHEN "0110" => display <= "0000010";
            WHEN "0111" => display <= "1111000";
            WHEN "1000" => display <= "0000000";
            WHEN "1001" => display <= "0011000";
            WHEN "1010" => display <= "0001000";
            WHEN "1011" => display <= "0000011";
            WHEN "1100" => display <= "1000110";
            WHEN "1101" => display <= "0100001";
            WHEN "1110" => display <= "0000110";
            WHEN "1111" => display <= "0001110";
            WHEN OTHERS => display <= "XXXXXXX";
        END CASE;
    END PROCESS;

END Behavior;
