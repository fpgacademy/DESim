To use this demo:

-- The clock input is created by toggling KEY[0]
-- The active-low synchronous reset input is SW[0]

The circuit displays "characters" stored in a ROM on HEX0.
To use the circuit:

1. Set SW[0] to 0 to allow the circuit to be reset
2. pulse KEY[0] down/up to make a clock cycle
    -- the character 'A', the first character stored
	    in the ROM should be displayed on HEX0 
3. Set SW[0] to 1 so that the reset is not active
4. pulse KEY[0] down/up to make a clock cycle
5. pulse KEY[0] down/up to make a clock cycle
    -- HEX0 should now show 'b', the next character 
	    stored in the ROM
6. pulse KEY[0] down/up to make a clock cycle
    -- HEX0 should now show 'C', the next character 
	    stored in the ROM
7. etc (there are eight characters stored in the ROM)
