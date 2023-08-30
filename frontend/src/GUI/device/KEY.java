// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import Controller.Device;
import GUI.Main;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.text.TextAlignment;

public class KEY extends VBox {
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    public final CheckBox checkBox;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public KEY(int index){
        super();
        checkBox = new CheckBox();
        checkBox.setSelected(true);

        checkBox.selectedProperty().addListener(new ChangeListener<>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                Main.connector.sendSignal(Device.KEY + " " + index + " " + (newValue ? 1 : 0));
            }
        });
        Label label = new Label("  " + index);
        label.setTextAlignment(TextAlignment.CENTER);
        this.getChildren().add(checkBox);
        this.getChildren().add(label);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    // active low
    public void setStop(){
        this.checkBox.setSelected(true);
    }

    public boolean getStatus(){
        return this.checkBox.isSelected();
    }
    // </editor-fold>
}

