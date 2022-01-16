:: Windows batch script
:: To compile the DESim software's backend
::
:: This script uses MinGW64's gcc and g++ which comes with QuestaSim
:: Make sure that MinGW64's bin folder is in the PATH environment variable
:: For example: C:\intelFPGA\21.1\questa_fse\gcc-7.4.0-mingw64vc15\bin
::
:: To compile the backend for Linux see the Makefile in this folder

@ECHO OFF
TITLE Building DESim's backend

set questasim_dir=C:\intelFPGA\21.1\questa_fse\

set CFLAGS=-m64 -static -c -Wall -g -fno-diagnostics-show-caret -fpic -Iinclude -I%questasim_dir%include
set LDFLAGS=-m64 -static -g -shared -lmtipli -lws2_32 -L%questasim_dir%win64

@ECHO ON
gcc utils.c %CFLAGS%
g++ fpga_output_device.cpp %CFLAGS%
g++ fpga_input_device.cpp %CFLAGS%
g++ fpga_inout_device.cpp %CFLAGS%
g++ keyboard_input.cpp %CFLAGS%
g++ fpga.cpp %CFLAGS%
g++ sim_task.cpp %CFLAGS%
g++ -o dist/simfpga.vpi fpga_inout_device.o keyboard_input.o fpga_input_device.o fpga_output_device.o fpga.o sim_task.o utils.o %LDFLAGS%

@ECHO OFF
PAUSE
