#!/bin/bash
# Copyright (c) 2022 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim

# Create a tarball of the DESim software for use on Linux
# This program should be run on Linux

# The following needs to be built before running this script
# 1) Frontend
#    a) Build the frontend in IntelliJ
#    b) Run ../../frontend/build_release.sh
# 2) Backend
#    a) Run ../../backend/make full
# 3) Demos
#    a) Run ../collect_demos.sh
# 4) Documents
#    a) Build the document PDFs
#    b) Run ../collect_docs.sh

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
rsync -ar --exclude='*/*.bat' ../dist/demos ./DESim

# Documents
cp -R ../dist/docs ./DESim/docs

#  ----------------------------------------------------------------------
#  Create the tarball
#  ----------------------------------------------------------------------

tar -cUzf desim.tar.gz DESim

#  ----------------------------------------------------------------------
#  Clean up temporary files
#  ----------------------------------------------------------------------

rm -rf ./DESim
