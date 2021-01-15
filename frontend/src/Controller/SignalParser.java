// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Controller;

import GUI.Main;
import GUI.devicecontainer.*;
import javafx.application.Platform;


/**
 * To parse incoming signals and control corresponding devices
 */
public final class SignalParser {

    // <editor-fold desc="Static Methods">
    public static void processSignal(String line) {
        if (line == null)
            return;

        if (line.startsWith("h")) {
            processHEXSignal(line);
        } else if (line.startsWith("l")) {
            processLEDSignal(line);
        } else if (line.startsWith("g")) {
            processGPIOSignal(line);
        } else if (line.startsWith("p")) {
            processPS2Lock(line);
        } else if (line.startsWith("c")) {
            /* Parser for individual pixel colours */
            /* Expected syntax: c ### ### #, where the first three
             * digits are the x coordinate, the next three are the y coordinate,
             * and the last is the colour, a digit from 0 to 7 */
            processVGASignal(line);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="Private Static Methods">
    private static void processVGASignal(String line) {
        VGAContainer vgaContainer = (VGAContainer) Main.nodeMap.get("VGAContainer");

        if(line.length() > 3) {
            // javafx functions should execute on only one thread
            Platform.runLater(() -> {
                vgaContainer.setPixel(line.substring(2));
            });
        }

    }

    private static void processPS2Lock(String line) {
        KeyboardContainer keyboardContainer = (KeyboardContainer) Main.nodeMap.get("KeyboardContainer");
        try {
            String binary_string = line.strip().substring(1);
            int length = binary_string.length();
            for (int i = 0; i < 3 && i < length; i++) {
                final int index = i;
                Platform.runLater(()->{
                    keyboardContainer.setLockLED(index, binary_string.charAt(length - index - 1) == '1');
                });
            }
        } catch (StringIndexOutOfBoundsException ignored) {
        }
    }

    private static void processLEDSignal(String line) {
        try {
            LEDContainer container = (LEDContainer) Main.nodeMap.get("LEDContainer");
            String binary_string = line.strip().substring(1);
            int length = binary_string.length();
            for (int i = 0; i < 10 && i < length; i++) {
                final int index = i;
                Platform.runLater(()->{
                    // binary string starts with highest bit, so using length-i-1
                    container.setLED(index, binary_string.charAt(length - index - 1) == '1');
                });
            }
        } catch (StringIndexOutOfBoundsException ignored) {
        }
    }

    private static void processGPIOSignal(String line) {
        try {
            GPIOContainer container = (GPIOContainer) Main.nodeMap.get("GPIOContainer");
            String binary_string = line.strip().substring(1);
            int length = binary_string.length();

            for (int i = 0; i < 32 && i < length; i++) {
                char gpio = Character.toLowerCase(binary_string.charAt(length - i - 1));
                if (gpio != 'z' && gpio != 'x' && gpio != 'Z' && gpio != 'X') {
                    final int index = i;
                    Platform.runLater(()->{
                        container.setGPIO(index,  gpio == '1');
                    });
                }
            }

        } catch (StringIndexOutOfBoundsException ignored) {
        }
    }

    private static void processHEXSignal(String line) {
        try {
            SevenSegContainer container = (SevenSegContainer) Main.nodeMap.get("SevenSegContainer");
            String hex_string = line.strip().substring(1);

            for (int i = 0; i < hex_string.length() / 2; i++) {
                final int index = i;
                char hex_char = hex_string.charAt(2*i);
                if (hex_char == 'z' || hex_char == 'x' || hex_char == 'X' || hex_char == 'Z') {
                    Platform.runLater(()->{
                        container.setSevenSegments(index, false, 0);
                    });
                } else {
                    try {
                        int val = 127 - Integer.parseInt(hex_string.substring(2 * i, 2 * i + 2), 16);
                        Platform.runLater(()->{
                            container.setSevenSegments(index, true, val);
                        });
                    } catch (Exception e) {
                        System.err.println("Invalid hex value: " + hex_string);
                    }
                }
            }
        } catch (StringIndexOutOfBoundsException ignored) {
        }

    }
    // </editor-fold>
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Constructors">
    /**
     * This class has only static methods (no field nor any non-static methods).
     * Therefore, an object of this class is not required.
     */
    private SignalParser() {
    }
    // </editor-fold>
}


