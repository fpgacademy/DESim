// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.devicecontainer;

import GUI.DeviceContainer;
import GUI.device.VGA;

public class VGAContainer extends DeviceContainer{
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final VGA vga;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public VGAContainer() {
        super("VGA Display", new VGA());
        vga = new VGA();
        this.setContent(vga);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void setPixel(String pixelLine){
        String[] data = pixelLine.split(" ");
        try {
            final int x = Integer.parseInt(data[0]);
            final int y = Integer.parseInt(data[1]);
            final char color = data[2].charAt(0);
            vga.setPixel(x, y, color);
        }catch(NumberFormatException | IndexOutOfBoundsException ignored){}

    }

    public void reset(){
        vga.clearScreen();
    }
    // </editor-fold>
}
