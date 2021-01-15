// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef FPGA_H_
#define FPGA_H_

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

// include socket functions as "C" to avoid function overloading problem in C++
extern "C" {
#include "utils.h"
}

#include <stdint.h> // portable: uint64_t   MSVC: __int64

struct timezone;

#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <poll.h>
typedef struct pollfd pollfd;
typedef int sockfd;
#define INVALID_SOCKET -1
#define closesocket(x) close(x)
#define fix_rc(x) (x)
#define sockerrno errno
#define sockstrerror(x) strerror(x)
#endif

#include "fpga_output_device.h"
#include "fpga_input_device.h"
#include "keyboard_input.h"
#include "fpga_inout_device.h"


#define NUM_LEDS 	10
#define NUM_SW 		10
#define NUM_KEYS 	4

#define NUM_HEX_DISPLAYS 	6
#define HEX_SIG_LENGTH (2*NUM_HEX_DISPLAYS)

#define NUM_PS2_LOCKS 3
#define NUM_GPIO	32



class fpga {

 public:
	// devices
	fpga_output_device *leds;
	fpga_output_device *hex_displays;
	fpga_input_device *switches;
	fpga_input_device *keys;

	fpga_output_device *ps2_locks;
	keyboard_input *keyboard;

	fpga_inout_device *gpio;

	vpiHandle clk_handle;
	vpiHandle vga_x_handle;
	vpiHandle vga_y_handle;
	vpiHandle vga_color_handle;
	vpiHandle vga_plot_handle;

	// nonzero if callback is registered to read and write simulation signals
	int rwsync_cb_reg;
	int rosync_cb_reg;

	vpiHandle keep_alive_cb_handle;


	fpga(vpiHandle clk_handle, vpiHandle switch_handle, vpiHandle key_handle,
		 vpiHandle led_handle, vpiHandle hex_handle, vpiHandle key_action_handle,
		 vpiHandle scan_code_handle, vpiHandle ps2_lock_handle,
		 vpiHandle x_handle, vpiHandle y_handle, vpiHandle color_handle, vpiHandle plot_handle,
		 vpiHandle gpio_handle);

	~fpga();

	bool operator = (fpga const &fpga);

	fpga(fpga const &fpga);

	void SetInitialSimInput();
	int HandleInput(char *msg);

	void SendOutputValue(sockfd server);
	void SendVGAPixelValue(sockfd server);
	void UpdateOutputValue(char device_type, s_vpi_value *value);
};


#endif
