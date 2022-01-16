:: Copyright (c) 2022 FPGAcademy
:: Please see license at https://github.com/fpgacademy/DESim
::
:: Windows batch script
:: To remove the DESim software's backend compiled object files

@ECHO OFF
TITLE Removing compiled object files of DESim's backend

@ECHO ON
del *.o
del dist\*.vpi

@ECHO OFF
PAUSE
