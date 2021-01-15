// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef KEYBOARD_H_
#define KEYBOARD_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <vpi_user.h>


class keyboard_input {
 private:
	PLI_INT32 key_action_format;
	PLI_INT32 scan_code_format;
	// value of keyboard
	char key_action[2];
	char scan_code[3];
 public:
	vpiHandle key_action_handle;
	vpiHandle scan_code_handle;


	keyboard_input(vpiHandle key_action_handle, vpiHandle scan_code_handle);

	// set the value of signals at the start of simulation
	void SetInitialValue();

	// update value based on the message received from GUI
	int UpdateValue(char *tokens);
};

#endif
