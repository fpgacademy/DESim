:: Copyright (c) 2022 FPGAcademy
:: Please see license at https://github.com/fpgacademy/DESim
::
:: Windows batch script
:: To update the demos with the newly compile VPI backend

@ECHO OFF
TITLE Updating DESim demo with new backend library on Windows

@ECHO ON
copy dist\simfpga.vpi ..\demos\Accumulate\sim\.
copy dist\simfpga.vpi ..\demos\Addern\sim\.
copy dist\simfpga.vpi ..\demos\Counter\sim\.
copy dist\simfpga.vpi ..\demos\Display\sim\.
copy dist\simfpga.vpi ..\demos\GPIO\gpio_bidir_demo\sim\.
copy dist\simfpga.vpi ..\demos\GPIO\gpio_in_demo\sim\.
copy dist\simfpga.vpi ..\demos\GPIO\gpio_out_demo\sim\.
copy dist\simfpga.vpi ..\demos\LED_HEX\sim\.
copy dist\simfpga.vpi ..\demos\ps2_demo\sim\.
copy dist\simfpga.vpi ..\demos\vga_demo\sim\.

@ECHO OFF
PAUSE
