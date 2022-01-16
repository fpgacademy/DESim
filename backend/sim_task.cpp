// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "sim_task.h"
#include "helper.h"

/* the following API can be used on either Linux or Windows:
* - poll can be used as normal, except for some subtle bug ms won't fix
*   (see https://curl.haxx.se/mail/lib-2012-10/0038.html).
*
*  - Save socket file descriptors into sockfd variables
*  - Use closesocket() instead of close()
*  - Use INVALID_SOCKET instead of -1
*  - gettimeofday can be used as normal
*
*  - Wrap all calls with fix_rc() because the winsock versions return 
*    INVALID_SOCKET rather than a meaningful error code. By the way,
*    0 means success and anything else is an error number that can be passed
*    into sockstrerror()
* 
* - Use sockerrno instead of errno
* - Use sockstrerr(x) instead of strerror(x)
*/


static float TIME_SCALE = (1.0 / 100e-6); //realtime seconds per simulation seconds
static struct timeval sim_start; //Keeps track of real time
static sockfd server = INVALID_SOCKET;



/**
 * The start-up array of pointers to functions returning void type
 * List all the registration functions and present them to the simulator
 * The last element in this array should be NULL
 */
void (*vlog_startup_routines[])() = {
	MyTaskRegister,
	StartOfSimCbRegister,
	NULL
};


/**
 * Register the start-up process (function: StartOfSim) of the simulation
 */
void StartOfSimCbRegister() {
	s_vpi_time time_type = {
		.type = vpiSimTime
	};

	s_cb_data cbdat = {
		.reason = cbStartOfSimulation,
		.cb_rtn = StartOfSim,
		.time = &time_type
	};

	vpiHandle cb_handle = vpi_register_cb(&cbdat);
	vpi_free_object(cb_handle);
}


/**
 * Register a customized simulation task
 */
void MyTaskRegister() {
	char *task_name = static_cast<char *>(malloc(sizeof(char) * 11));
	if(!task_name){
		std::cerr << "error: malloc" << std::endl;
		std::exit(1);
	}
	strncpy(task_name, "$sim_fpga", 10);
	s_vpi_systf_data tf_data = {
		.type      = vpiSysTask,
		.tfname    = task_name,
		.calltf    = MyCalltf,
		.compiletf = MyCompiletf,
		.user_data = 0
	};

	vpi_register_systf(&tf_data);
}




/**
 * Helper function for MyCompiletf to check if this simulation task is called correctly
 * @return return 1 if the argument is not proper, o/w return 0
 */
static int CheckArgs(vpiHandle handle, PLI_INT32 type, int size) {
	if (handle == NULL || vpi_get(vpiType, handle) != type || vpi_get(vpiSize, handle) != size) {
		PrintUsageError(handle);
		return 1;
	}
	return 0;
}


static void PrintUsageError(vpiHandle handle) {
	vpi_printf_helper(USAGE "\n");
	vpi_control(vpiFinish, 1);
	vpi_put_userdata(handle, NULL);
}

/**
 * "compiletf" for MyTaskRegister
 * Parse the arguments to this simulation task and check if they are proper
 */
static int MyCompiletf(PLI_BYTE8 *user_data) {
	//Get handle to this task call instance
	vpiHandle self = vpi_handle(vpiSysTfCall, NULL);


	//Iterate through arguments
	vpiHandle args = vpi_iterate(vpiArgument, self);
	if (args == NULL) {
		PrintUsageError(self); //Error if no arguments
		return 0;
	}

	//First argument is clock
	vpiHandle clk_handle = vpi_scan(args);
	if (CheckArgs(clk_handle, vpiReg, 1)) {
		// stop parsing arguments if argument is incorrect
		return 0;
	}


	//Second argument is switches
	vpiHandle switch_handle = vpi_scan(args);
	if (CheckArgs(switch_handle, vpiReg, NUM_SW)) {
		return 0;
	}

	//Third argument is keys
	vpiHandle key_handle = vpi_scan(args);
	if (CheckArgs(key_handle, vpiReg, NUM_KEYS)) {
		return 0;
	}

	//Fourth argument is led
	vpiHandle led_handle = vpi_scan(args);
	if (CheckArgs(led_handle, vpiNet, NUM_LEDS)) {
		return 0;
	}


	//Fifth argument is hex displays
	vpiHandle hex_handle = vpi_scan(args);
	if (CheckArgs(hex_handle, vpiNet, 8 * NUM_HEX_DISPLAYS)) {
		return 0;
	}


	// Arguments for PS2 Keyboard
	vpiHandle key_action_handle = vpi_scan(args);
	if (CheckArgs(key_action_handle, vpiReg, 1)) {
		return 0;
	}

	vpiHandle scan_code_handle = vpi_scan(args);
	if (CheckArgs(scan_code_handle, vpiReg, 8)) {
		return 0;
	}

	vpiHandle ps2_lock_handle = vpi_scan(args);
	if (CheckArgs(ps2_lock_handle, vpiNet, 3)) {
		return 0;
	}


	// Arguments for VGA
	vpiHandle x_handle = vpi_scan(args);
	if(CheckArgs(x_handle, vpiNet, 8)){
		return 0;
	}

	vpiHandle y_handle = vpi_scan(args);
	if(CheckArgs(y_handle, vpiNet, 7)){
		return 0;
	}

	vpiHandle color_handle =vpi_scan(args);
	if(CheckArgs(color_handle, vpiNet, 3)){
		return 0;
	}

	vpiHandle plot_handle = vpi_scan(args);
	if(CheckArgs(plot_handle, vpiNet, 1)){
		return 0;
	}


	// TODO: Add your own arguments
	vpiHandle gpio_handle = vpi_scan(args);
	if(CheckArgs(gpio_handle, vpiNet, NUM_GPIO)){
		return 0;
	}

	//If extra arguments given, throw an error
	if (vpi_scan(args) != NULL) {
		vpi_free_object(args);
		PrintUsageError(self);
		return 0;
	}



	fpga *f = new fpga(clk_handle, switch_handle, key_handle, led_handle, hex_handle,
								 key_action_handle, scan_code_handle, ps2_lock_handle,
								 x_handle, y_handle, color_handle, plot_handle, gpio_handle);


	//Attach the allocated FPGA to this task call instance
	vpi_put_userdata(self, f);

	//Callback info for end of sim cleanup (for freeing fpga)
	s_cb_data dat = {
		.reason = cbEndOfSimulation,
		.cb_rtn = EndOfSimCleanup,
		.user_data = (char *)f
	};

	//Register callback
	vpiHandle cb_handle = vpi_register_cb(&dat);
	//We don't need the handle (since we'll never cancel the callback)
	vpi_free_object(cb_handle);

	return 0;
}



/**
 * "calltf" for MyTaskRegister
 * The main function which implements the functionality of this simulation task
 */
static int MyCalltf(PLI_BYTE8 *user_data) {
	//Get reference to the object representing this task call instance
	vpiHandle self = vpi_handle(vpiSysTfCall, NULL);

	//Get the saved data for this instance
	fpga *f = static_cast<fpga *>(vpi_get_userdata(self));

	//To get the value of signals later
	RegVcCb(f->leds->device_handle, vpiBinStrVal, f, LedValueChange);
	RegVcCb(f->hex_displays->device_handle, vpiHexStrVal, f, HexValueChange);
	RegVcCb(f->ps2_locks->device_handle, vpiBinStrVal, f, PS2ValueChange);
	RegVcCb(f->clk_handle, vpiIntVal, f, ClkValueChange);

	// TODO: register callback for your output device
	RegVcCb(f->gpio->device_handle, vpiBinStrVal, f, GpioValueChange);

	//Apply initial input values immediately
	f->SetInitialSimInput();

	//Keep the communication between server and simulator
	//make sure that the simulator stays open
	RegKeepAliveCb(f);

	return 0;
}


static int GpioValueChange(s_cb_data *dat){
	fpga *f = (fpga *)dat->user_data;
	f->UpdateOutputValue('g', dat->value);
	RegRwSyncCb(f);
	return 0;
}


//Value-change callback which registers a printer callback for the end of
//this sim time (so that values have "settled" by the time we print)
static int LedValueChange(s_cb_data *dat) {
	//Grab FPGA state from callback user data
	fpga *f = (fpga *)dat->user_data;
	f->UpdateOutputValue('l', dat->value);

	//Register I/O signal update callback
	RegRwSyncCb(f);
	return 0;
}

static int HexValueChange(s_cb_data *dat) {
	fpga *f = (fpga *)dat->user_data;
	f->UpdateOutputValue('h', dat->value);
	RegRwSyncCb(f);
	return 0;
}

static int PS2ValueChange(s_cb_data *dat) {
	fpga *f = (fpga *)dat->user_data;
	f->UpdateOutputValue('p', dat->value);
	RegRwSyncCb(f);
	return 0;
}

//Value-change callback for the clock. Handles VGA signals.
static int ClkValueChange(s_cb_data *dat) {
	fpga *f = (fpga *)dat->user_data;

	//Register fake I/O update callback if this is a rising edge
	int clkval = dat->value->value.integer;
	if (clkval) {
		RegRoSyncCb(f);
	}
	return 0;
}



/**
 *  ReadWriteSynch callback that prints fpga state values and checks for input values
 *  Registered when signal values change
 **/
static int RwSync(s_cb_data *dat) {
	//Grab FPGA state from callback user data
	fpga *f = (fpga *)dat->user_data;

	//Mark that we've received the callback
	f->rwsync_cb_reg = 0;

	//Send output signals to GUI
	f->SendOutputValue(server);


	//Read messages from GUI and update input signals
	struct pollfd pfd = {
		.fd = server,
		.events = POLLIN
	};

	int disparity_ms = GetTimeDisparityMs(dat); //max time to wait for msg
	int rc = poll(&pfd, 1, disparity_ms);
	if (fix_rc(rc) < 0) {
#ifndef _WIN32
		//A rare situation where Linux is more complicated than Windows
		if (errno == EINTR) return 0; //This is not an error
#endif
		vpi_printf_helper("error with poll()\n");
		vpi_mcd_flush(1);
		vpi_control(vpiFinish, 1);
		return 0;

	} else if (rc > 0) {
		char msg[15];
		memset(msg, 0, 15);
		int rc = recv(server, msg, sizeof(msg) - 1, 0);
		if (rc < 0) {
			vpi_printf_helper("Could not read network data\n");
			vpi_mcd_flush(1);
			vpi_control(vpiFinish, 1);
			return 0;
		} else if (rc == 0) {
			vpi_printf_helper("GUI has closed the connection\n");
			vpi_mcd_flush(1);
			vpi_control(vpiFinish, 1);
			return 0;
		}

		msg[rc] = 0; //null terminate

		f->HandleInput(msg);
	}

	return 0;
}



/**
 * ReadOnlySynch callback that reads VGA signals at the clock's rising edge
 * Note: Need to check the clock's value before registering this callback
 */
static int RisingEdgeRoSync(s_cb_data *dat) {
	//Grab FPGA state from callback user data
	fpga *f = (fpga *)dat->user_data;

	//Mark that we've received the callback
	f->rosync_cb_reg = 0;

	f->SendVGAPixelValue(server);
	return 0;
}




/**
 * Set up socket to communicate with GUI
 */
static int StartOfSim(s_cb_data *dat) {
	char msg[128];
	snprintf(msg, 128, "Time scaling: %g sim seconds per real-time second\n\n\n", 1.0f / TIME_SCALE);
	vpi_printf_helper(msg);

#ifdef _WIN32
	WSADATA wsa_data;
	WSAStartup(0x0202, &wsa_data);
#endif

	server = socket(AF_INET, SOCK_STREAM, 0);

	if (server == INVALID_SOCKET) {
		vpi_printf_helper("Could not open socket\n");
		vpi_control(vpiFinish, 1);
		return 0;
	}

	struct sockaddr_in serv_addr = {
		.sin_family = AF_INET,
		.sin_port = htons(54321)
	};

	inet_pton(AF_INET, "127.0.0.1", &(serv_addr.sin_addr));

	int rc = fix_rc(connect(server, (struct sockaddr *)&serv_addr, sizeof(struct sockaddr_in)));

	if (rc != 0) {
		vpi_printf_helper("Could not connect to GUI server\n");
		vpi_control(vpiFinish, 1);
		return 0;
	}

	vpi_printf_helper("Connected to server!\n");
	vpi_mcd_flush(1);

	gettimeofday(&sim_start, NULL);

	return 0;
}


/**
 * clean up data and close socket
 */
static int EndOfSimCleanup(s_cb_data *dat) {
	fpga *f = (fpga *)dat->user_data;
	delete f;
//	free(f);

	if (server != INVALID_SOCKET) {
		closesocket(server);
	}

#ifdef _WIN32
	WSACleanup();
#endif

	vpi_printf_helper("\nQuitting...\n");

	return 0;
}



//Callback called every 5000 sim ticks just to make sure the simulation stays open.
static int KeepAlive(s_cb_data *dat) {
	fpga *f = (fpga *)dat->user_data;

	//Old handle is no longer meaningful, so free it:
	vpi_free_object(f->keep_alive_cb_handle);
	//Register a new keep-alive callback
	RegKeepAliveCb(f);

	//Register callback for updating I/O
	RegRwSyncCb(f);

	return 0;
}

//Helper function to register a keep-alive callback. a cbAfterDelay callback for 5000 sim ticks
static void RegKeepAliveCb(fpga *f) {
	s_vpi_time delay = {
		.type = vpiSimTime,
		.high = 0,
		.low = 5000
	};

	s_cb_data cbdat = {
		.reason = cbAfterDelay,
		.cb_rtn = KeepAlive,
		.time = &delay,
		.user_data = (char *)f
	};

	f->keep_alive_cb_handle = vpi_register_cb(&cbdat);
}


/**
 * Helper function for RwSync
 * Calculate the amount of time to wait for message from server
 */
static int GetTimeDisparityMs(s_cb_data *dat) {
	//Get current time and compare with scaled sim time
	struct timeval now;
	gettimeofday(&now, NULL);

	double real_time = ((double)(now.tv_sec - sim_start.tv_sec)
		+ 1e-6 * (double)(now.tv_usec - sim_start.tv_usec));
	double sim_time_ns = (double)dat->time->low / 1000.0;
	double scaled_sim_time = sim_time_ns * 1e-9 * TIME_SCALE;
	// get upper 32 bits of sim time
	sim_time_ns += (double) dat->time->high * 4294967.296; // = 2^32 / 1000
	double disparity = (scaled_sim_time - real_time);

	int disparity_ms = disparity * 1e3;

	//Not wait for msg if simulation time is not too advanced
	if (disparity_ms < 5) disparity_ms = 0;

	return disparity_ms;
}



//Helper function to register FPGA input/output callback
static void RegRwSyncCb(fpga *f) {
	//Register printer callback, if not already done
	if (f->rwsync_cb_reg == 0) {
		//Desired time units
		s_vpi_time time_type = {
			.type = vpiSimTime
		};

		//Callback info for printing value at end of sim time
		s_cb_data cbdat = {
			.reason = cbReadWriteSynch,
			.cb_rtn = RwSync,
			.time = &time_type,
			.user_data = (char *)f
		};

		//Register the callback
		vpiHandle cb_handle = vpi_register_cb(&cbdat);
		//We'll never need this handle, so free it
		vpi_free_object(cb_handle);

		//Signal that the callback is registered so we don't re-register it
		f->rwsync_cb_reg = 1;
	}
}



//Helper function to register ReadOnlySynch callback
static void RegRoSyncCb(fpga *f) {
	//Register printer callback, if not already done
	if (f->rosync_cb_reg == 0) {
		//Desired time units
		s_vpi_time time_type = {
			.type = vpiSimTime
		};

		//Callback info for printing value at end of sim time
		s_cb_data cbdat = {
			.reason = cbReadOnlySynch,
			.cb_rtn = RisingEdgeRoSync,
			.time = &time_type,
			.user_data = (char *)f
		};

		//Register the callback
		vpiHandle cb_handle = vpi_register_cb(&cbdat);
		//We'll never need this handle, so free it
		vpi_free_object(cb_handle);

		//Signal that the callback is registered so we don't re-register it
		f->rosync_cb_reg = 1;
	}
}


//Helper function to register a value-change callback
static void RegVcCb(vpiHandle net, PLI_INT32 format, fpga *f, PLI_INT32 (*callback)(struct t_cb_data *)) {
	//Say we want time in sim units
	s_vpi_time time_type = {
		.type = vpiSimTime
	};

	//We want a binary string
	s_vpi_value val_type = {
		.format = format
	};

	//Callback info
	s_cb_data cbdat = {
		.reason = cbValueChange,
		.cb_rtn = callback,
		.obj = net,
		.time = &time_type,
		.value = &val_type,
		.user_data = (char *)f
	};

	//Register the callback
	vpiHandle cb_handle = vpi_register_cb(&cbdat);
	//We don't need the handle to the callback (since we never plan to cancel it)
	vpi_free_object(cb_handle);
}






