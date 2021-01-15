// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef FPGA_INPUT_DEVICE_H_
#define FPGA_INPUT_DEVICE_H_

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <vpi_user.h>


class fpga_input_device {
 private:
	int device_num;
	PLI_INT32 value_format;
	char *device_vals;

 public:
	vpiHandle device_handle;

	fpga_input_device(int device_num, PLI_INT32 value_format, const char *initial_value, vpiHandle device_handle);

	~fpga_input_device();

	bool operator = (fpga_input_device const &other);

	fpga_input_device(fpga_input_device const &other);

	// set initial simulation signal for this device
	void SetInitialValue();

	/**
	 * 	update simulation signal based on message from GUI
	 * @param tokens : GUI message split by whitespace
	 * @return 1 if GUI message is not proper, else 0
	 */
	int UpdateValue(char *tokens);
};

#endif
