REM if any memory initialization files exist, copy them to this folder
xcopy /y /c /q ..\*.mif .

if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vcom ../*.vhd

