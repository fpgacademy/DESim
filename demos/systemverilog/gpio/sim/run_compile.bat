if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
if exist ../*.sv (
	vlog ../*.sv
)
if exist ../*.vhd (
	vcom ../*.vhd
)

