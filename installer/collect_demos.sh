#!/bin/bash
#
# This scripts organizes the demos for release.
# It creates 4 directories
# - dist/demos/modelsim/verilog
# - dist/demos/modelsim/vhdl
# - dist/demos/questa/verilog
# - dist/demos/questa/vhdl

if [ -d dist/demos ]
then
	rm -r dist/demos
fi

mkdir -p dist/demos/modelsim/systemverilog
mkdir -p dist/demos/modelsim/verilog
mkdir -p dist/demos/modelsim/vhdl

# Get the demos while splitting them for SystemVerilog, Verilog and VHDL
rsync -ar --include='*.ip.v' --include='tb/*.v' --exclude='*.v' --exclude='*.vhd' --exclude='common/' ../demos/ ./dist/demos/modelsim/systemverilog
rsync -ar --exclude='*.sv' --exclude='*.vhd' --exclude='common/' ../demos/ ./dist/demos/modelsim/verilog
rsync -ar --include='*.ip.v' --include='tb/*.v' --exclude='*.v' --exclude='*.sv' --exclude='common/' ../demos/ ./dist/demos/modelsim/vhdl

# Add the common scripts to all demos
find ./dist/demos/modelsim -type d -not -path "*/modelsim" -not -path "*/systemverilog" -not -path "*/verilog" -not -path "*/vhdl" -not -path "*/gpio" -not -path "*/sim" -not -path "*/tb" -exec cp -r ../demos/common/sim/ {} \;

# Copy demos for Questa
cp -r ./dist/demos/modelsim/ ./dist/demos/questa/

# Add the ModelSim and Questa backend DLLs to all demos, as appropriate
find ./dist/demos/modelsim/ -name sim -exec cp ./dist/backend/modelsim/simfpga.vpi {} \;
find ./dist/demos/questa/ -name sim -exec cp ./dist/backend/questa/simfpga.vpi {} \;
