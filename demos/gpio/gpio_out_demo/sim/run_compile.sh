#!/bin/bash
if [ -d work ]
then
	rm -r work
fi

vlib work
vlog ../tb/*.v
vlog ../*.v

