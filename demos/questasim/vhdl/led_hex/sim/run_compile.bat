if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
if exist ../*.v (
	vlog ../*.v
)
if exist ../*.vhd (
	vcom ../*.vhd
)

