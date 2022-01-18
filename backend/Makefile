# Copyright (c) 2020 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim
#
# Linux Makefile
# To compile the DESim software's backend
#
# To compile the backend for Windows see the WindowsMake.bat script in this folder

QUESTASIM_DIR = /home/${USER}/intelFPGA/21.1/questa_fse

CFLAGS = -m64 -c -Wall -g -fno-diagnostics-show-caret -fPIC -Iinclude -I$(QUESTASIM_DIR)/include
LDFLAGS = -m64 -g -shared -lmtipli -fPIC -L$(QUESTASIM_DIR)/linux_x86_64

all: dist/simfpga.vpi

utils.o: utils.c include/utils.h
	gcc utils.c $(CFLAGS)

fpga_output_device.o: fpga_output_device.cpp include/fpga_output_device.h
	g++ fpga_output_device.cpp $(CFLAGS)

fpga_input_device.o: fpga_input_device.cpp include/fpga_input_device.h
	g++ fpga_input_device.cpp $(CFLAGS)

fpga_inout_device.o: fpga_inout_device.cpp include/fpga_inout_device.h
	g++ fpga_inout_device.cpp $(CFLAGS)

keyboard_input.o: keyboard_input.cpp include/keyboard_input.h
	g++ keyboard_input.cpp $(CFLAGS)

fpga.o: fpga.cpp include/fpga*.h include/keyboard_input.h include/utils.h include/helper.h
	g++ fpga.cpp $(CFLAGS)

sim_task.o: sim_task.cpp include/sim_task.h include/fpga.h include/utils.h include/helper.h
	g++ sim_task.cpp $(CFLAGS)

dist/simfpga.vpi: sim_task.o utils.o fpga.o fpga_output_device.o fpga_input_device.o keyboard_input.o fpga_inout_device.o
	g++ -o dist/simfpga.vpi fpga_inout_device.o keyboard_input.o fpga_input_device.o fpga_output_device.o fpga.o sim_task.o utils.o $(LDFLAGS)

update_demos: dist/simfpga.vpi
	cp dist/simfpga.vpi ../demos/accumulate/sim/.
	cp dist/simfpga.vpi ../demos/addern/sim/.
	cp dist/simfpga.vpi ../demos/counter/sim/.
	cp dist/simfpga.vpi ../demos/display/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_bidir_demo/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_in_demo/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_out_demo/sim/.
	cp dist/simfpga.vpi ../demos/LED_HEX/sim/.
	cp dist/simfpga.vpi ../demos/ps2_demo/sim/.
	cp dist/simfpga.vpi ../demos/vga_demo/sim/.

clean:
	rm -rf *.o
	rm -rf dist/*.vpi

