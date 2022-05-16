if exist ..\inst_mem.ip.mif (
    copy /Y ..\inst_mem.ip.mif .
)
if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v
if exist ../*.sv (
	vlog ../*.sv
)
if exist ../*.vhd (
    vcom ../*.vhd
)

