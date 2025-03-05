This demo shows how you can emulate a PS/2 keyboard using DESim. The demo provides 
ps2_clk and ps2_dat waveforms that are the same as those that would be provided if 
pressing keyboard keys on a real PS/2 keyboard. 

The PS/2 keyboard is emulated using a combination of the DESim GUI and the Verilog code
in the file PS2_keyboard.v, which is included in the testbench (tb) folder.  When you
enter keystrokes into the DESim GUI (using the PS/2 Keyboard pane), the GUI sends
corresponding PS/2 scan-code bytes to the testbench. These scan-code bytes are
stored in a FIFO within the PS2_keyboard module. It then converts each scan code into
serial PS/2 data (ps2_dat) and clk (ps2_clk) signals via the ps2_clk_dat.v Verilog
code, which is also included in the testbench folder.  

In addition to instantiating the PS2_keyboard module, the testbench instantiates the 
Verilog nodule named top which provides the ps2_clk and ps2_dat signals to the 
user-level module for this DESim project. The user-level module, instantiated in the 
user-level top.v code, is called ps2_demo.  It uses the ps2_clk and ps2_dat waveforms
to extract the scan codes and stores them into a shift register. The results are 
displayed on both the HEX displays and LEDR lights.  The timing of signals in ps2_clk 
and ps2_dat provided in this demo are the same as those that would generated if using
an actual PS/2 keyboard connected to a DE-series board. 

To use this demo:
1. First press/release KEY(0) to reset the circuit
2. Type a key within the "PS/2 Keyboard" pane of the DESim GUI. The corresponding scan 
   codes generated (for supported keys) will be shown in the DESim GUI and also on the
   HEX displays and LEDR lights. 

We also provide a ModelSim folder with this demo. Although this folder is not used at
all in the DESim project, you can run ModelSim (or Questa) in this folder to see 
examples of ps2_clk and ps2_dat waveforms. The scan codes for this simulation are 
specified in the testbench within the ModelSim folder. 

