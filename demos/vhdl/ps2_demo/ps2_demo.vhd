LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- Copyright (c) 2020 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

-- Protect against undefined nets

-- This entirty uses PS2_CLK and PS2_DAT to capture scancodes received from the PS/2 keyboard. The
-- last three scancodes received are always displayed on HEX6 - HEX0. Each time a scancode is 
-- received, a counter called Total is incremented and displayed on LEDR. 
ENTITY ps2_demo IS
    PORT (
            CLOCK_50  : IN    STD_LOGIC;
            KEY       : IN    STD_LOGIC_VECTOR( 0 DOWNTO 0);
            PS2_CLK   : IN    STD_LOGIC;
            PS2_DAT   : IN    STD_LOGIC;
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
    COMPONENT sync IS
        PORT (
            D             : IN  STD_LOGIC;
            Resetn, Clock : IN  STD_LOGIC;
            Q             : OUT STD_LOGIC
         );
    END COMPONENT;
    COMPONENT regn IS
        GENERIC (n : INTEGER := 8);
        PORT (
            R                : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            Resetn, E, Clock : IN  STD_LOGIC;
            Q                : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT hex7seg
        PORT (
            hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Resetn          : STD_LOGIC := '1';
    SIGNAL negedge_ps2_clk : STD_LOGIC := '0';

    -- Declare shift register to hold the PS/2 data packets. Each one has 11 bits: 
    --    STOP (1) PARITY d7 d6 d5 d4 d3 d2 d1 d0 START (0)
    --    The most-recent three data packets received are saved
    SIGNAL Serial   : STD_LOGIC_VECTOR(32 DOWNTO 0) := (OTHERS => '0'); 
    -- Packet is used to know each time that 11 bits have been received
    SIGNAL Packet   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- Total is used to count total PS/2 keys pressed
    SIGNAL Total    : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    -- used to save the current PS/2 scancode
    SIGNAL scancode : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');            
    -- ps2_rec is set to 1 for one clock cycle when a PS/2 scancode has been received
    SIGNAL ps2_rec : STD_LOGIC := '0';                   

    -- ps2_clk value in the previous CLOCK_50 clock cycle
    SIGNAL prev_ps2_clk : STD_LOGIC := '0';  
    -- PS2 signals synchronized to CLOCK_50
    SIGNAL PS2_CLK_S : STD_LOGIC := '0';
    SIGNAL PS2_DAT_S : STD_LOGIC := '0'; 
BEGIN
    Resetn <= KEY(0);

    -- synchronize the PS/2 signals with CLOCK_50
    S3: sync PORT MAP (PS2_CLK, Resetn, CLOCK_50, PS2_CLK_S);
    S4: sync PORT MAP (PS2_DAT, Resetn, CLOCK_50, PS2_DAT_S);
    
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            prev_ps2_clk <= PS2_CLK_S;
        END IF;
    END PROCESS;

    -- check when ps2_clk has changed from 1 to 0
    negedge_ps2_clk <= (prev_ps2_clk AND (NOT PS2_CLK_S));

    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (Resetn = '0') THEN
                Serial <= (OTHERS => '0');
            ELSIF (negedge_ps2_clk = '1') THEN
                Serial(31 DOWNTO 0) <= Serial(32 DOWNTO 1);
                Serial(32) <= PS2_DAT_S;
            END IF;
        END IF;
    END PROCESS;

    -- count ps2_clk cycles (equivalent to counting data bits received)
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF ((Resetn = '0') OR (Packet = "1011")) THEN
                Packet <= "0000";
            ELSIF (negedge_ps2_clk = '1') THEN
                Packet <= Packet + 1;
            END IF;
        END IF;
    END PROCESS; 

    -- PS/2 key press makes scancode/release/scancode.  Key repeat makes scancode/scancode/...
    -- So we check for Serial[30:23] == Serial[8:1]
    ps2_rec <= 
        '1' WHEN ((Packet = "1011") AND (Serial(30 DOWNTO 23) = Serial(8 DOWNTO 1))) ELSE '0';
    
    -- last received PS/2 scancode is in Serial[8:1]
    USC: regn PORT MAP (Serial(8 DOWNTO 1), Resetn, ps2_rec, CLOCK_50, scancode);
    
    -- keep track of total number of PS/2 key-presses received
    PROCESS (CLOCK_50)
    BEGIN
        IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
            IF (Resetn = '0') THEN
                Total <= (OTHERS => '0');
            ELSIF (ps2_rec = '1') THEN
                Total <= Total + 1;
            END IF;
        END IF;
    END PROCESS;
    
    LEDR <= Total;
    H0: hex7seg PORT MAP (scancode(3 DOWNTO 0), HEX0);
    H1: hex7seg PORT MAP (scancode(7 DOWNTO 4), HEX1);
    H2: hex7seg PORT MAP (Serial(15 DOWNTO 12), HEX2);
    H3: hex7seg PORT MAP (Serial(19 DOWNTO 16), HEX3);
    H4: hex7seg PORT MAP (Serial(26 DOWNTO 23), HEX4);
    H5: hex7seg PORT MAP (Serial(30 DOWNTO 27), HEX5);
end Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- syncronizer, implemented as two FFs in series
ENTITY sync IS
    PORT (
        D             : IN  STD_LOGIC;
        Resetn, Clock : IN  STD_LOGIC;
        Q             : OUT STD_LOGIC
    );
END sync;

ARCHITECTURE Behavior OF sync IS
    SIGNAL Qi : STD_LOGIC; -- internal node
BEGIN
    PROCESS (Clock)
    BEGIN
        IF (Clock'EVENT AND Clock = '1') THEN
            IF (Resetn = '0') THEN
                Qi <= '0';
                Q <= '0';
            ELSE
                Qi <= D;
                Q <= Qi;
            END IF;
        END IF;
    END PROCESS;

END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- n-bit register with enable
ENTITY regn IS
    GENERIC (n : INTEGER := 8);
    PORT (
        R                : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        Resetn, E, Clock : IN  STD_LOGIC;
        Q                : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END regn;

ARCHITECTURE Behavior OF regn IS
BEGIN
    PROCESS (Clock)
    BEGIN
        IF (Clock'EVENT AND Clock = '1') THEN
            IF (Resetn = '0') THEN
                Q <= (OTHERS => '0');
            ELSIF (E = '1') THEN
                Q <= R;
            END IF;
        END IF;
    END PROCESS;
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
