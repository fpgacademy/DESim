REM Copyright (c) 2020 FPGAcademy
REM Please see license at https://github.com/fpgacademy/DESim

REM README: there are several optional settings in this file that you may need to select.
REM Remove the REM that "comments out" any setting that you wish to use.
REM Uncomment one (only) of the next two lines to specify if DESim should use ModelSim or Questa
set DESimulator=modelsim
REM set DESimulator=questa

REM Do not modify the statement below
set DESimPath=%CD%

REM If the ModelSim (or Questa) Simulator that you wish to run within DESim can be found on
REM your Windows Path, then use the following command to start the DESim application:
start java\bin\javaw.exe -m DESim/GUI.Main

REM But if the ModelSim (or Questa) that you wish to run within DESim is NOT on your Windows
REM Path, then use the '--simulator-path' argument, illustrated below. Replace <SimulatorPath>
REM with the actual path to the ModelSim (or Questa) software that you wish to use with DESim.
REM Example paths for ModelSim and Questa are illustrated below:
REM   --simulator-path=C:\intelFPGA\20.1\modelsim_ase\win32aloem
REM   --simulator-path=C:\intelFPGA\21.1\questa_fse\win64
REM Uncomment the statement below and specify your Simulator path
REM start java\bin\javaw.exe -m DESim/GUI.Main --simulator-path=<SimulatorPath>

REM If you are using a license file with ModelSim (or Questa) and the LM_LICENSE_FILE 
REM environment varible is not set on your computer, then use the command line argument 
REM '--license-file-path'. Replace <LicenseFilePath> with the actual path to the license
REM file on your computer. Uncomment the statement below and specify your License File path
REM start java\bin\javaw.exe -m DESim/GUI.Main --license-file-path=<LicenseFilePath>

REM Uncomment the statement below to specify a path to BOTH your Simulator and License File
REM start java\bin\javaw.exe -m DESim/GUI.Main --simulator-path=<SimulatorPath> --license-file-path=<LicenseFilePath>
