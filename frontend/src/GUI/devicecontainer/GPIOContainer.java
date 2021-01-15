// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.Main;
import GUI.device.GPIO;
import GUI.windows.Message;
import GUI.windows.MessageType;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Separator;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.FileChooser;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Objects;
import java.util.Scanner;

public class GPIOContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final int NUMBER_OF_GPIO = 32;

    private static final Message MSG_SUCCESS =
            new Message("Success writing GPIO config file");
    private static final Message MSG_WRITING_FAILED =
            new Message("Failed writing GPIO config file", MessageType.ERROR);
    private static final Message MSG_OPENING_FAILED =
            new Message("Failed opening GPIO config file", MessageType.ERROR);
    private static final Message MSG_READING_FAILED =
            new Message("Failed reading GPIO port direction: pattern mismatched", MessageType.ERROR);
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final GPIO[] ports;
    // Checkbox for setting all GPIO signal direction.
    // NOTE: Do not convert to local variable!
    private final CheckBox allOut;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public GPIOContainer() {
        super("Parallel Ports", new VBox());
        ports = new GPIO[NUMBER_OF_GPIO];


        Label directionLabel = new Label("Direction Map");
        directionLabel.setStyle("-fx-font-size: 13");
        HBox directionBar = new HBox();
        directionBar.getChildren().addAll(directionLabel);




        /*
         *  Direction Settings
         */

        // Use Configuration file
        Button directionConfig = new Button(" Use Config File ");
        directionConfig.setStyle("-fx-padding: 2");
        directionConfig.setOnAction(new EventHandler<>() {
            @Override
            public void handle(ActionEvent e) {
                String direction = openDirectionConfigFile();
                if (direction != null) {
                    setDirectionFromFile(direction);
                }
            }
        });

        // Save current configuration to file
        Button saveDirection = new Button(" Save Current ");
        saveDirection.setStyle("-fx-padding: 2");
        saveDirection.setOnAction(new EventHandler<>() {
            @Override
            public void handle(ActionEvent e) {
                saveDirectionToFile();
            }
        });


        allOut = new CheckBox();
        allOut.setSelected(false);
        allOut.selectedProperty().addListener(new ChangeListener<>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                for (int i = 0; i < NUMBER_OF_GPIO; i++) {
                    ports[i].setIsOutput(newValue);
                }
            }
        });

        Label allOutLabel = new Label("All output port");

        HBox allOutBox = new HBox();
        // Inset: up, right, down, left
        HBox.setMargin(allOut, new Insets(3, 5, 0, 5));
        HBox.setMargin(allOutLabel, new Insets(3, 0, 0, 0));
        HBox.setMargin(directionLabel, new Insets(3, 0, 0, 0));
        HBox.setMargin(directionConfig, new Insets(0, 15, 0, 15));
        allOutBox.getChildren().addAll(allOut, allOutLabel, directionConfig, saveDirection);


        /*
         *  checkboxes
         */

        FlowPane portPane = new FlowPane(3, 3);
        FlowPane portPane1 = new FlowPane(3, 3);
        FlowPane directionPane = new FlowPane(3, 3);
        FlowPane directionPane1 = new FlowPane(3, 3);

        VBox content = new VBox();
        VBox.setMargin(portPane1, new Insets(0, 0, 15, 0));
        VBox.setMargin(directionBar, new Insets(5, 0, 10, 0));
        VBox.setMargin(allOutBox, new Insets(0, 0, 10, 0));
        content.getChildren().addAll(portPane, portPane1, new Separator(), directionBar, allOutBox, directionPane, directionPane1);

        for (int i = NUMBER_OF_GPIO - 1; i >= NUMBER_OF_GPIO / 2; i--) {
            ports[i] = new GPIO(i);
            portPane.getChildren().add(ports[i].gpioPort);
            directionPane.getChildren().add(ports[i].gpioDir);
        }

        for (int i = NUMBER_OF_GPIO / 2 - 1; i >= 0; i--) {
            ports[i] = new GPIO(i);
            portPane1.getChildren().add(ports[i].gpioPort);
            directionPane1.getChildren().add(ports[i].gpioDir);
        }

        super.setContent(content);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void setGPIO(int index, boolean status) {
        if(index < 0 || index > NUMBER_OF_GPIO){
            throw new IndexOutOfBoundsException("Invalid GPIO index\n");
        }
        ports[index].setStatus(status);
    }

    public void reset() {
        for (int i = 0; i < NUMBER_OF_GPIO; i++) {
            ports[i].stop();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void saveDirectionToFile(){
        FileChooser fileChooser = new FileChooser();
        String projDir = Main.getProjDir();
        fileChooser.setInitialDirectory(new File(Objects.requireNonNullElse(projDir, ".")));
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("Text doc(*.txt)", "*.txt"));
        File file = fileChooser.showSaveDialog(Main.nodeMap.get("GPIOContainer").getScene().getWindow());

        if(file != null) {
            try (FileWriter myWriter = new FileWriter(file.getAbsoluteFile())) {
                myWriter.write(getDirectionToFile());
                Main.messageBox.addMessage(MSG_SUCCESS);
            } catch (IOException e) {
                Main.messageBox.addMessage(MSG_WRITING_FAILED);
            }
        }
    }

    private String getDirectionToFile(){
        StringBuilder dir = new StringBuilder();
        for(int i = 0; i < NUMBER_OF_GPIO; i++) {
            char ch = ports[i].getIsOutput() ? '1' : '0';
            dir.append(ch);
            if(i % 4 == 3){
                dir.append(" ");
            }
        }
        return dir.toString();
    }

    private String openDirectionConfigFile() {

        FileChooser fileChooser = new FileChooser();
        String projDir = Main.getProjDir();
        fileChooser.setInitialDirectory(new File(Objects.requireNonNullElse(projDir, ".")));
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("Text doc(*.txt)", "*.txt"));
        File file = fileChooser.showOpenDialog(Main.nodeMap.get("GPIOContainer").getScene().getWindow());
        if(file == null) {
            return null;
        }
        try (Scanner sc = new Scanner(file)) {
            StringBuilder config = new StringBuilder();

            while (sc.hasNextLine() && config.length() < 128) {
                config.append(sc.nextLine().strip());
            }
            return config.toString();

        } catch (Exception e) {
            Main.messageBox.addMessage(MSG_OPENING_FAILED);
            return null;
        }

    }

    private void setDirectionFromFile(String dir) {

        // naive check if this is the file for setting direction
        String pattern = "^[01\\s]*$";
        if(dir.matches(pattern)) {
            int count = 0;
            for(int i=0; i < dir.length(); i++){
                char ch = dir.charAt(i);
                // to skip whitespace
                if(ch == '0' || ch == '1'){
                    ports[count].setIsOutput(ch == '1');
                    count++;
                }
                // end reading for all ports
                if(count == NUMBER_OF_GPIO){
                    break;
                }
            }
        }else{
            Main.messageBox.addMessage(MSG_READING_FAILED);
        }
    }
    // </editor-fold>
    // </editor-fold>
}
