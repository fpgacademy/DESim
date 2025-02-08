-- Copyright (c) 2022 FPGAcademy
-- Please see license at https://github.com/fpgacademy/DESim

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- Reset with SW[0]. Clock counter and memory with KEY[0]
-- Each clock cycle reads a character from memory and shows it on the HEX displays
ENTITY Display IS 
    PORT ( 
        CLOCK  : IN  STD_LOGIC;
        RESETn : IN  STD_LOGIC;
        HEX0   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END Display;

ARCHITECTURE Behavior OF Display IS
    CONSTANT A : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"41";
    CONSTANT b : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"62";
    CONSTANT C : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"43";
    CONSTANT d : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"64";
    CONSTANT E : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"45";
    CONSTANT F : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"46";
    CONSTANT g : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"67";
    CONSTANT h : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"68";

    COMPONENT count3
        PORT ( 
            CLOCK  : IN  STD_LOGIC;
            RESETn : IN  STD_LOGIC;
            Q      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT inst_mem
        PORT ( 
            address : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            CLOCK   : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL address : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL count   : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL char    : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    address <= "00" & count;

    U1: count3   PORT MAP (CLOCK, RESETn, count);
    U2: inst_mem PORT MAP (address, CLOCK, char);
    LEDR <= "00" & char;

    PROCESS (char)
    BEGIN
        CASE char IS
            WHEN A      => HEX0 <= "0001000";
            WHEN b      => HEX0 <= "0000011";
            WHEN C      => HEX0 <= "1000110";
            WHEN d      => HEX0 <= "0100001";
            WHEN E      => HEX0 <= "0000110";
            WHEN F      => HEX0 <= "0001110";
            WHEN g      => HEX0 <= "0010000";
            WHEN h      => HEX0 <= "0001011";
            WHEN OTHERS => HEX0 <= "1111111";
        END CASE;
    END PROCESS;
END Behavior;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY count3 IS 
    PORT ( 
        CLOCK    : IN  STD_LOGIC;
        RESETn   : IN  STD_LOGIC;
        Q        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END count3;

ARCHITECTURE Behavior OF count3 IS
    SIGNAL count : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

    PROCESS (CLOCK)
    BEGIN
        IF (CLOCK'EVENT AND CLOCK = '1') THEN
            IF (RESETn = '0') THEN
                count <= (OTHERS => '0');
            ELSE
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;

    Q <= count;

END Behavior;

