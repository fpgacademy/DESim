:: Copyright (c) 2022 FPGAcademy
:: Please see license at https://github.com/fpgacademy/DESim
::
:: Windows batch script
:: Release the newly compiled VPI backend

@ECHO OFF
TITLE Copying the DESim backend library to the installer folder

@ECHO ON
xcopy /E /I dist\* ..\installer\dist\backend\.

@ECHO OFF
PAUSE
