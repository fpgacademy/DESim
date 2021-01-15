// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef HELPER_H_
#define HELPER_H_

#include <stdlib.h>
#include <string.h>
#include <vpi_user.h>

static void vpi_printf_helper(const char *msg){
	char text[512];
	strncpy(text, msg, 511);
	text[511] = '\0';
	vpi_printf(text);
}

#endif
