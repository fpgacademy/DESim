// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Shell;

import GUI.ButtonConfigs;
import GUI.Main;
import GUI.windows.Message;
import GUI.windows.MessageType;
import javafx.stage.Stage;

import java.util.Locale;

public class StartSimTask extends ShellTask {
    // <editor-fold desc="Constants">
    public static final String scriptName = CmdShell.completeScriptNameByOS( "run_sim" );
    // </editor-fold>

    // <editor-fold desc="Variables">
    public static final String TASK_NAME = "starting simulation";
    public static final ButtonConfigs SUCCESS_BTN_CFG = ButtonConfigs.SIMULATING;

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private static final Message MSG_FAILED = new Message("Failed to start simulation", MessageType.ERROR, false);
    private static final String STR_EXCEPTION = "Exception occurred while trying to start the simulator: ";
    // </editor-fold>
    // </editor-fold>

    // <editor-fold desc="Static Methods">
    public static StartSimTask runStartSimTask( Stage primaryStage, String projDir ) {
        StartSimTask startSimTask = new StartSimTask(projDir);
        runTask(startSimTask, primaryStage);
        return startSimTask;
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Constructors">
    private StartSimTask(String projDir) {
        super(projDir, TASK_NAME, null);
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Protected Methods">
    @Override
    protected TaskResult execute(final CmdShell shell) {
        boolean loadingError = false;

        try {
            shell.stdIn.write(scriptName  + "\n");
            shell.stdIn.flush();

            String s;
            while ((s = shell.stdOut.readLine()) != null) {
                String lcs = s.toLowerCase(Locale.ROOT);

                Message msg = null;
                boolean hasWarning = lcs.contains("warning");
                boolean hasError = lcs.contains("error");

                // Check if ModelSim is missing from the path
                if (lcs.contains("'vsim' is not recognized")) {
                    hasError = true;
                }

                if (hasWarning && !hasError) {
                    msg = new Message(s, MessageType.WARNING, true);
                } else if (!hasWarning && hasError) {
                    msg = new Message(s, MessageType.ERROR, true);
                    loadingError = true;
                } else {
                    msg = new Message(s, MessageType.INFO, true);
                }

                Main.messageBox.addMessageFromThread(msg);

                if (lcs.contains("connected to server!"))
                    break;

                if (lcs.contains("# errors:"))
                    break;

                if (lcs.contains("application closing"))
                    break;
            }
        } catch (Exception err) {
            Message errMsg = new Message(STR_EXCEPTION + err.getMessage(), MessageType.ERROR, false);
            Main.messageBox.addMessageFromThread(errMsg);
            return TaskResult.EXCEPTION;
        }

        if (loadingError) {
            Main.messageBox.addMessageFromThread(MSG_FAILED);
            return TaskResult.ERROR;
        }

        return TaskResult.SUCCESS;
    }
    // </editor-fold>
}
