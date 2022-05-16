#!/bin/bash
if [ -f ../inst_mem.ip.mif ]
then
     cp /Y ../inst_mem.ip.mif .
fi

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

