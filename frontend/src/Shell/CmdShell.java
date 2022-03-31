// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Shell;

import GUI.Main;
import GUI.windows.Message;
import GUI.windows.MessageType;
import Settings.CommandLineArguments;

import java.io.*;
import java.util.Map;

public class CmdShell {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final Message MSG_OPENING_FAILED =
            new Message("Failed to open cmd shell", MessageType.ERROR);

    private static final String INITIALIZATION_END_MSG = "shell_initialization_complete";
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Static Variables">
    private static CmdShellSettings cmdShellSettings = new CmdShellSettings();
    // </editor-fold>

    // <editor-fold desc="Variables">
    // The command line shell
    public final Process shell;
    // The standard output of the shell
    public final BufferedReader stdOut;
    // The standard error of the shell
    public final BufferedReader stdErr;
    // The standard input of the shell
    public final BufferedWriter stdIn;
    // </editor-fold>

    // <editor-fold desc="Static Methods">
    public static void init(CommandLineArguments clArgs) {
        cmdShellSettings = cmdShellSettings.update(clArgs);
    }

    public static String completeScriptNameByOS( String scriptBaseName) {
        return switch (cmdShellSettings.osType) {
            case WINDOWS -> scriptBaseName + ".bat";
            case LINUX -> "./" + scriptBaseName + ".sh";
            default -> scriptBaseName;
        };
    }

    public static CmdShell getShell( String startInDirectory ) throws IOException {
        try {
            return switch (cmdShellSettings.osType) {
                case WINDOWS -> getShellWindows( startInDirectory );
                case LINUX -> getShellLinux( startInDirectory );
                default -> null;
            };
        } catch (IOException e) {
            Main.messageBox.addMessage(MSG_OPENING_FAILED);
            throw e;
        }
    }

    // <editor-fold defaultstate="collapsed" desc="Private Static Methods">
    private static CmdShell getShellWindows( String startInDirectory ) throws IOException {

        String[] shellCmdArray = new String[]{
                "cmd"
        };

        return new CmdShell( shellCmdArray, startInDirectory );
    }

    private static CmdShell getShellLinux( String startInDirectory ) throws IOException {

        String[] shellCmdArray = new String[]{
                "bash"
        };

        return new CmdShell( shellCmdArray, startInDirectory );
    }
    // </editor-fold>
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Constructors">
    /*
     * Create and start the command line shell.
     *
     * @param shellCmdArray the command that opens the shell
     * @param startInDirectory the start in directory
     */
    private CmdShell (String[] shellCmdArray, String startInDirectory) throws IOException {

        ProcessBuilder pb = new ProcessBuilder(shellCmdArray);
        // Set the start in directory
        if (startInDirectory != null) {
            pb.directory(new File(startInDirectory));
        }
        // Update environment variables
        final String evPATH = cmdShellSettings.evPATH;
        final String evLM_LICENSE_FILE = cmdShellSettings.evLM_LICENSE_FILE;
        if ((evPATH != null) || (evLM_LICENSE_FILE != null)) {
            Map<String, String> envs = pb.environment();
            // Add simulator to the path
            if (evPATH != null) {
                String currentPath = envs.get("PATH");
                envs.put( "PATH", evPATH + currentPath);
            }
            // Add an environment variable for the license file
            if (evLM_LICENSE_FILE != null) {
                envs.put( "LM_LICENSE_FILE", evLM_LICENSE_FILE );
            }
        }
        pb.redirectErrorStream(true);

        // Start the shell
        shell = pb.start();

        // Get the standard IO for the shell
        stdOut = new BufferedReader(new InputStreamReader(shell.getInputStream()));
        stdErr = new BufferedReader(new InputStreamReader(shell.getErrorStream()));
        stdIn  = new BufferedWriter(new OutputStreamWriter(shell.getOutputStream()));

        // Add a message to the command line output to easily find the end of
        // the current messages.
        stdIn.write("echo " + INITIALIZATION_END_MSG + "\n");
        stdIn.flush();

        // Clear any initialization messages from standard out by reading lines
        // until the one that was add is found.
        String s;
        while ((s = stdOut.readLine()) != null) {
            if (s.equalsIgnoreCase(INITIALIZATION_END_MSG))
                break;
        }
    }
    // </editor-fold>

    // <editor-fold desc="Public Methods">
    public void close() {
        try {
            stdOut.close();
            stdErr.close();
            stdIn.close();

            shell.destroy();
        } catch (Exception ignored) {
        }
    }
    // </editor-fold>
}
