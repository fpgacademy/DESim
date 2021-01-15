// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef FPGA_INOUT_DEVICE_H_
#define FPGA_INOUT_DEVICE_H_

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
#ifdef _WIN32
#include <winsock2.h>
#include <Ws2tcpip.h>
typedef SOCKET sockfd;

#else
typedef int sockfd;
#endif

class fpga_inout_device {
 private:
	int device_num;
	PLI_INT32 value_format;
	char device_type;
	char *input_vals;
	char *output_vals;

 public:
	vpiHandle device_handle;

	fpga_inout_device(int device_num, PLI_INT32 value_format, char device_type, vpiHandle device_handle);

	~fpga_inout_device();

	bool operator = (fpga_inout_device const &other);

	fpga_inout_device(fpga_inout_device const &other);

	/**
	 * 	update simulation signal based on message from GUI
	 * @param tokens : GUI message split by whitespace
	 * @return 1 if GUI message is not proper, else 0
	 */
	int UpdateInputValue(char *tokens);

	/**
 	 * Update value of this device based on new simulation value
 	 * @param tokens: new simulation value
 	 * @return 1 if value's format doesn't match, 0 otherwise
 	 */
	int UpdateOutputValue(s_vpi_value *value);

	// Send the value of this device to GUI
	void SendValue(sockfd server);
};

#endif
