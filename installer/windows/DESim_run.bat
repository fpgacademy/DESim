REM Copyright (c) 2020 FPGAcademy
REM Please see license at https://github.com/fpgacademy/DESim

start java\bin\javaw.exe -m DESim/GUI.Main
REM If ModelSim is not part of your path. Please 
REM 1) comment out the line above
REM 2) uncomment the line below
REM 3) replace <YourModelSimPath> with the path to modelsim on your computer, such as C:\intelFPGA\19.1\modelsim_ae\win32aloem
REM start java\bin\javaw.exe -m DESim/GUI.Main --modelsim-path=<YourModelSimPath>
