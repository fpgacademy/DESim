// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI;

import javafx.scene.Node;
import javafx.scene.control.TitledPane;

public class DeviceContainer extends TitledPane {
    // <editor-fold desc="Constructors">
    public DeviceContainer(String title, Node content) {
        super(title, content);
        this.managedProperty().bind(this.visibleProperty());
    }
    // </editor-fold>
}

