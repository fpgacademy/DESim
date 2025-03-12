REM There are several options that you can select in this file.
REM Use the REM keyword to exclude/select your desired options.

REM Specify whether DESim should use ModelSim, or Questa:
set DESimulator=modelsim
REM set DESimulator=questa
|$\ldots$|
REM Do NOT modify the next three statements, below
set QuestaArg=
IF %DESimulator% == questa set QuestaArg=-no_autoacc
set DESimPath=%CD%

REM If the ModelSim (or Questa) Simulator that you wish to run within DESim can be found on
REM your Windows "Path" environment variable, then use the following command to start DESim
start java\bin\javaw.exe -m DESim/GUI.Main
|$\ldots$|

REM But if the ModelSim (or Questa) that you wish to run within DESim is NOT on your Windows
REM Path, then use the '--simulator-path' argument, illustrated below. Replace <SimulatorPath>
REM with the actual path to the ModelSim (or Questa) software that you wish to use with DESim.
REM Example paths for ModelSim and Questa are illustrated below:
REM   --simulator-path=C:\intelFPGA\20.1\modelsim_ase\win32aloem
REM   --simulator-path=C:\intelFPGA\21.1\questa_fse\win64
REM Uncomment the statement below and specify your Simulator
REM start java\bin\javaw.exe -m DESim/GUI.Main --simulator-path=<SimulatorPath>
|$\ldots$|

