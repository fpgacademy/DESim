// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "fpga_input_device.h"

fpga_input_device::fpga_input_device(int device_num, PLI_INT32 value_format, const char *initial_value,
									 vpiHandle device_handle) {
	if (device_num <= 0) {
		std::cerr << "error: number of device should be greater than 0" << std::endl;
		std::exit(1);
	}

	this->device_num = device_num;
	this->value_format = value_format;

	this->device_vals = static_cast<char *>(malloc(sizeof(char) * (device_num + 1)));

	// malloc failed
	if (!this->device_vals) {
		std::cerr << "error: malloc" << std::endl;
		std::exit(1);
	}
	strncpy(this->device_vals, initial_value, device_num + 1);
	this->device_vals[device_num] = 0;
	this->device_handle = device_handle;
}


void fpga_input_device::SetInitialValue() {
	s_vpi_value init_val = {
		.format = this->value_format,
		.value = {
			.str = this->device_vals
		}
	};
	vpi_put_value(this->device_handle, &init_val, NULL, vpiNoDelay);

}

int fpga_input_device::UpdateValue(char *tokens) {

	int index, val;
	int rc = sscanf(tokens, "%d %d", &index, &val);
	if (rc < 2 || index < 0 || index >= this->device_num) {
		return 1;
	}

	// e.g. SW[0] is the last bit of SW[9:0]
	index = (this->device_num - 1) - index;
	this->device_vals[index] = (val) ? '1' : '0';

	s_vpi_value new_vals = {
		.format = this->value_format,
		.value = {this->device_vals}
	};

	vpi_put_value(this->device_handle, &new_vals, NULL, vpiNoDelay);
	return 0;

}


fpga_input_device::~fpga_input_device() {
	if (this->device_vals) {
		free(this->device_vals);
	}
}


bool fpga_input_device::operator = (fpga_input_device const &other){
	if(this->device_num != other.device_num) return false;
	if(this->value_format != other.value_format) return false;
	// compare pointer here since one device should have only one value
	if(this->device_vals != other.device_vals) return false;
	return this->device_handle == other.device_handle;
}

fpga_input_device::fpga_input_device(fpga_input_device const &other){
	this->device_num = other.device_num;
	this->value_format = other.value_format;
	this->device_vals = static_cast<char *>(malloc(sizeof(char) * (other.device_num + 1)));

	// malloc failed
	if (!this->device_vals) {
		std::cerr << "error: malloc" << std::endl;
		std::exit(1);
	}
	strncpy(this->device_vals, other.device_vals, other.device_num + 1);
	this->device_vals[other.device_num] = 0;

	this->device_handle = other.device_handle;

}

