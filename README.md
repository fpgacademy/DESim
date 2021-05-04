# DESim

## 1 Introduction (v1.0)
The DESim tool is an interactive graphical user interface showing features of a DE-Series board, such as switches, lights, and displays. The tool interfaces with the ModelSim simulation software. The simulation results affect the lights and displays in the GUI, as opposed to showing the waveforms corresponding to the signals being simulated.

The DESim tool has three parts:
1) The frontend graphical user interface
2) The backend simulator interface
3) Various demos showcasing the different capabilities of the tool

The DESim tool requires the ModelSim HDL simuator. Preferably, one of the ModelSim-Intel FPGA editions, which has the Intel FPGA IP Core simulation models built-in.

## 2 Installation
### 2.1 Software requirements
1. ModelSim (Intel FPGA starter edition 10.5b, available at https://fpgasoftware.intel.com/19.1/?edition=lite&platform=windows) . Note go to individual files and you can download Modelsim separately. No libraries are needed.

2. Navigate to the DESim installer URL: https://github.com/fpgacademy/DESim/releases

3. Run the desim_setup.exe installer on Windows. There is no Linux support at this time.

   

## 3 Running Projects on the DESim console
### 3.1 Run a sample project
1. Open the DESim application.

2. Click the Open Project button and select the folder for the project of interest.

3. Click on compile testbench.

4. Click on Start Simulation and interact with your design with through push buttons and switches, and view your results on the LED and seven segment display. Each demonstration includes a readme.txt under: 

   <Install directory>/demos/<project>/readme.txt to explain how to interact with the project.

5. Click on Stop Simulation and Reset Signals to test other projects.

 

### 3.2 Create a new project
1. Using File Explorer, or other suitable means within Windows, make a copy of the `led_demo` folder, including the `sim` subfolder.
2. Under your new folder, open `hello.v` and add new modules in it. Other project files can be added in the same folder as `hello.v` Note that all files will be compiled in that folder so if you have two modules with the same name in your project, the latest one compiled will be referenced. You can adjust what gets compiled by modifying the`sim/demo.bat` vlog commands.
3. Save `hello.v` and associated submodules, and you can now run your project.  

Note: Please set the default nettype of all project files to none. (i.e. add "`default_nettype none" to all project files)

4. Keep in mind that the state of signals and registers are unknown using the simulator. If you dont get the results you are expecting, consider adding an initial block in your RTL block to set registers to a known reset state, or add a reset signal.



## 4 Testbench Considerations

### 4.1 Modify time precision of simulation
Time precision is set to `1ns/1ns` in `tb.v` and `hello.v`. You may modify the time precision and time scale based on your need.

### 4.2 Relation of simulation speed to actual hardware

Simulators take considerably more real time to produce results than actual FPGA hardware. The default clock in the testbench is 50 MHz . If you need a divided clock to trigger at 1 Hz you would divide the 50 MHz clock by 50,000,000. However, the simulator takes considerably longer to run and is roughly takes 4000x as long so you need to consider that 50 Mhz clock triggers 50 million times per second on FPGA hardware would only trigger 12,000 times per second on the simulator. Consider clock divide ratios carefully so your simulation will run in a reasonable amount of time.

