#!/bin/bash
# Copyright (c) 2022 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim

# Create a tarball of the DESim software for use on Linux
# This program should be run on Linux

# The following needs to be built before running this script
# 1) Frontend
#    a) Build the frontend in IntelliJ
#    b) Run frontend/build_release.sh
# 2) Backend
#    a) Run backend/make
#    b) Run backend/make update_demos
# 3) Documents
#    a) Build the document PDFs and put them in ../docs/

#  ----------------------------------------------------------------------
#  Create temporary directories
#  ----------------------------------------------------------------------

mkdir ./DESim
mkdir ./DESim/java

#  ----------------------------------------------------------------------
#  Copy files for the frontend, backend and demos
#  ----------------------------------------------------------------------

# Frontend
cp -R ../../frontend/dist/* ./DESim/java
cp ../../frontend/scancode.csv ./DESim
cp DESim.sh ./DESim

# Demos
rsync -ar --exclude='*/*.bat' ../../demos ./DESim

# Documents
cp -R ../docs ./DESim/docs

#  ----------------------------------------------------------------------
#  Create the tarball
#  ----------------------------------------------------------------------

tar -cUzf desim.tar.gz DESim

#  ----------------------------------------------------------------------
#  Clean up temporary files
#  ----------------------------------------------------------------------

rm -rf ./DESim
