// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.Switch;
import javafx.scene.layout.FlowPane;


public class SwitchContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final int NUMBER_OF_SWITCHES = 10;
    // </editor-fold>

    // <editor-fold desc="Variables">
    public final Switch[] switches;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public SwitchContainer(){
        super("Switches",  new FlowPane());

        FlowPane content = new FlowPane(2, 2);
        switches = new Switch[NUMBER_OF_SWITCHES];

        for(int i = NUMBER_OF_SWITCHES - 1; i >= 0; i--) {
            switches[i] = new Switch(i);
            content.getChildren().add(switches[i]);
        }


        super.setContent(content);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void reset(){
        for(int i = 0; i < NUMBER_OF_SWITCHES; i++){
            switches[i].setStop();
        }
    }

    public boolean getStatus(int index){
        if(0 <= index && index < NUMBER_OF_SWITCHES) {
            return switches[index].getStatus();
        }
        return false;
    }

    /**
     *  Setters and Getters
     */
    public int getSwitchNum() {
        return this.NUMBER_OF_SWITCHES;
    }
    // </editor-fold>
}
