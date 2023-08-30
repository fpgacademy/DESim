// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;


import Controller.Device;
import GUI.Main;
import GUI.devicecontainer.GPIOContainer;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.text.TextAlignment;

public class GPIO {
    // <editor-fold desc="Variables">
    public final VBox gpioPort;
    public final VBox gpioDir;

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    public final CheckBox statusBox;
    private final CheckBox isOutputBox;
    // </editor-fold>
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public GPIO(int index){

        // initialize GPIO port
        gpioPort = new VBox();
        statusBox = new CheckBox();
        statusBox.setSelected(false);

        Label label;
        if (index > 9) {
            // one whitespace
            label = new Label(" " + index);
        } else {
            // two whitespaces
            label = new Label("  " + index + " ");
        }
        label.setTextAlignment(TextAlignment.CENTER);
        gpioPort.getChildren().addAll(statusBox, label);


        // initialize GPIO direction
        Label label1 = new Label(label.getText());
        gpioDir = new VBox();
        isOutputBox = new CheckBox();
        isOutputBox.setSelected(false);
        gpioDir.getChildren().addAll(isOutputBox, label1);


        statusBox.selectedProperty().addListener(new ChangeListener<>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                if(!isOutputBox.isSelected()){
                    Main.connector.sendSignal(Device.GPIO + " " + index + " " + (newValue ? 1 : 0));
                }
            }
        });


        isOutputBox.selectedProperty().addListener(new ChangeListener<>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                statusBox.setDisable(newValue);

            }
        });


    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * set value at this GPIO port from simulation when it's output port
     * @param status true: on, false: off
     */
    public void setStatus(boolean status){
        if(isOutputBox.isSelected()) {
            statusBox.setSelected(status);
        }
    }

    public void setIsOutput(boolean isOutput){
        isOutputBox.setSelected(isOutput);
    }

    // reset input signals
    public void stop(){
        if(!isOutputBox.isSelected()) {
            statusBox.setSelected(false);
        }

    }

    // ToDo: Ask Ruiqi about statusBox
    private boolean getStatus(){
        return statusBox.isSelected();
    }

    public boolean getIsOutput(){
        return isOutputBox.isSelected();
    }
    // </editor-fold>
}

