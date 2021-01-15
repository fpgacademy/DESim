// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Shell;

import GUI.ButtonConfigs;
import GUI.Main;
import GUI.windows.Message;
import GUI.windows.MessageType;
import javafx.concurrent.Task;
import javafx.stage.Stage;

import java.io.IOException;

public abstract class ShellTask extends Task<TaskResult> {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final Message MSG_NO_OPEN_PROJECT =
            new Message("No opened project", MessageType.ERROR, false);
    private static final Message MSG_OPEN_SHELL_ERR =
            new Message("Unable open a command shell", MessageType.ERROR, false);
    private static final Message MSG_TASK_CANCELLED =
            new Message("Task cancelled!", MessageType.ERROR, false);
    private static final Message MSG_TASK_FAILED =
            new Message("Task failed!", MessageType.ERROR, false);
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final String projDir;
    private final String taskName;
    private final ButtonConfigs successBtnCfg;
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Protected Static Methods">
    protected static void runTask(ShellTask task, Stage primaryStage) {
        task.setOnRunning((evt) -> {
            Main.setWindowTitle(primaryStage, task.taskName);
            Main.enableButtons(ButtonConfigs.DISABLED);
        });

        task.setOnSucceeded((evt) -> {
            Main.clearWindowTitle(primaryStage);
            TaskResult result = task.getValue();

            if (result == TaskResult.SUCCESS) {
                if (task.successBtnCfg != null)
                    Main.enableButtons(task.successBtnCfg);
            } else {
                Main.resetButtons();
            }
        });

        // ShellTasks object should never be cancelled.
        // But just in case, tell the user so that they can debug this program.
        task.setOnCancelled((evt) -> {
            Main.messageBox.addMessage(MSG_TASK_CANCELLED);
            Main.clearWindowTitle(primaryStage);
            Main.resetButtons();
        });

        // ShellTasks object should never fail.
        // But just in case, tell the user so that they can debug this program.
        task.setOnFailed((evt) -> {
            Main.messageBox.addMessage(MSG_TASK_FAILED);
            Main.clearWindowTitle(primaryStage);
            Main.resetButtons();
        });

        Thread startSimThread = new Thread(task);
        startSimThread.setDaemon(true);
        startSimThread.start();
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Protected Constructors">
    protected ShellTask(final String projDir, final String taskName,
                        final ButtonConfigs successBtnCfg) {
        this.projDir = projDir;
        this.taskName = taskName;
        this.successBtnCfg = successBtnCfg;
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Protected Methods">
    @Override
    protected TaskResult call() throws Exception {
        if ((projDir == null) || (projDir.isBlank())) {
            Main.messageBox.addMessageFromThread(MSG_NO_OPEN_PROJECT);
            return TaskResult.EXCEPTION;
        }

        CmdShell shell = null;

        try {
            shell = CmdShell.getShell(projDir);
        } catch (IOException e) {
            Main.messageBox.addMessageFromThread(MSG_OPEN_SHELL_ERR);
            return TaskResult.EXCEPTION;
        }

        return execute(shell);
    }

    protected abstract TaskResult execute(final CmdShell shell);
    // </editor-fold>
}
