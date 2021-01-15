// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import Controller.Device;
import GUI.Main;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;


public class Keyboard extends VBox {
    // <editor-fold defaultstate="collapsed" desc="Static Private Variables">
    private static Hashtable<String, String> inputConverter;
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final Label readFIFO;
    private final TextField inputBox;
    private final KeyboardLED[] lockLEDs;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public Keyboard() {
        setInputConverter();

        HBox readBox = new HBox();
        readBox.getChildren().add(new Label("Read FIFO "));
        readFIFO = new Label("");
        readBox.getChildren().add(readFIFO);
        this.getChildren().add(readBox);

        HBox inputBox = new HBox();
        inputBox.getChildren().add(new Label("Type Here "));
        this.inputBox = new TextField();
        inputBox.getChildren().add(this.inputBox);
        this.getChildren().add(inputBox);


        // Set styles
        readFIFO.setStyle("-fx-background-color: lightgray");
        readFIFO.setMinSize(150, 20);
        readBox.setStyle("-fx-padding: 8");
        inputBox.setStyle("-fx-padding: 8");


        this.inputBox.setOnKeyPressed(new EventHandler<>() {
            @Override
            public void handle(KeyEvent keyEvent) {
                String newInput = keyEvent.getCode().toString();

                // if is digit key
                if (newInput.startsWith("DIGIT")) {
                    newInput = newInput.substring(5);
                }
                String signal = inputConverter.get(newInput);
                if (signal != null) {
                    Main.connector.sendSignal(Device.KB + " " + signal);
                    updateReadFIFO(signal);
                }
            }
        });


        // TODO

        this.inputBox.setOnKeyReleased(new EventHandler<>() {
            @Override
            public void handle(KeyEvent keyEvent) {
                String newInput = keyEvent.getCode().toString();

                // if is digit key
                if (newInput.startsWith("DIGIT")) {
                    newInput = newInput.substring(5);
                }
                String signal = inputConverter.get(newInput);


                if (signal != null) {
                    Main.connector.sendSignal(Device.KB + " " + "F0");
                    Main.connector.sendSignal(Device.KB + " " + signal);
                    updateReadFIFO("F0 " + signal);
                }
            }
        });



        // Lock LEDs
        HBox lockBox = new HBox();
        KeyboardLED scrollLock = new KeyboardLED();
        lockBox.getChildren().addAll(scrollLock, new Label("Scroll Lock"));
        KeyboardLED numLock = new KeyboardLED();
        lockBox.getChildren().addAll(numLock, new Label("Num Lock"));
        KeyboardLED capsLock = new KeyboardLED();
        lockBox.getChildren().addAll(capsLock, new Label("Caps Lock"));
        this.getChildren().add(lockBox);

        // Bit 0: Scroll Lock, bit 1: Num Lock, Bit 2: Caps lock
        lockLEDs = new KeyboardLED[3];
        lockLEDs[0] = scrollLock;
        lockLEDs[1] = numLock;
        lockLEDs[2] = capsLock;

        // set styles
        lockBox.setPadding(new Insets(5, 20, 10, 20));
        HBox.setMargin(scrollLock, new Insets(3, 5, 0, 0));
        HBox.setMargin(numLock, new Insets(3, 5, 0, 25));
        HBox.setMargin(capsLock, new Insets(3, 5, 0, 25));
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void clearInput(){
        inputBox.clear();
    }

    public void clearFIFO() { readFIFO.setText(""); }

    public void setLockLED(int index, boolean status){
        lockLEDs[index].setStatus(status);

    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void updateReadFIFO(String signal){
        String newText = readFIFO.getText() + signal + " ";
        int len = newText.length();
        if(len < 27){
            readFIFO.setText(newText);
        }else{
            readFIFO.setText(newText.substring(len-27));
        }

    }

    /**
     * Construct key to scan code converter
     */
    // ToDo: extend to more keys
    private static void setInputConverter() {
        String delimiter = ",";
        inputConverter = new Hashtable<>();

        try(FileReader fr = new FileReader("." + File.separator + "scancode.csv");
            BufferedReader br = new BufferedReader(fr)){
            String line;
            String[] tempArr;
            while((line = br.readLine()) != null){
                tempArr = line.split(delimiter);
                inputConverter.put(tempArr[0], tempArr[1]);
            }
        }catch (IOException e) {
            System.err.println("Scan code read failed");
        }

    }
    // </editor-fold>
    // </editor-fold>
}
