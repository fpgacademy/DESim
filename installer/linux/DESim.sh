# Copyright (c) 2022 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim

# If ModelSim/Questa is not part of your path, please use the command line 
# argument '--simulator-path'. Replace <SimulatorPath> with the path to 
# modelsim/questa on your computer, such as
#   a) /home/$USER/intelFPGA/19.1/modelsim_ase/linux
#   b) /home/$USER/intelFPGA/21.1/questa_fse/linux_x86_64
#
# If a license file is need by ModelSim/Questa and the LM_LICENSE_FILE 
# environment varible does not exist. Please use the command line argument 
# '--license-file-path'. Replace <LicenseFilePath> with the path to the license
# file on your computer.

./java/bin/java -m DESim/GUI.Main
#./java/bin/java -m DESim/GUI.Main --simulator-path=<SimulatorPath>
#./java/bin/java -m DESim/GUI.Main --license-file-path=<LicenseFilePath>
#./java/bin/java -m DESim/GUI.Main --simulator-path=<SimulatorPath> --license-file-path=<LicenseFilePath>

