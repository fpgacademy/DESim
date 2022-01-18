#!/bin/bash
# Copyright (c) 2020 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim

# Create a version of java with DESim as a module
# This program should be run on Linux

#  ----------------------------------------------------------------------
#  Turn on echo commands
#  ----------------------------------------------------------------------

set -x

#  ----------------------------------------------------------------------
#  Perform clean-up for previously module and java version
#  ----------------------------------------------------------------------

rm -f -r dist

#  ----------------------------------------------------------------------
#  Convert the DESim GUI source code into a Java module
#  ----------------------------------------------------------------------

\cp src/module-info.java.txt src/module-info.java
find ./src -type f -name *.java > sources.txt
../../Java/jdk-17.0.1/bin/javac --module-path ../../Java/javafx-sdk-17.0.1/lib -d ./mods/DESim @sources.txt

#  ----------------------------------------------------------------------
#  Create a version of Java with the DESim module built-in
#  ----------------------------------------------------------------------

../../Java/jdk-17.0.1/bin/jlink --module-path "../../Java/javafx-jmods-17.0.1:./mods" --add-modules DESim --output dist

#  ----------------------------------------------------------------------
#  Clean up temp files
#  ----------------------------------------------------------------------

rm src/module-info.java
rm sources.txt
rm -r mods

