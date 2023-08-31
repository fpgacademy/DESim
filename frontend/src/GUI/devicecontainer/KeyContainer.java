// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.KEY;
import javafx.scene.layout.FlowPane;

public class KeyContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final int NUMBER_OF_KEYS = 4;
    // </editor-fold>

    // <editor-fold  desc="Variables">
    public final KEY[] keys;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public KeyContainer() {
        super("Push Buttons", new FlowPane());

        FlowPane content = new FlowPane(2, 2);
        keys = new KEY[NUMBER_OF_KEYS];

        // Put KEY with larger index to the left
        for (int i = NUMBER_OF_KEYS - 1; i >= 0; i--) {
            keys[i] = new KEY(i);
            content.getChildren().add(keys[i]);
        }


        super.setContent(content);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Reset all push buttons when simulation stops
     */
    public void reset() {
        for(int i = 0; i < NUMBER_OF_KEYS; i++){
            keys[i].setStop();
        }
    }

    public boolean getStatus(int index){
        if(0 <= index && index < NUMBER_OF_KEYS) {
            return keys[index].getStatus();
        }
        return true;
    }

    /**
     * Setters and Getters
     */
    public int getKeyNum() {
        return this.NUMBER_OF_KEYS;
    }
    // </editor-fold>
}
