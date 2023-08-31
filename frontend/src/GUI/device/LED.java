// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import javafx.scene.control.Button;

public class LED extends Button {
    // <editor-fold  desc="Variables">
    // true if LED is on, false if LED is off
    public boolean status;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public LED() {
        this.setDisable(true);
        this.status = false;
//        this.setStyle("-fx-pref-height: 8; -fx-pref-width: 1; ");
        this.setDisplay();
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void setStatus(boolean status){
        this.status = status;
        this.setDisplay();
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void setDisplay(){
        if(! this.status){
            this.setStyle(" -fx-border-color:black; -fx-background-color: aliceblue");
        }else{
            this.setStyle(" -fx-background-color: red");
        }
    }
    // </editor-fold>
    // </editor-fold>
}
