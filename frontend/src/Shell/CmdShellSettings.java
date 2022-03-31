// Copyright (c) 2022 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Shell;

import GUI.Main;
import GUI.windows.Message;
import GUI.windows.MessageType;
import Settings.CommandLineArguments;

public class CmdShellSettings {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final Message MSG_OS_CHECK_FAILED =
            new Message("Exception occurred while checking which OS is running", MessageType.ERROR);

    private static final Message MSG_UNKNOWN_OS =
            new Message("Unknown OS found while checking which OS is running", MessageType.ERROR);
    // </editor-fold>

    // <editor-fold desc="Variables">
    public final OSType osType;

    public final String evPATH;
    public final String evLM_LICENSE_FILE;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public CmdShellSettings() {
        // Can only set the osType, so set other constants to null
        evPATH = null;
        evLM_LICENSE_FILE = null;

        OSType tmpOSType = OSType.UNKNOWN;
        try {
            String osName = System.getProperty("os.name");

            if (osName.toLowerCase().contains( "windows" ))
                tmpOSType = OSType.WINDOWS;

            else if (osName.toLowerCase().contains( "linux" ))
                tmpOSType = OSType.LINUX;

            else
                Main.messageBox.addMessage(MSG_UNKNOWN_OS);

        } catch (Exception e) {
            Main.messageBox.addMessage(MSG_OS_CHECK_FAILED);
        } finally {
            osType = tmpOSType;
            // ToDo: throw exception if osType == OSType.UNKNOWN
        }

    }

    // <editor-fold defaultstate="collapsed" desc="Private Constructors">
    private CmdShellSettings(OSType osType, String evPATH, String evLM_LICENSE_FILE) {
        this.osType = osType;
        this.evPATH = evPATH;
        this.evLM_LICENSE_FILE = evLM_LICENSE_FILE;
    }
    // </editor-fold>
    // </editor-fold>

    // <editor-fold desc="Public Methods">
    public CmdShellSettings update(CommandLineArguments clArgs) {
        // if the command-line arguments is null, there is nothing to update
        if (clArgs == null) return this;

        final String pathSeparator = (osType == OSType.LINUX) ? ":" : ";";

        // Get command-line defined settings
        final String claModelsimPath = clArgs.getCmdLineArg(CommandLineArguments.MODELSIM_PATH, "");
        final String claSimulatorPath = clArgs.getCmdLineArg(CommandLineArguments.SIMULATOR_PATH, "");
        String newPATH = "";

        if (!claSimulatorPath.equals("")) newPATH += claSimulatorPath + pathSeparator;
        if (!claModelsimPath.equals("")) newPATH += claModelsimPath + pathSeparator;
        if (newPATH.equals("")) newPATH = evPATH;

        final String claLicenseFile = clArgs.getCmdLineArg(CommandLineArguments.LICENSE_FILE_PATH, "");
        final String newLM_LICENSE_FILE = (!claLicenseFile.equals("")) ? claLicenseFile : evLM_LICENSE_FILE;

        if ((newPATH == evPATH) && (newLM_LICENSE_FILE == evLM_LICENSE_FILE)) return this;
        else return new CmdShellSettings(osType, newPATH, newLM_LICENSE_FILE);
    }
    // </editor-fold>
}
