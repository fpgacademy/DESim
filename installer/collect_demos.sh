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

mkdir -p dist/demos/modelsim/verilog
mkdir -p dist/demos/modelsim/vhdl

rsync -ar --exclude='*.vhd' ../demos/ ./dist/demos/modelsim/verilog
rsync -ar --include='*.ip.v' --include='tb/*.v' --exclude='*.v' ../demos/ ./dist/demos/modelsim/vhdl
cp -r ./dist/demos/modelsim/ ./dist/demos/questa/

find ./dist/demos/modelsim/ -name sim -exec cp ./dist/backend/modelsim/simfpga.vpi {} \;
find ./dist/demos/questa/ -name sim -exec cp ./dist/backend/questa/simfpga.vpi {} \;
