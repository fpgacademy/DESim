// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "fpga_inout_device.h"
fpga_inout_device::fpga_inout_device(int device_num,
									 PLI_INT32 value_format,
									 char device_type,
									 vpiHandle device_handle) {
	if (device_num <= 0) {
		std::cerr << "error: number of device should be greater than 0" << std::endl;
		std::exit(1);
	}
	this->device_num = device_num;
	this->value_format = value_format;
	this->device_type = device_type;
	this->device_handle = device_handle;
	this->input_vals = static_cast<char *>(malloc(sizeof(char) * (device_num + 1)));
	this->output_vals = static_cast<char *>(malloc(sizeof(char) * (device_num + 1)));

	if (!this->input_vals || !this->output_vals) {
		std::cerr << "error: malloc" << std::endl;
		std::exit(1);
	}
	for (int i = 0; i < device_num; i++) {
		this->input_vals[i] = '0';
		this->output_vals[i] = 0;
	}
	this->input_vals[device_num] = 0;
	this->output_vals[device_num] = 0;
}


int fpga_inout_device::UpdateInputValue(char *tokens) {

	int index, val;
	int rc = sscanf(tokens, "%d %d", &index, &val);
	if (rc < 2 || index < 0 || index >= this->device_num) {
		return 1;
	}

	// e.g. GPIO[0] is the 32th bit of GPIO[31:0]
	index = (this->device_num - 1) - index;
	this->input_vals[index] = (val) ? '1' : '0';

	s_vpi_value new_vals = {
		.format = this->value_format,
		.value = {this->input_vals}
	};

	vpi_put_value(this->device_handle, &new_vals, NULL, vpiNoDelay);
	return 0;

}

int fpga_inout_device::UpdateOutputValue(s_vpi_value *value) {
	//Make sure we have the expected value format
	if (value->format != this->value_format) {
		return 1;
	}

	//Update value string
	strncpy(this->output_vals, value->value.str, this->device_num + 1);
	this->output_vals[this->device_num] = 0;
	for (int i = 0; i < this->device_num; i++) {
		if (this->output_vals[i] == '1') {
			this->input_vals[i] = '1';
		} else if (this->output_vals[i] == '0') {
			this->input_vals[i] = '0';
		}
	}
	return 0;
}

void fpga_inout_device::SendValue(sockfd server) {
	// if led value has changed
	if (this->output_vals[0] != 0) {
		char line[this->device_num + 2 + 1];
		//write at most size bytes (including '\0')
		snprintf(line, this->device_num + 3, "%c%s\n", this->device_type, this->output_vals);

		//Use a regular blocking send on the socket.
		send(server, line, this->device_num + 2, 0);

		//Mark that we've seen the updated values
		this->output_vals[0] = 0;
	}
}


fpga_inout_device::~fpga_inout_device() {
	if (this->input_vals) {
		free(this->input_vals);
	}
	if (this->output_vals) {
		free(this->output_vals);
	}
}


bool fpga_inout_device::operator = (fpga_inout_device const &other){
	if(this->device_num != other.device_num) return false;
	if(this->value_format != other.value_format) return false;
	if(this->device_type != other.device_type) return false;
	if(this->input_vals != other.input_vals) return false;
	if(this->output_vals != other.output_vals) return false;
	return this->device_handle == other.device_handle;
}


fpga_inout_device::fpga_inout_device(fpga_inout_device const &other){
	this->device_num = other.device_num;
	this->value_format = other.value_format;
	this->device_type = other.device_type;

	this->input_vals = static_cast<char *>(malloc(sizeof(char) * (other.device_num + 1)));
	this->output_vals = static_cast<char *>(malloc(sizeof(char) * (other.device_num + 1)));
	if (!this->input_vals || !this->output_vals) {
		std::cerr << "error: malloc" << std::endl;
		std::exit(1);
	}
	strncpy(this->input_vals, other.input_vals, other.device_num + 1);
	this->input_vals[other.device_num] = 0;
	strncpy(this->output_vals, other.output_vals, other.device_num + 1);
	this->output_vals[other.device_num] = 0;

	this->device_handle = other.device_handle;

}

