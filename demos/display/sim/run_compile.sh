#!/bin/bash
if [ -f ../inst_mem.mif ]
then
     cp /Y ../inst_mem.mif .
fi
if [ -f ../inst_mem_bb ]
then
     rm ../inst_mem_bb.v
fi

if [ -d work ]
then
	rm -r work
fi

vlib work
vlog ../tb/*.v
vlog ../*.v

