// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.Keyboard;


public class KeyboardContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final Keyboard keyboard;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public KeyboardContainer() {
        super("PS/2 Keyboard", new Keyboard());
        keyboard = new Keyboard();
        this.setContent(keyboard);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void setLockLED(int index, boolean status) {
        if(index < 0 || index > 3){
            throw new IndexOutOfBoundsException("Invalid PS2 lock index\n");
        }
        keyboard.setLockLED(index, status);
    }

    public void reset() {
        keyboard.clearInput();
        keyboard.clearFIFO();
        // turn off lock LEDs
        for (int i = 0; i < 3; i++) {
            keyboard.setLockLED(i, false);
        }
    }
    // </editor-fold>
}
