REM Copyright (c) 2020 FPGAcademy
REM Please see license at https://github.com/fpgacademy/DESim

REM Create a version of java with DESim as a module
REM This program should be run on Windows

REM ----------------------------------------------------------------------
REM Perform clean-up for previously module and java version
REM ----------------------------------------------------------------------

rd /S /Q dist

REM ----------------------------------------------------------------------
REM Convert the DESim GUI source code into a Java module
REM ----------------------------------------------------------------------

copy src\module-info.java.txt src\module-info.java
dir /s /b src\*.java > sources.txt 
javac --module-path ../../Java/javafx-sdk-11.0.2/lib -d mods/DESim @sources.txt 

REM ----------------------------------------------------------------------
REM Create a version of Java with the DESim module built-in
REM ----------------------------------------------------------------------

jlink --module-path "../../Java/javafx-jmods-11.0.2;mods" --add-modules DESim --output dist

REM ----------------------------------------------------------------------
REM Clean up temp files
REM ----------------------------------------------------------------------

del src\module-info.java
del sources.txt
rd /S /Q mods

REM ----------------------------------------------------------------------
REM Pause command prompt to view the output from the above commands
REM ----------------------------------------------------------------------

PAUSE

