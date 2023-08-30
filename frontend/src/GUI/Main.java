// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI;

import Controller.Connector;
import GUI.devicecontainer.*;
import GUI.menu.DeviceMenu;
import GUI.windows.Message;
import GUI.windows.MessageBox;
import GUI.windows.MessageType;
import Settings.CommandLineArguments;
import Shell.CmdShell;
import Shell.CompileTask;
import Shell.StartSimTask;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Orientation;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.DirectoryChooser;
import javafx.stage.Stage;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;


public class Main extends Application {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final Message MSG_PERMISSION_DENIED =
            new Message("Don't have permission to access project directory.",
                    MessageType.ERROR, false);

    private static final Message MSG_SIM_END =
            new Message("End simulation", MessageType.INFO, false);
    // </editor-fold>

    // <editor-fold desc="Static Variables">
    public static final Connector connector = new Connector();
    public static final HashMap<String, Node> nodeMap = new HashMap<>();
    public static final MessageBox messageBox = new MessageBox();

    // <editor-fold defaultstate="collapsed" desc="Static Private Variables">
    private static String projDir = null;
    private static String projDefault = ".";
    private static ButtonConfigs lastButtonConfig = ButtonConfigs.INITIAL;

    public static final Button openProjButton = new Button("Open Project");
    public static final Button compileButton = new Button("Compile Testbench");
    public static final Button startButton = new Button("Start Simulation");
    public static final Button stopButton = new Button("Stop Simulation");
    // </editor-fold>
    // </editor-fold>

    // <editor-fold desc="Static Methods">
    public static void main(String[] args) {
        CommandLineArguments clArgs = new CommandLineArguments(args);
        CmdShell.init( clArgs );

        Thread connThread = new Thread(connector);
        connThread.start();
        launch(args);
    }

    public static void resetButtons() {
        enableButtons(lastButtonConfig);
    }

    public static void enableButtons(ButtonConfigs btnConfigs) {
        openProjButton.setDisable(true);
        compileButton.setDisable(true);
        startButton.setDisable(true);
        stopButton.setDisable(true);
        switch (btnConfigs) {
            case INITIAL:
                openProjButton.setDisable(false);
                break;
            case OPEN_PROJECT:
                openProjButton.setDisable(false);
                compileButton.setDisable(false);
                break;
            case COMPILED:
                openProjButton.setDisable(false);
                compileButton.setDisable(false);
                startButton.setDisable(false);
                break;
            case SIMULATING:
                stopButton.setDisable(false);
                break;
            default:
                break;
        }

        // Save this new button config state, except if the new state is DISABLED.
        // This allows the buttons to be reset to the last valid state.
        if (btnConfigs != ButtonConfigs.DISABLED) {
            lastButtonConfig = btnConfigs;
        }
    }

    public static void setWindowTitle(Stage primaryStage, String action ) {
        primaryStage.setTitle("DESim (" + action + ")");
    }

    public static void clearWindowTitle(Stage primaryStage ) {
        primaryStage.setTitle("DESim");
    }

    public static String getProjDir(){
        return projDir;
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    @Override
    public void start(Stage primaryStage) {
        clearWindowTitle( primaryStage );

        // create a dock pane that will manage our dock nodes and handle the layout
        SplitPane dockPane = new SplitPane();
        dockPane.setOrientation(Orientation.HORIZONTAL);


        /*
          Message Window
         */
        ScrollPane messagePane = new ScrollPane(messageBox);
        messagePane.setFitToWidth(true);
        messagePane.vvalueProperty().bind(messageBox.heightProperty());
        dockPane.getItems().add(messagePane);


        /*
         * Devices Window
         */
        VBox devices = new VBox();
        LEDContainer ledContainer = new LEDContainer();
        devices.getChildren().add(ledContainer);

        SwitchContainer switchContainer = new SwitchContainer();
        devices.getChildren().add(switchContainer);

        KeyContainer keyContainer = new KeyContainer();
        devices.getChildren().add(keyContainer);

        SevenSegContainer sevenSegContainer = new SevenSegContainer();
        devices.getChildren().add(sevenSegContainer);

        KeyboardContainer keyboardContainer = new KeyboardContainer();
        keyboardContainer.setExpanded(false);
        devices.getChildren().add(keyboardContainer);

        GPIOContainer gpioContainer = new GPIOContainer();
        gpioContainer.setExpanded(false);
        devices.getChildren().add(gpioContainer);

        VGAContainer vgaContainer = new VGAContainer();
        vgaContainer.setExpanded(false);
        devices.getChildren().add(vgaContainer);

        ScrollPane devicePane = new ScrollPane(devices);
        devicePane.setFitToWidth(true);
        dockPane.getItems().add(devicePane);


        /*
         * Menu Bar
         */
        final DeviceMenu menu_device = new DeviceMenu("Devices");

        MenuBar menuBar = new MenuBar();
        menuBar.getMenus().addAll(menu_device);


        Button clearButton = new Button("Reset Signals");
        clearButton.setOnAction(actionEvent -> {
            ledContainer.reset();
            sevenSegContainer.reset();
            // reset controls
            keyContainer.reset();
            switchContainer.reset();
            keyboardContainer.reset();
            vgaContainer.reset();
            gpioContainer.reset();
        });


        enableButtons(ButtonConfigs.INITIAL);

        compileButton.setOnAction(e -> {
            CompileTask compileTask = CompileTask.runCompileTask(primaryStage, projDir);
        });

        startButton.setOnAction(e -> {
            StartSimTask startSimTask = StartSimTask.runStartSimTask(primaryStage, projDir);
        });

        stopButton.setOnAction(e -> {
            enableButtons(ButtonConfigs.COMPILED);
            connector.sendSignal("end");
            messageBox.addMessage(MSG_SIM_END);
        });


        openProjButton.setOnAction(e -> {
            setWindowTitle( primaryStage, "opening project" );

            int status = openProject();
            if (status == 0) {
                enableButtons(ButtonConfigs.OPEN_PROJECT);
            } else {
                enableButtons(ButtonConfigs.INITIAL);
            }
            clearWindowTitle( primaryStage );
        });


        ToolBar toolBar = new ToolBar(
                openProjButton,
                new Separator(),
                compileButton,
                startButton,
                stopButton,
                new Separator(),
                clearButton
        );


        VBox vbox = new VBox();
        vbox.getChildren().addAll(menuBar, toolBar, dockPane);
        VBox.setVgrow(dockPane, Priority.ALWAYS);

        //-------------------------------------------------------------------------------------


        // devices
        nodeMap.put("LEDContainer", ledContainer);
        nodeMap.put("SwitchContainer", switchContainer);
        nodeMap.put("KeyContainer", keyContainer);
        nodeMap.put("SevenSegContainer", sevenSegContainer);
        nodeMap.put("VGAContainer", vgaContainer);
        nodeMap.put("KeyboardContainer", keyboardContainer);
        nodeMap.put("GPIOContainer", gpioContainer);


        primaryStage.setScene(new Scene(vbox, 1000, 750));
        primaryStage.sizeToScene();

        primaryStage.show();

        primaryStage.setOnCloseRequest(e -> {
            Platform.exit();
            connector.stop();
            Runtime.getRuntime().exit(0);
        });

        Application.setUserAgentStylesheet(Application.STYLESHEET_MODENA);
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private int openProject() {
        DirectoryChooser directoryChooser = new DirectoryChooser();
        directoryChooser.setInitialDirectory(new File(projDefault));
        File dir = directoryChooser.showDialog(messageBox.getScene().getWindow());

        if (dir == null) {
            return 1;
        }

        // update default directory
        projDefault = dir.getAbsolutePath() + File.separator + "..";

        try {
            // check if it has sim subfolder
            Path projPath = Paths.get(dir.getAbsolutePath());
            Path simPath = projPath.resolve("sim");
            File simDir = new File(simPath.toString());
            if (!simDir.exists() || !simDir.isDirectory()) {
                Message msg = new Message("Project '" + dir.getName() + "' should contain sim subfolder.",
                        MessageType.ERROR);
                Main.messageBox.addMessage(msg);
                return 1;
            }

            // check if it has compile script
            String compileScript = CompileTask.scriptName;
            Path compileBatPath = simPath.resolve( compileScript );
            File compileBatFile = new File( compileBatPath.toString() );
            if (!compileBatFile.exists()) {
                Message msg = new Message("Project '" + dir.getName() + "' should contain " + compileScript + " in sim subfolder.",
                        MessageType.ERROR);
                Main.messageBox.addMessage(msg);
                return 1;
            }

            // check if it has start sim script
            String startSimScript = StartSimTask.scriptName;
            Path simBatPath = simPath.resolve( startSimScript );
            File simBatFile = new File( simBatPath.toString() );
            if (!simBatFile.exists()) {
                Message msg = new Message("Project '" + dir.getName() + "' should contain " + startSimScript + " in sim subfolder.",
                        MessageType.ERROR);
                Main.messageBox.addMessage(msg);
                return 1;
            }

            // valid project folder
            projDir = simDir.getAbsolutePath();
            Message msg = new Message("Project '" + dir.getName() + "' opened.");
            Main.messageBox.addMessage(msg);

        } catch (SecurityException err) {
            Main.messageBox.addMessage(MSG_PERMISSION_DENIED);
            return 1;
        }

        return 0;
    }
    // </editor-fold>
    // </editor-fold>
}
