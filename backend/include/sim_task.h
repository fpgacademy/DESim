// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef MY_TASK_H_
#define MY_TASK_H_

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

#include "fpga.h"

#define USAGE  "$sim_fpga(reg clk, reg switches[9:0], reg keys[3:0], wire leds[9:0], wire hex[47:0], wire key_action,"\
"wire [7:0] scan_code, wire [2:0] ps2_lock_control, wire [7:0] vga_x, wire [6:0] vga_y, wire [2:0] vga_color, wire plot,"\
"wire [31:0] gpio);"


void MyTaskRegister();
void StartOfSimCbRegister();

static int MyCompiletf(PLI_BYTE8 *user_data);
static int MyCalltf(PLI_BYTE8 *user_data);

static void RegVcCb(vpiHandle net, PLI_INT32 format, fpga *f, PLI_INT32 (*callback)(struct t_cb_data *));
static int LedValueChange(s_cb_data *dat);
static int HexValueChange(s_cb_data *dat);
static int PS2ValueChange(s_cb_data *dat);
static int ClkValueChange(s_cb_data *dat);
static int GpioValueChange(s_cb_data *dat);


static int RwSync(s_cb_data *dat);
static void RegRwSyncCb(fpga *f);


static int RisingEdgeRoSync(s_cb_data *dat);
static void RegRoSyncCb(fpga *f);


static void RegKeepAliveCb(fpga *f);
static int KeepAlive(s_cb_data *dat);


static int EndOfSimCleanup(s_cb_data *dat);
static int StartOfSim(s_cb_data *dat);
static int GetTimeDisparityMs(s_cb_data *dat);
static void PrintUsageError(vpiHandle handle);

#endif
