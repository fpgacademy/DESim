This sample project reads ASCII values from a ROM and displays
these values on the LEDs. It also displays the corresponding 
characters on HEX0. Values for A, b, C, d, E, F, g, h are stored
in the memory.  In this demo:
   -- The active-low synchronous reset input is SW[0]
   -- The clock input is created by toggling KEY[0]

To use:
1. Set SW[0] to 0 (reset)
2. pulse KEY[0] down/up to make a clock cycle
   -- the character 'A', the first character stored in the ROM
      should be displayed on HEX0 
3. Set SW[0] to 1 so that the reset is not active
4. pulse KEY[0] down/up to make a clock cycle
5. pulse KEY[0] down/up to make a clock cycle
   -- HEX0 should now show 'b'
6. pulse KEY[0] down/up to make a clock cycle
   -- HEX0 should now show 'C'
7. etc (there are eight characters stored in the ROM)
