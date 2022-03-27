This demo shows how to simulate a PS/2 controller in the FPGA. The testbench
includes an emulated PS/2 keyboard that works with the DESim GUI to provide
input as if a real PS/2 keyboard was connected to the user circuit.


In this demo:

-- The PS/2 Keyboard sends a scan code to the FPGA when a key is typed into 
   the text box.
-- The FPGA sends a command to the PS/2 Keyboard and the Keyboard will 
   respond correspondingly. To set PS2 locks, send two consective commands.

     Command        code(FPGA)        response(PS/2)
      Echo             8'hEE              8'hEE

   set PS2 lock(1st)   8'hED              8'hFA

   set PS2 lock(2nd)   8'h1            turn Scroll Lock on
                       8'h2            turn Num Lock on
                       8'h4            turn Caps Lock on

   enable keyboard     8'hF4              8'hFA
   disable keyboard    8'hF5              8'hFA


-- SW are displayed on LEDR
-- KEY[0] is the synchronous reset
-- set a command to the keyboard using SW[7:0] 
-- send a command to the keyboard using KEY[1]
-- the last byte received from the keyboard is displayed on 
    HEX[1](higher 4 bits) and HEX[0] (lower 4 bits)



To use:
1. First press/release KEY[0] to reset the circuit
2. Type in PS/2 Keyboard
3. Set SW[7:0] to a command, press/release KEY[1] to send the command to the PS/2 Keyboard
