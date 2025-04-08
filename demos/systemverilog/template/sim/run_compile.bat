set MIF_FILES=..\*.mif
set SOURCE_FILES=../*.sv

REM if any memory initialization files exist, copy them to this folder
%WINDIR%\System32\xcopy /y /c /q %MIF_FILES% .

if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog %SOURCE_FILES%
