// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef FPGA_OUTPUT_DEVICE_H_
#define FPGA_OUTPUT_DEVICE_H_

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

class fpga_output_device {
 private:
	int device_num;
	PLI_INT32 value_format;
	char device_type; //the starting char of a signal to GUI, so GUI knows which device the signal is from
	char *new_val;    //String containing latest values

 public:

	vpiHandle device_handle;

	fpga_output_device(int device_num, PLI_INT32 value_format, char device_type, vpiHandle device_handle);

	~fpga_output_device();

	bool operator = (fpga_output_device const &other);

	fpga_output_device(fpga_output_device const &other);

	/**
	 * Update value of this device based on new simulation value
	 * @param value: new simulation value
	 * @return 1 if value's format doesn't match, 0 otherwise
	 */
	int UpdateValue(s_vpi_value *value);


	// Send the value of this device to GUI
	void SendValue(sockfd server);
};

#endif
