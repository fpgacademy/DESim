The KEYs and SW are used to change the HEX displays.

In this demo:

-- SW are displayed on LEDR
-- KEY[0] is the synchronous reset. It sets the HEX-display selector to 0.
-- KEY[1] provides the active-low enable for the HEX-display selector

To use:
1. First press/release KEY[0] to reset the circuit; HEX0 is selected
   -- HEX0 can be changed using SW[6:0]
2. Set SW[9:7] to select a different HEX display (from 0 to 5) 
   -- press/release KEY[1] to store the selected HEX address
   -- the selected HEX display can now be changed using SW[6:0]
3. Set SW[9:7] to select another display, etc.
