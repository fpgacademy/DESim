REM if any memory initialization files exist, copy them to this folder
%WINDIR%\System32\xcopy /y /c /q ..\*.mif .

if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v 
