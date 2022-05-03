:: Copyright (c) 2022 FPGAcademy
:: Please see license at https://github.com/fpgacademy/DESim
::
:: Windows batch script
:: To compile the DESim software's backend
::
:: This script uses MinGW64's gcc and g++ which comes with Questa
:: or MinGW32's gcc and g++ which was downloaded from:
::   https://osdn.net/projects/mingw/downloads/68260/mingw-get-setup.exe/
:: Make sure that Questa/ModelSim and MinGW64/MinGW32 paths are set correctly
::   below before running this script.
::
:: To compile the backend for Linux see the Makefile in this folder

@ECHO OFF
TITLE Building DESim's backend


:: Choose to compile the backend for ModelSim or Questa
:select
ECHO Select simulator to target
ECHO 1) ModelSim
ECHO 2) Questa
SET /P t=?
IF /I "%t%" EQU "1" GOTO :ModelSim
IF /I "%t%" EQU "2" GOTO :Questa
GOTO :select


:: Init for ModelSim compilation
:ModelSim
set simulator=modelsim
set simulator_dir=C:\intelFPGA\21.1\modelsim_ase\
set mingw_dir=C:\MinGW\bin

set CFLAGS=-m32 -static -c -Wall -g -Iinclude -I%simulator_dir%include
set LDFLAGS=-m32 -static -g -shared -lmtipli -lws2_32 -L%simulator_dir%win32aloem
GOTO :build


:: Init for Questa compilation
:Questa
set simulator=questa
set simulator_dir=C:\intelFPGA\21.1\questa_fse\
set mingw_dir=%simulator_dir%gcc-7.4.0-mingw64vc15\bin

set CFLAGS=-m64 -static -c -Wall -g -fno-diagnostics-show-caret -fpic -Iinclude -I%simulator_dir%include
set LDFLAGS=-m64 -static -g -shared -lmtipli -lws2_32 -L%simulator_dir%win64
GOTO :build


:: Compile the backend
:build
set PATH=%mingw_dir%;%PATH%

@ECHO ON
gcc utils.c %CFLAGS%
g++ fpga_output_device.cpp %CFLAGS%
g++ fpga_input_device.cpp %CFLAGS%
g++ fpga_inout_device.cpp %CFLAGS%
g++ keyboard_input.cpp %CFLAGS%
g++ fpga.cpp %CFLAGS%
g++ sim_task.cpp %CFLAGS%

mkdir dist\%simulator%
g++ -o dist/%simulator%/simfpga.vpi fpga_inout_device.o keyboard_input.o fpga_input_device.o fpga_output_device.o fpga.o sim_task.o utils.o %LDFLAGS%

@ECHO OFF
PAUSE
