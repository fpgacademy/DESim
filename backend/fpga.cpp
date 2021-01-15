// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include "fpga.h"
#include "helper.h"

fpga::fpga(vpiHandle clk_handle, vpiHandle switch_handle, vpiHandle key_handle,
					 vpiHandle led_handle, vpiHandle hex_handle, vpiHandle key_action_handle,
					 vpiHandle scan_code_handle, vpiHandle ps2_lock_handle,
					 vpiHandle x_handle, vpiHandle y_handle, vpiHandle color_handle, vpiHandle plot_handle,
					 vpiHandle gpio_handle) {
	// basic I/O
	this->leds = new fpga_output_device(NUM_LEDS, vpiBinStrVal, 'l', led_handle);
	this->hex_displays = new fpga_output_device(HEX_SIG_LENGTH, vpiHexStrVal, 'h', hex_handle);

	this->switches = new fpga_input_device(NUM_SW, vpiBinStrVal, "0000000000", switch_handle);
	this->keys = new fpga_input_device(NUM_KEYS, vpiBinStrVal, "1111", key_handle);

	// gpio
	this->gpio = new fpga_inout_device(NUM_GPIO, vpiBinStrVal, 'g', gpio_handle);

	// ps2
	this->ps2_locks = new fpga_output_device(NUM_PS2_LOCKS, vpiBinStrVal, 'p', ps2_lock_handle);
	this->keyboard = new keyboard_input(key_action_handle, scan_code_handle);

	// vga
	this->clk_handle = clk_handle;
	this->vga_x_handle = x_handle;
	this->vga_y_handle = y_handle;
	this->vga_color_handle = color_handle;
	this->vga_plot_handle = plot_handle;

	this->rwsync_cb_reg = 0;
	this->rosync_cb_reg = 0;

	this->keep_alive_cb_handle = NULL;
}


void fpga::UpdateOutputValue(char device_type, s_vpi_value *value) {
	if (device_type == 'l') {
		if(this->leds->UpdateValue(value)){
			vpi_printf_helper("Error: incorrect led value format\n");
			vpi_control(vpiFinish, 1);
		}
	} else if(device_type == 'h') {
		if(this->hex_displays->UpdateValue(value)){
			vpi_printf_helper("Error: incorrect hex display value format\n");
			vpi_control(vpiFinish, 1);
		}
	} else if(device_type == 'p') {
		if(this->ps2_locks->UpdateValue(value)){
			vpi_printf_helper("Error: incorrect ps2 lock value format\n");
			vpi_control(vpiFinish, 1);
		}
	}else if(device_type == 'g'){
		if(this->gpio->UpdateOutputValue(value)){
			vpi_printf_helper("Error: incorrect gpio value format\n");
			vpi_control(vpiFinish, 1);
		}
	}
}

// Send output signals to GUI
void fpga::SendOutputValue(sockfd server) {
	this->leds->SendValue(server);
	this->hex_displays->SendValue(server);
	this->ps2_locks->SendValue(server);
	this->gpio->SendValue(server);
}


void fpga::SetInitialSimInput() {
	this->switches->SetInitialValue();
	this->keys->SetInitialValue();
	this->keyboard->SetInitialValue();
}

// Process input signals from GUI
int fpga::HandleInput(char *msg) {

	char *tokens = strpbrk(msg, " \t\r\n\v");
	if (tokens) {
		// truncate msg in order to compare the first word of msg
		*tokens = 0;
		tokens++;
	}

	if (!tokens) {
		vpi_printf_helper("Warning: malformed command. Ignoring...\n");
		vpi_mcd_flush(1);
		return 0;
	}
	if (!strcmp(msg, "SW")) {
		if(this->switches->UpdateValue(tokens)){
			vpi_printf_helper("Warning: malformed switch command. Ignoring...\n");
			vpi_mcd_flush(1);
		}

	} else if (!strcmp(msg, "KEY")) {
		if(this->keys->UpdateValue(tokens)){
			vpi_printf_helper("Warning: malformed push button command. Ignoring...\n");
			vpi_mcd_flush(1);
		}

	} else if (!strcmp(msg, "KB")) {
		if(this->keyboard->UpdateValue(tokens)){
			vpi_printf_helper("Warning: malformed keyboard scan code. Ignoring...\n");
			vpi_mcd_flush(1);
		}

	} else if (!strcmp(msg, "GPIO")) {
		if(this->gpio->UpdateInputValue(tokens)){
			vpi_printf_helper("Warning: malformed gpio command. Ignoring...\n");
			vpi_mcd_flush(1);
		}
	}else if (!strcmp(msg, "end")) {
		vpi_control(vpiFinish, 1);
		return 0;
	}

	return 0;
}


void fpga::SendVGAPixelValue(sockfd server){

	s_vpi_value val = {.format = vpiIntVal};
	vpi_get_value(this->vga_plot_handle, &val);

	// first check if plot is 1, then send pixel value
	if(val.value.integer != 0){
		int x, y, color;

		vpi_get_value(this->vga_x_handle, &val);
		x = val.value.integer;
		vpi_get_value(this->vga_y_handle, &val);
		y = val.value.integer;
		vpi_get_value(this->vga_color_handle, &val);
		color = val.value.integer;

		char line[80];
		//write at most size bytes (including '\0')
		snprintf(line, 80, "c %03d %03d %d\n", x, y, color);

		int rc = send(server, line, 12, 0);
		if (rc <= 0) {
			vpi_printf_helper("Could not send VGA signal to GUI\n");
			vpi_mcd_flush(1);
			vpi_control(vpiFinish, 1);
		}
	}
}



fpga::~fpga(){
	delete this->leds;
	delete this->hex_displays;
	delete this->switches;
	delete this->keys;
	delete this->gpio;
	delete this->ps2_locks;
	delete this->keyboard;

}

bool fpga::operator = (fpga const &other){
	// devices should be the same
	if(this->leds != other.leds) return false;
	if(this->hex_displays != other.hex_displays) return false;
	if(this->switches != other.switches) return false;
	if(this->keys != other.keys) return false;
	if(this->ps2_locks != other.ps2_locks) return false;
	if(this->keyboard != other.keyboard) return false;
	if(this->gpio != other.gpio) return false;

	// device handles
	if(this->clk_handle != other.clk_handle) return false;
	if(this->vga_x_handle != other.vga_x_handle) return false;
	if(this->vga_y_handle != other.vga_y_handle) return false;
	if(this->vga_color_handle != other.vga_y_handle) return false;
	if(this->vga_plot_handle != other.vga_plot_handle) return false;

	// read/write/keep alive callback can be either registered or not
	return true;
}


fpga::fpga(fpga const &other){
	this->leds = new fpga_output_device(*(other.leds));
	this->hex_displays = new fpga_output_device(*(other.hex_displays));
	this->switches = new fpga_input_device(*(other.switches));
	this->keys = new fpga_input_device(*(other.keys));
	this->ps2_locks = new fpga_output_device(*(other.ps2_locks));
	this->keyboard = new keyboard_input(*(other.keyboard));
	this->gpio = new fpga_inout_device(*(other.gpio));

	this->clk_handle = other.clk_handle;
	this->vga_x_handle = other.vga_x_handle;
	this->vga_y_handle = other.vga_y_handle;
	this->vga_color_handle = other.vga_color_handle;
	this->vga_plot_handle = other.vga_plot_handle;

	this->rwsync_cb_reg = 0;
	this->rosync_cb_reg = 0;
	this->keep_alive_cb_handle = NULL;
}



