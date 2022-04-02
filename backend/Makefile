# Copyright (c) 2020 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim
#
# Linux Makefile for the DESim software's backend
# To compile the backend for Windows see the WindowsMake.bat script in this folder
#
# Targets
# all:     compiles the backend
# full:    compiles and releases the backend for both modelsim and questa
# release: copies the compiled backend to the installer directory
# clean:   removes the all generated files
#
# Arguments
# SIMULATOR -> selects between questasim and modelsim 
# (make sure to run 'make clean' when changing simulators) 
#
# Examples:
# Questa:
# make
# make release
# make clean
#
# ModelSim:
# make SIMULATOR=modelsim
# make SIMULATOR=modelsim release
# make clean
#
# Notes: 
# When compiling the backend for modelsim, the gcc/g++ that came with modelsim
# was used. However, the version of crti.o on the computer was newer than one
# that could be handled by that g++, so a newer g++ (9.4.0) was used for linking.


ifeq ($(SIMULATOR), modelsim)
SIM_NAME      = modelsim
SIMULATOR_DIR = /home/${USER}/intelFPGA/19.1/modelsim_ase
SIM_CFLAGS    = -m32
SIM_LDFLAGS   = -L$(SIMULATOR_DIR)/linux -L/usr/lib32

CC  = $(SIMULATOR_DIR)/gcc-4.7.4-linux/bin/gcc
CXX = $(SIMULATOR_DIR)/gcc-4.7.4-linux/bin/g++

else
SIM_NAME      = questasim
SIMULATOR_DIR = /home/${USER}/intelFPGA/21.1/questa_fse
SIM_CFLAGS    = -m64 -fno-diagnostics-show-caret 
SIM_LDFLAGS   = -L$(SIMULATOR_DIR)/linux_x86_64

CC  = gcc
CXX = g++
endif



RELEASE_DIR	  = ../installer/dist/backend/$(SIM_NAME)/

CFLAGS  = $(SIM_CFLAGS) -c -Wall -g -fPIC -Iinclude -I$(SIMULATOR_DIR)/include
LDFLAGS = $(SIM_CFLAGS) -g -shared -lmtipli -fPIC $(SIM_LDFLAGS)



all: dist/$(SIM_NAME)/simfpga.vpi

full:
	make clean
	make
	make release
	make clean
	make SIMULATOR=modelsim
	make SIMULATOR=modelsim release
	make clean

utils.o: utils.c include/utils.h
	$(CC) utils.c $(CFLAGS)

fpga_output_device.o: fpga_output_device.cpp include/fpga_output_device.h
	$(CXX) fpga_output_device.cpp $(CFLAGS)

fpga_input_device.o: fpga_input_device.cpp include/fpga_input_device.h
	$(CXX) fpga_input_device.cpp $(CFLAGS)

fpga_inout_device.o: fpga_inout_device.cpp include/fpga_inout_device.h
	$(CXX) fpga_inout_device.cpp $(CFLAGS)

keyboard_input.o: keyboard_input.cpp include/keyboard_input.h
	$(CXX) keyboard_input.cpp $(CFLAGS)

fpga.o: fpga.cpp include/fpga*.h include/keyboard_input.h include/utils.h include/helper.h
	$(CXX) fpga.cpp $(CFLAGS)

sim_task.o: sim_task.cpp include/sim_task.h include/fpga.h include/utils.h include/helper.h
	$(CXX) sim_task.cpp $(CFLAGS)

dist/$(SIM_NAME)/simfpga.vpi: sim_task.o utils.o fpga.o fpga_output_device.o fpga_input_device.o keyboard_input.o fpga_inout_device.o
	mkdir -p dist/$(SIM_NAME)
	g++ -o dist/$(SIM_NAME)/simfpga.vpi fpga_inout_device.o keyboard_input.o fpga_input_device.o fpga_output_device.o fpga.o sim_task.o utils.o $(LDFLAGS)

release: dist/$(SIM_NAME)/simfpga.vpi
	mkdir -p $(RELEASE_DIR)
	cp dist/$(SIM_NAME)/simfpga.vpi $(RELEASE_DIR).

clean:
	rm -rf *.o
	rm -rf dist/*.vpi

.PHONY: clean all release 
