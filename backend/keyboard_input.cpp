// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "keyboard_input.h"

keyboard_input::keyboard_input(vpiHandle key_action_handle, vpiHandle scan_code_handle) {
	this->key_action_format = vpiBinStrVal;
	this->scan_code_format = vpiHexStrVal;

	this->key_action_handle = key_action_handle;
	this->scan_code_handle = scan_code_handle;

	key_action[0] = '0';
	key_action[1] = 0;
	scan_code[0] = '0';
	scan_code[1] = '0';
	scan_code[2] = 0;
}

void keyboard_input::SetInitialValue() {
	s_vpi_value init_scan_code = {
		.format = this->scan_code_format,
		.value = {
			.str = this->scan_code
		}
	};
	vpi_put_value(this->scan_code_handle, &init_scan_code, NULL, vpiNoDelay);

	s_vpi_value init_key_action = {
		.format = this->key_action_format,
		.value = {
			.str = this->key_action
		}
	};

	vpi_put_value(this->key_action_handle, &init_key_action, NULL, vpiNoDelay);
}

int keyboard_input::UpdateValue(char *tokens) {
	char first_code[3];
	char kb[3];
	char second_code[3];

	int rc = sscanf(tokens, "%3s %3s %3s", first_code, kb, second_code);
	if (rc < 1) {
		return 1;
	}

	strncpy(this->scan_code, first_code, 2);

	s_vpi_value new_vals = {
		.format = this->scan_code_format,
		.value = {this->scan_code}
	};

	vpi_put_value(this->scan_code_handle, &new_vals, NULL, vpiNoDelay);

	this->key_action[0] = '1';
	s_vpi_value new_action = {
		.format = this->key_action_format,
		.value = {this->key_action}
	};

	vpi_put_value(this->key_action_handle, &new_action, NULL, vpiNoDelay);

	// if it is a key release, read a second byte of scan code
	if (rc == 3) {

		strncpy(this->scan_code, second_code, 2);

		s_vpi_value new_code = {
			.format = this->scan_code_format,
			.value = {this->scan_code}
		};

		this->key_action[0] = '1';

		// delay the second scan code a little bit to ensure first scan code is processed
		// may not needed for a different implementation of PS2 keyboard driver (in Verilog)
		s_vpi_time delay = {
			.type = vpiSimTime,
			.high = 0,
			.low = 100
		};
		vpi_put_value(this->scan_code_handle, &new_code, &delay, vpiTransportDelay);
		vpi_put_value(this->key_action_handle, &new_action, &delay, vpiTransportDelay);
	}

	return 0;

}
