if exist ..\inst_mem.mif (
    copy /Y ..\inst_mem.mif .
)
if exist ..\inst_mem_bb.v (
    del ..\inst_mem_bb.v
)
if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v
