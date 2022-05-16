#!/bin/bash
if [ -d work ]
then
	rm -r work
fi

vlib work
vlog ../tb/*.v
vlog ../*.v
if [ -f ../Top.sv ]
then
	vlog ../*.sv
fi
if [ -f ../Top.vhd ]
then
	vcom ../*.vhd
fi

