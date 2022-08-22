#!/bin/bash
if [ -f ../inst_mem.mif ]
then
     cp /Y ../inst_mem.mif .
fi

if [ -d work ]
then
	rm -r work
fi

vlib work
vlog -nolock ../tb/*.v
if ls ../*.v 1> /dev/null 2>&1
then
	vlog -nolock ../*.v
fi
if ls ../*.sv 1> /dev/null 2>&1
then
	vlog -nolock ../*.sv
fi
if ls ../*.vhd 1> /dev/null 2>&1
then
	vcom -nolock ../*.vhd
fi

