#!/bin/bash
if [ -d work ]
then
	rm -r work
fi

vlib work
vlog ../tb/*.v
if [ -f ../Top.v ]
then
	vlog ../*.v
fi
if [ -f ../Top.vhd ]
then
	vcom ../*.vhd
fi

