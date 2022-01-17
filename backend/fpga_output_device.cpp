// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "fpga_output_device.h"

fpga_output_device::fpga_output_device(int device_num,
									   PLI_INT32 value_format,
									   char device_type,
									   vpiHandle device_handle) {
	if (device_num <= 0) {
		std::cerr << "error: number of device should be greater than 0" << std::endl;
		exit(1);
	}

	this->device_num = device_num;
	this->value_format = value_format;
	this->device_type = device_type;
	this->device_handle = device_handle;
	this->new_val = static_cast<char *>(malloc(sizeof(char) * (device_num + 1)));
	if (!this->new_val) {
		std::cerr << "error: malloc" << std::endl;
		exit(1);
	}
}


int fpga_output_device::UpdateValue(s_vpi_value *value) {
	//Make sure we have the expected value format
	if (value->format != this->value_format) {
		return 1;
	}

	//Update value string
	strncpy(this->new_val, value->value.str, this->device_num + 1);
	this->new_val[this->device_num] = 0;
	return 0;
}

void fpga_output_device::SendValue(sockfd server) {
	// if led value has changed
	if (this->new_val[0] != 0) {
		// add one for device_type, one for newline, one for null-terminator
		char line[this->device_num + 2 + 1];
		//write at most size bytes (including '\0')
		snprintf(line, this->device_num + 3, "%c%s\n", this->device_type, this->new_val);

		//Use a regular blocking send on the socket.
		send(server, line, this->device_num + 2, 0);

		//Mark that we've seen the updated values
		this->new_val[0] = 0;
	}
}



fpga_output_device::~fpga_output_device() {
	if (this->new_val) {
		free(this->new_val);
	}
}

bool fpga_output_device::operator = (fpga_output_device const &other){
	if(this->device_num != other.device_num) return false;
	if(this->value_format != other.value_format) return false;
	if(this->device_type != other.device_type) return false;
	if(this->new_val != other.new_val) return false;
	return this->device_handle == other.device_handle;
}


fpga_output_device::fpga_output_device(fpga_output_device const &other){

	this->device_num = other.device_num;
	this->value_format = other.value_format;
	this->device_type = other.device_type;

	this->new_val = static_cast<char *>(malloc(sizeof(char) * (other.device_num + 1)));
	// malloc failed
	if (!this->new_val) {
		std::cerr << "error: malloc" << std::endl;
		exit(1);
	}
	strncpy(this->new_val, other.new_val, other.device_num + 1);
	this->new_val[other.device_num] = 0;

	this->device_handle = other.device_handle;
}
