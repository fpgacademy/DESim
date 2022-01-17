// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Shell;

import GUI.ButtonConfigs;
import GUI.Main;
import GUI.windows.Message;
import GUI.windows.MessageType;
import javafx.stage.Stage;

import java.util.Locale;

public class CompileTask extends ShellTask {
    // <editor-fold desc="Constants">
    public static final String scriptName = CmdShell.completeScriptNameByOS( "run_compile" );

    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final String TASK_NAME = "compiling";
    private static final ButtonConfigs SUCCESS_BTN_CFG = ButtonConfigs.COMPILED;

    private static final Message MSG_SUCCESS = new Message("Compilation successful", MessageType.INFO, false);
    private static final Message MSG_FAIL = new Message("Compilation failed", MessageType.ERROR, false);
    private static final String STR_EXCEPTION = "Exception occurred during compilation: ";
    // </editor-fold>
    // </editor-fold>

    // <editor-fold desc="Static Methods">
    public static CompileTask runCompileTask(Stage primaryStage, String projDir ) {
        CompileTask compileTask = new CompileTask(projDir);
        runTask(compileTask, primaryStage);
        return compileTask;
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Constructors">
    private CompileTask(String projDir) {
        super(projDir, TASK_NAME, SUCCESS_BTN_CFG);
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Protected Methods">
    @Override
    protected TaskResult execute(final CmdShell shell) {
        boolean compilationError = false;

        try {
            shell.stdIn.write(scriptName + "\n");
            shell.stdIn.write( "echo testbench_compilation_complete\n" );
            shell.stdIn.flush();

            String s;
            while ((s = shell.stdOut.readLine()) != null) {
                String lcs = s.toLowerCase(Locale.ROOT);
                if (lcs.contains("testbench_compilation_complete"))
                    break;

                Message msg = null;
                boolean hasWarning = lcs.contains("warning");
                boolean hasError = lcs.contains("error");

                // Check if ModelSim is missing from the path
                if (lcs.contains("'vlib' is not recognized")) {
                    hasError = true;
                } else if (lcs.contains("'vlog' is not recognized")) {
                    hasError = true;
                }

                if (hasWarning && !hasError) {
                    msg = new Message(s, MessageType.WARNING, true);
                } else if (!hasWarning && hasError) {
                    msg = new Message(s, MessageType.ERROR, true);
                    compilationError = true;
                } else {
                    msg = new Message(s, MessageType.INFO, true);
                }

                Main.messageBox.addMessageFromThread(msg);
            }
        } catch (Exception err) {
            Message errMsg = new Message(STR_EXCEPTION + err.getMessage(), MessageType.ERROR, false);
            Main.messageBox.addMessageFromThread(errMsg);
            return TaskResult.EXCEPTION;
        } finally {
            if (shell != null) {
                shell.close();
            }
        }

        if (compilationError) {
            Main.messageBox.addMessageFromThread(MSG_FAIL);
            return TaskResult.ERROR;
        }

        Main.messageBox.addMessageFromThread(MSG_SUCCESS);
        return TaskResult.SUCCESS;
    }
    // </editor-fold>
}
