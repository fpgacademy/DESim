// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import javafx.scene.control.Button;

public class KeyboardLED extends Button {
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    // true if LED is on, false if LED is off
    private boolean status;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public KeyboardLED() {
        this.setDisable(true);
        this.status = false;
        this.setDisplay();
        this.setMaxSize(20,10);
        this.setMinSize(20,10);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Setters and Getters
     */
    public void setStatus(boolean status){
        this.status = status;
        this.setDisplay();
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void setDisplay(){
        if(! this.status){
            this.setStyle(" -fx-border-color:black; -fx-background-color: aliceblue;");
        }else{
            this.setStyle(" -fx-background-color: red;");
        }
    }
    // </editor-fold>
    // </editor-fold>
}

