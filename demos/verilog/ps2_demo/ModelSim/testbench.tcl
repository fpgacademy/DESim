# stop any simulation that is currently running
quit -sim

# create the default "work" library
vlib work;

# compile the needed Verilog code in the tb folder
vlog ../tb/PS2_keyboard.v ../tb/ps2_clk_dat.v
# compile the testbench
vlog testbench.v
# start the Simulator, including some libraries that may be needed
vsim work.testbench -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do wave.do
# advance the simulation the desired amount of time
run 5000 ns
