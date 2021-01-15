// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.menu;

import GUI.Main;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.control.Menu;

public class DeviceMenu extends Menu {
    // <editor-fold desc="Constructors">
    public DeviceMenu(String text) {
        super(text);

        DeviceMenuItem ledItem = new DeviceMenuItem("LEDs", "LEDContainer");
        DeviceMenuItem switchItem = new DeviceMenuItem("Switches", "SwitchContainer");
        DeviceMenuItem keyItem = new DeviceMenuItem("Push Buttons", "KeyContainer");
        DeviceMenuItem hexItem = new DeviceMenuItem("Seven-segment Displays", "SevenSegContainer");
        DeviceMenuItem keyboardItem = new DeviceMenuItem("PS/2 Keyboard", "KeyboardContainer");
        DeviceMenuItem gpioItem = new DeviceMenuItem("Parallel Ports", "GPIOContainer");
        DeviceMenuItem vgaItem = new DeviceMenuItem("VGA Display", "VGAContainer");
        this.getItems().addAll(ledItem, switchItem, keyItem, hexItem, keyboardItem, gpioItem, vgaItem);
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Static Nested Class">
    private static class DeviceMenuItem extends CheckMenuItem {
        public DeviceMenuItem(String label, String container){
            super(label);
            this.setSelected(true);
            this.addEventHandler(ActionEvent.ACTION, new EventHandler<>() {
                @Override
                public void handle(ActionEvent actionEvent) {
                    Main.nodeMap.get(container).setVisible(((CheckMenuItem) actionEvent.getSource()).isSelected());

                }
            });
        }
    }
    // </editor-fold>
}
