# DESim Backend

The backend dynamic link library (DLL) for DESim using QuestaSim's Verilog Procedural Interface (VPI) to connect DESim's frontend to circuit's being simulated in QuestaSim. If the backend needs to be rebuilt, follow the steps below. 

## Rebuilding the DESim Backend on Windows

1. The backend was compiled using the MinGW gcc/g++ compiler that comes with QuestaSim.
    1. Add this compiler to the Path environment variable.
        * For example, our path to the compiler was "C:\intelFPGA\21.1\questa_fse\gcc-7.4.0-mingw64vc15\bin"
2. Check that the vpi_user.h and vpi_compatibility.h files in the include directory are up-to-date.
3. Copy the mtipli.lib file from QuestaSim's directory into the lib directory.
4. Run WindowsMakeClean.bat
5. Run WindowsMake.bat
6. Run WindowsMakeUpdateDemos.bat

## Rebuilding the DESim Backend on Linux

1. The backend was compiled using the "build-essential" package on Ubuntu 20.04
    1. To get this package, run the following command: 'sudo apt install build-essential'
2. Check that the vpi_user.h and vpi_compatibility.h files in the include directory are up-to-date.
3. Copy the mtipli.lib file from QuestaSim's directory into the lib directory.
4. Run 'make clean'
5. Run 'make'
6. Run 'make update_demos'
