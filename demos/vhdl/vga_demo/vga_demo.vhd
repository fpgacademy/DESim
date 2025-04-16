-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY vga_demo IS
    GENERIC (n : INTEGER := 9;      -- VGA x address bits
             Mn : INTEGER := 15);   -- video memory address bits
    PORT (
        CLOCK_50  : IN    STD_LOGIC;                      -- DE-series 50 MHz clock signal
        KEY       : IN    STD_LOGIC_VECTOR( 3 DOWNTO 0);  -- DE-series pushbuttons
        HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        VGA_X     : OUT   STD_LOGIC_VECTOR( n-1 DOWNTO 0);  -- "VGA" column
        VGA_Y     : OUT   STD_LOGIC_VECTOR( n-2 DOWNTO 0);  -- "VGA" row
        VGA_COLOR : OUT   STD_LOGIC_VECTOR(23 DOWNTO 0);  -- "VGA pixel" colour
        plot      : OUT   STD_LOGIC                       -- "Pixel" is drawn when this is pulsed
    );
END vga_demo;

ARCHITECTURE Behavior OF vga_demo IS
    COMPONENT hex7seg
        PORT (
            hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT inst_mem
        PORT ( 
            address : IN  STD_LOGIC_VECTOR(14 DOWNTO 0);
            CLOCK   : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT address_translator
        GENERIC (n : INTEGER := 9;      -- VGA x address bits
                 Mn : INTEGER := 15);   -- video memory address bits
        PORT (
            x           : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            y           : IN  STD_LOGIC_VECTOR(n-2 DOWNTO 0);
            mem_address : OUT STD_LOGIC_VECTOR(Mn-1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL x      : STD_LOGIC_VECTOR( n-1 DOWNTO 0);
    SIGNAL y      : STD_LOGIC_VECTOR( n-2 DOWNTO 0);
    SIGNAL ramp   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL color  : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"FF0000";
    SIGNAL Resetn : STD_LOGIC := '1';

    SIGNAL x_add     : STD_LOGIC_VECTOR( n-1 DOWNTO 0);     -- video memory column
    SIGNAL y_add     : STD_LOGIC_VECTOR( n-2 DOWNTO 0);     -- video memory row
    SIGNAL address   : STD_LOGIC_VECTOR( Mn-1 DOWNTO 0);    -- video memory address
    SIGNAL MIF_color : STD_LOGIC_VECTOR( 11 DOWNTO 0);      -- video memory pixel

    constant COLS : INTEGER := 160;
    constant ROWS : INTEGER := 120;
    constant STEP : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"000011";
    constant STEP_8 : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"001100";
    constant STEP_16 : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"110000";
    
BEGIN

    Resetn  <= KEY(0);

    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (Resetn = '0') THEN
                x     <= conv_std_logic_vector(COLS / 4, x'length);
                y     <= conv_std_logic_vector(ROWS / 4, y'length);
                ramp  <= "000";
                color <= X"FF0000";
            ELSE
            -- Code to generate rainbow colors.
            -- Algorithm is to set (two colors at a time) in RBG in this manner:

            -- RRRRG-RGGGG-GGGGB-GBBBB-BBBBR-BRRRR     saturation level
            --    G   R       B   G       R   B   
            --   G     R     B     G     R     B
            --  G       R   B       G   R       B
            -- GBBBB-BBBBR-BRRRR-RRRRG-RGGGG-GGGGB     0 level
                -- IF (x = "100111111") THEN
                IF (x = COLS - (COLS / 4)) THEN
                    x <= conv_std_logic_vector(COLS / 4, x'length);
                    IF (y = ROWS - (ROWS / 4)) THEN
                        y <= conv_std_logic_vector(ROWS / 4, y'length);
                        IF (ramp = "000") THEN
                            IF (color /= X"FFFF00") THEN
                                color <= color + (STEP_8);
                            ELSE
                                ramp <= ramp + "001";
                                color <= color - (STEP_16);
                            END IF;
                        ELSIF (ramp = "001") THEN
                            IF (color /= X"00FF00") THEN
                                color <= color - (STEP_16);
                            ELSE
                                ramp <= ramp + "001";
                                color <= color + STEP;
                            END IF;
                        ELSIF (ramp = "010") THEN
                            IF (color /= X"00FFFF") THEN
                                color <= color + STEP;
                            ELSE
                                ramp <= ramp + "001";
                                color <= color - STEP_8;
                            END IF;
                        ELSIF (ramp = "011") THEN
                            IF (color /= X"0000FF") THEN
                                color <= color - STEP_8;
                            ELSE
                                ramp <= ramp + "001";
                                color <= color + STEP_16;
                            END IF;
                        ELSIF (ramp = "100") THEN
                            IF (color /= X"FF00FF") THEN
                                color <= color + STEP_16;
                            ELSE
                                ramp <= ramp + "001";
                                color <= color - STEP;
                            END IF;
                        ELSIF (ramp = "101") THEN
                            IF (color /= X"FF0000") THEN
                                color <= color - STEP;
                            ELSE
                                ramp <= ramp + "001";
                            END IF;
                        END IF;
                    ELSE
                        y <= y + 1;
                    END IF;
                ELSE
                    x <= x + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    H0: hex7seg PORT MAP (color(3 DOWNTO 0), HEX0);
    H1: hex7seg PORT MAP (color(7 DOWNTO 4), HEX1);
    H2: hex7seg PORT MAP (color(11 DOWNTO 8), HEX2);
    H3: hex7seg PORT MAP (color(15 DOWNTO 12), HEX3);
    H4: hex7seg PORT MAP (color(19 DOWNTO 16), HEX4);
    H5: hex7seg PORT MAP (color(23 DOWNTO 20), HEX5);

    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (ramp < "110") THEN
                x_add <= (OTHERS => '0');
                y_add <= (OTHERS => '0');
            ELSE
                IF (x_add < COLS) THEN
                    x_add <= x_add + 1;
                ELSIF (y_add < ROWS) THEN
                    y_add <= y_add + 1;
                    x_add <= (OTHERS => '0');
                END IF;
             END IF;
         END IF;
    END PROCESS;

    A0: address_translator PORT MAP (x_add, y_add, address);

    M0: inst_mem PORT MAP (address, CLOCK_50, MIF_color);

    -- display either individual colors, or the MIF rainbow of colors. The MIF has 12-bit
    -- colors, so these are converted to 24-bit colors
    VGA_X <= x WHEN (ramp < "110") ELSE x_add;
    VGA_Y <= y WHEN (ramp < "110") ELSE y_add;
    VGA_COLOR <= color WHEN (ramp < "110") ELSE 
        (MIF_color(11 DOWNTO 8) & MIF_color(11 DOWNTO 8) &
         MIF_color(7 DOWNTO 4) & MIF_color(7 DOWNTO 4) &
         MIF_color(3 DOWNTO 0) & MIF_color(3 DOWNTO 0));

    plot <= '1';

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

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY address_translator IS
    GENERIC (n : INTEGER := 9;      -- VGA x address bits
             Mn : INTEGER := 15);   -- video memory address bits
    PORT (
        x           : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        y           : IN  STD_LOGIC_VECTOR(n-2 DOWNTO 0);
        mem_address : OUT STD_LOGIC_VECTOR(Mn-1 DOWNTO 0)
    );
END address_translator;

ARCHITECTURE Behavior OF address_translator IS
BEGIN

    mem_address <= (y & "0000000") + ('0' & y & "00000") + ('0' & x);
                  
END Behavior;
