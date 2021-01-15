// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.SevenSeg;
import javafx.scene.layout.FlowPane;

public class SevenSegContainer extends DeviceContainer {
    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final int NUMBER_OF_SEGMENTS = 6;
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final SevenSeg[] sevenSegments;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public SevenSegContainer() {
        super("Seven-segment Displays", new FlowPane());

        FlowPane content = new FlowPane(4, 2);
        sevenSegments = new SevenSeg[NUMBER_OF_SEGMENTS];

        for (int i = NUMBER_OF_SEGMENTS - 1; i >= 0; i--) {
            sevenSegments[i] = new SevenSeg();
            content.getChildren().add(sevenSegments[i]);
        }


        super.setContent(content);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Reset all seven seg when simulation stops
     */
    public void reset(){
        for(int index = 0; index < NUMBER_OF_SEGMENTS; index++) {
            sevenSegments[index].setColor(false, 0);
        }
    }

    public void setSevenSegments(int index, boolean signal, int status){
        if(index < 0 || index > NUMBER_OF_SEGMENTS){
            throw new IndexOutOfBoundsException("Invalid 7-Seg index\n");
        }
        sevenSegments[index].setColor(signal, status);
    }
    // </editor-fold>
}

