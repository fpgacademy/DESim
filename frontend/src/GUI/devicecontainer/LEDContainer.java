// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.LED;
import javafx.scene.layout.FlowPane;

public class LEDContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final int NUMBER_OF_LEDS = 10;
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    public final LED[] leds;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public LEDContainer(){
        super("LEDs",  new FlowPane());

        FlowPane content = new FlowPane(4, 2);
        leds = new LED[NUMBER_OF_LEDS];

        for(int i = NUMBER_OF_LEDS - 1; i >= 0; i--) {
            leds[i] = new LED();
            content.getChildren().add(leds[i]);
        }


        super.setContent(content);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Reset all LEDs when simulation stops
     */
    public void reset(){
        for(int index = 0; index < NUMBER_OF_LEDS; index++){
            setLED(index, false);
        }
    }

    public void setLED(int index, boolean signal){
        if(index < 0 || index > NUMBER_OF_LEDS){
            throw new IndexOutOfBoundsException("Invalid LED index\n");
        }
        leds[index].setStatus(signal);
    }
    // </editor-fold>
}
