# DESim Backend

The backend dynamic link library (DLL) for DESim using ModelSim/Questa's 
Verilog Procedural Interface (VPI) to connect DESim's frontend to circuit's 
being simulated. If the backend needs to be rebuilt, follow the steps below. 

## Rebuilding the DESim Backend on Windows

1. Check that MinGW gcc/g++ is working
    1. Questa: used MinGW that came with Questa
        * For example, our path to the compiler was "C:\intelFPGA\21.1\questa_fse\gcc-7.4.0-mingw64vc15\bin"
    1. ModelSim: use MinGW that was downloaded from the internet
        * For example, our path to the compiler was "C:\MinGW\bin"
2. Check that the ModelSim/Questa/MinGW paths in WindowMake.bat reflect those on your computer
3. Run WindowsMakeClean.bat
4. Run WindowsMake.bat
5. Run WindowsMakeRelease.bat

## Rebuilding the DESim Backend on Linux

1. The backend was compiled using the "build-essential" package on Ubuntu 20.04
    1. To get this package, run the following command: 'sudo apt install build-essential'
2. Check that the ModelSim/Questa paths in the Makefile reflect those on your computer
3. Run 'make clean'
4. Run 'make' or 'make SIMULATOR=modelsim'
5. Run 'make release' or 'make SIMULATOR=modelsim release'
