import Controller.Device;
import GUI.Main;
import GUI.devicecontainer.*;
import com.sun.javafx.stage.StageHelper;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.embed.swing.JFXPanel;
import javafx.scene.paint.Paint;
import javafx.stage.Stage;
//import org.junit.Ignore;
import javafx.scene.paint.Color;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.opentest4j.AssertionFailedError;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.Canvas.*;
import java.io.File;
import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;


class MainTest {
    // Unused but needed to initialize JFX
    JFXPanel panel = new JFXPanel();
    static boolean inDemoDir = false;
    static String simulator = "Modelsim"; // this should actually be the name of the simulator
    static String language = "SystemVerilog";
    int currLEDVal = 0;

    static Thread t1 = new Thread(new Runnable() {
        @Override
        public void run() {

            if (simulator.equals("Questa")) {
                Main.main(new String[]{"--modelsim-path=C:\\intelFPGA\\21.1\\questa_fse\\win64"});
            }
            else {

                Main.main(new String[]{"--modelsim-path=C:\\intelFPGA\\19.1\\modelsim_ase\\win32aloem"});
            }

        }
    });

    // Helper functions
    void setSW(SwitchContainer swCont, int val) {
        int tempVal = val;
        boolean boxi = false;
        for (int i = 0; i<10; i++) { // rem = last digit in binary string, temp val gets right shifted
            int rem = tempVal % 2;
            tempVal = tempVal / 2;
            boxi = rem != 0;
            swCont.switches[i].checkBox.setSelected(boxi);
        }
        int ms = 50;
        if (simulator.equals("Questa")) {
            ms = 200;
        }
        try {
            TimeUnit.MILLISECONDS.sleep(ms);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    void pulseKey(KeyContainer keyCont, int key, int ms) {
        if (simulator.equals("Questa")) {
            ms = 3*ms;
        }
        keyCont.keys[key].checkBox.setSelected(false);
        try {
            TimeUnit.MILLISECONDS.sleep(ms);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        keyCont.keys[key].checkBox.setSelected(true);

        try {
            TimeUnit.MILLISECONDS.sleep(ms);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    void openCompileSimulate(String project) {

        Platform.runLater(new Runnable() {
            public void run() {
                Main.openProjButton.fire();
            }
        });

        Platform.runLater(new Runnable() {         // robot types demos\modelsim\systemverilog\projectname
            public void run() {
                try {
                    Robot robot = new Robot();
                    System.out.println(inDemoDir);
                    if (!inDemoDir) {
                        robot.keyPress(KeyEvent.VK_D);
                        robot.keyPress(KeyEvent.VK_E);
                        robot.keyPress(KeyEvent.VK_M);
                        robot.keyPress(KeyEvent.VK_O);
                        robot.keyPress(KeyEvent.VK_S);
                        robot.keyPress(KeyEvent.VK_ENTER);
                        robot.keyRelease(KeyEvent.VK_ENTER);

                        if (simulator.equals("Questa")) {
                            robot.keyPress(KeyEvent.VK_Q);
                            robot.keyPress(KeyEvent.VK_U);
                            robot.keyPress(KeyEvent.VK_E);
                            robot.keyPress(KeyEvent.VK_S);
                            robot.keyPress(KeyEvent.VK_T);
                            robot.keyPress(KeyEvent.VK_A);
                            robot.keyPress(KeyEvent.VK_S);
                            robot.keyPress(KeyEvent.VK_I);
                            robot.keyPress(KeyEvent.VK_M);
                            robot.keyPress(KeyEvent.VK_ENTER);
                            robot.keyRelease(KeyEvent.VK_ENTER);
                        }
                        else {
                            robot.keyPress(KeyEvent.VK_M);
                            robot.keyPress(KeyEvent.VK_O);
                            robot.keyPress(KeyEvent.VK_D);
                            robot.keyPress(KeyEvent.VK_E);
                            robot.keyPress(KeyEvent.VK_L);
                            robot.keyPress(KeyEvent.VK_S);
                            robot.keyPress(KeyEvent.VK_I);
                            robot.keyPress(KeyEvent.VK_M);
                            robot.keyPress(KeyEvent.VK_ENTER);
                            robot.keyRelease(KeyEvent.VK_ENTER);
                        }

                        if (language.equals("Verilog")) {
                            robot.keyPress(KeyEvent.VK_V);
                            robot.keyPress(KeyEvent.VK_E);
                            robot.keyPress(KeyEvent.VK_R);
                            robot.keyPress(KeyEvent.VK_I);
                            robot.keyPress(KeyEvent.VK_L);
                            robot.keyPress(KeyEvent.VK_O);
                            robot.keyPress(KeyEvent.VK_G);
                            robot.keyPress(KeyEvent.VK_ENTER);
                            robot.keyRelease(KeyEvent.VK_ENTER);
                        }
                        else if (language.equals("SystemVerilog")) {
                            robot.keyPress(KeyEvent.VK_S);
                            robot.keyPress(KeyEvent.VK_Y);
                            robot.keyPress(KeyEvent.VK_S);
                            robot.keyPress(KeyEvent.VK_T);
                            robot.keyPress(KeyEvent.VK_E);
                            robot.keyPress(KeyEvent.VK_M);
                            robot.keyPress(KeyEvent.VK_V);
                            robot.keyPress(KeyEvent.VK_E);
                            robot.keyPress(KeyEvent.VK_R);
                            robot.keyPress(KeyEvent.VK_I);
                            robot.keyPress(KeyEvent.VK_L);
                            robot.keyPress(KeyEvent.VK_O);
                            robot.keyPress(KeyEvent.VK_G);
                            robot.keyPress(KeyEvent.VK_ENTER);
                            robot.keyRelease(KeyEvent.VK_ENTER);
                        }
                        else {
                            robot.keyPress(KeyEvent.VK_V);
                            robot.keyPress(KeyEvent.VK_H);
                            robot.keyPress(KeyEvent.VK_D);
                            robot.keyPress(KeyEvent.VK_L);
                            robot.keyPress(KeyEvent.VK_ENTER);
                            robot.keyRelease(KeyEvent.VK_ENTER);
                        }


                        inDemoDir = true;
                    }

                    for (int i = 0; i < project.length(); i++) {
                        char c = project.charAt(i);
                        if (c == '_') {
                            robot.keyPress(KeyEvent.VK_SHIFT);
                            robot.keyPress(KeyEvent.VK_MINUS);
                            robot.keyRelease(KeyEvent.VK_SHIFT);
                        }

                        else if (Character.isUpperCase(c)) {
                            robot.keyPress(KeyEvent.VK_SHIFT);
                            robot.keyPress(c);
                            robot.keyRelease(KeyEvent.VK_SHIFT);
                        } else {

                        robot.keyPress(Character.toUpperCase(c));
                        }
                    }
                    robot.keyPress(KeyEvent.VK_ENTER);
                    robot.keyRelease(KeyEvent.VK_ENTER);
                    robot.keyPress(KeyEvent.VK_ENTER);
                    robot.keyRelease(KeyEvent.VK_ENTER);

                } catch (AWTException e) {
                    e.printStackTrace();
                }
            }
        });

        try {
            TimeUnit.SECONDS.sleep(3);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Platform.runLater(new Runnable() {
            public void run() {
                Main.compileButton.fire();
                System.out.println("Compiling");
            }
        });

        try {
            TimeUnit.SECONDS.sleep(3);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Platform.runLater(new Runnable() {
            public void run() {
                Main.startButton.fire();
                System.out.println("Simulating");
            }
        });

        try {
            TimeUnit.SECONDS.sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

    void stopSim() {
        Platform.runLater(new Runnable() {
            public void run() {
                Main.stopButton.fire();
            }
        });
    }

    @BeforeAll
    static void main() {
        t1.start();
    }

    @Test
    void accumulateSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }


        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");

        openCompileSimulate("accumulate");

        // Test 1: Assert 7 x 0 = 1
        setSW(swCont, 7);
        pulseKey(keyCont,0, 100);

        int ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);

        Assertions.assertEquals(0, ledrValue);

        // Test 2: Assert 7 x 6 = 42 -> (0011000111 = 199)
        setSW(swCont, 199);
        pulseKey(keyCont, 0, 100);


        ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);

        Assertions.assertEquals(42, ledrValue);


        // Test 3: Assert 17 x 31 = 527 (1111110001 = 1009)
        setSW(swCont, 1009);
        pulseKey(keyCont, 0, 100);

        ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);

        Assertions.assertEquals(527, ledrValue);

        stopSim();
    }

    @Test
    void addernSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");

        openCompileSimulate("addern");

        // Test 1: X=4, Y=0, Cin=0, Assert output = 4 (Set SW to 0000000100 = 4)
        setSW(swCont, 4);
        int ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);
        try {
            TimeUnit.MILLISECONDS.sleep(400);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Assertions.assertEquals(4, ledrValue);

        // Test 2: X=4, Y=6, Cin = 0, Assert output = 10 (Set SW to 0001100100 = 100 (decimal))
        setSW(swCont, 100);
        ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);
        try {
            TimeUnit.MILLISECONDS.sleep(400);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Assertions.assertEquals(10, ledrValue);

        // Test 3 : X = 4, Y = 14, Cin = 1, Assert output = 19 (Set SW to 1011100100 = 740)
        setSW(swCont, 740);
        ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2*(ledCont.leds[1].status ? 1 : 0) +
                4*(ledCont.leds[2].status ? 1 : 0) +
                8*(ledCont.leds[3].status ? 1 : 0) +
                16*(ledCont.leds[4].status ? 1 : 0) +
                32*(ledCont.leds[5].status ? 1 : 0) +
                64*(ledCont.leds[6].status ? 1 : 0) +
                128*(ledCont.leds[7].status ? 1 : 0) +
                256*(ledCont.leds[8].status ? 1 : 0) +
                512*(ledCont.leds[9].status ? 1 : 0);
        try {
            TimeUnit.MILLISECONDS.sleep(400);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Assertions.assertEquals(19, ledrValue);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @Test
    void counterSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        String path = System.getenv("PATH");
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");

        openCompileSimulate("counter");

        pulseKey(keyCont, 0, 200);

        int ledrValue1 = (ledCont.leds[0].status ? 1 : 0) +
                2 * (ledCont.leds[1].status ? 1 : 0) +
                4 * (ledCont.leds[2].status ? 1 : 0) +
                8 * (ledCont.leds[3].status ? 1 : 0) +
                16 * (ledCont.leds[4].status ? 1 : 0) +
                32 * (ledCont.leds[5].status ? 1 : 0) +
                64 * (ledCont.leds[6].status ? 1 : 0) +
                128 * (ledCont.leds[7].status ? 1 : 0) +
                256 * (ledCont.leds[8].status ? 1 : 0) +
                512 * (ledCont.leds[9].status ? 1 : 0);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        int ledrValue2 = (ledCont.leds[0].status ? 1 : 0) +
                2 * (ledCont.leds[1].status ? 1 : 0) +
                4 * (ledCont.leds[2].status ? 1 : 0) +
                8 * (ledCont.leds[3].status ? 1 : 0) +
                16 * (ledCont.leds[4].status ? 1 : 0) +
                32 * (ledCont.leds[5].status ? 1 : 0) +
                64 * (ledCont.leds[6].status ? 1 : 0) +
                128 * (ledCont.leds[7].status ? 1 : 0) +
                256 * (ledCont.leds[8].status ? 1 : 0) +
                512 * (ledCont.leds[9].status ? 1 : 0);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        int ledrValue3 = (ledCont.leds[0].status ? 1 : 0) +
                2 * (ledCont.leds[1].status ? 1 : 0) +
                4 * (ledCont.leds[2].status ? 1 : 0) +
                8 * (ledCont.leds[3].status ? 1 : 0) +
                16 * (ledCont.leds[4].status ? 1 : 0) +
                32 * (ledCont.leds[5].status ? 1 : 0) +
                64 * (ledCont.leds[6].status ? 1 : 0) +
                128 * (ledCont.leds[7].status ? 1 : 0) +
                256 * (ledCont.leds[8].status ? 1 : 0) +
                512 * (ledCont.leds[9].status ? 1 : 0);


        boolean counting = 2*ledrValue2-ledrValue1 - 5 < ledrValue3 && 2*ledrValue2-ledrValue1 + 5 > ledrValue3;
        Assertions.assertTrue(counting);


        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

//    @Test
//    void counterLPMSim() {
//        try {
//            TimeUnit.SECONDS.sleep(1);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
//        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
//        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");
//
//        openCompileSimulate("Counter_LPM");
//
//        int ledrValue1 = (ledCont.leds[0].status ? 1 : 0) +
//                2 * (ledCont.leds[1].status ? 1 : 0) +
//                4 * (ledCont.leds[2].status ? 1 : 0) +
//                8 * (ledCont.leds[3].status ? 1 : 0) +
//                16 * (ledCont.leds[4].status ? 1 : 0) +
//                32 * (ledCont.leds[5].status ? 1 : 0) +
//                64 * (ledCont.leds[6].status ? 1 : 0) +
//                128 * (ledCont.leds[7].status ? 1 : 0) +
//                256 * (ledCont.leds[8].status ? 1 : 0) +
//                512 * (ledCont.leds[9].status ? 1 : 0);
//
//        try {
//            TimeUnit.SECONDS.sleep(1);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        int ledrValue2 = (ledCont.leds[0].status ? 1 : 0) +
//                2 * (ledCont.leds[1].status ? 1 : 0) +
//                4 * (ledCont.leds[2].status ? 1 : 0) +
//                8 * (ledCont.leds[3].status ? 1 : 0) +
//                16 * (ledCont.leds[4].status ? 1 : 0) +
//                32 * (ledCont.leds[5].status ? 1 : 0) +
//                64 * (ledCont.leds[6].status ? 1 : 0) +
//                128 * (ledCont.leds[7].status ? 1 : 0) +
//                256 * (ledCont.leds[8].status ? 1 : 0) +
//                512 * (ledCont.leds[9].status ? 1 : 0);
//
//        try {
//            TimeUnit.SECONDS.sleep(1);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        int ledrValue3 = (ledCont.leds[0].status ? 1 : 0) +
//                2 * (ledCont.leds[1].status ? 1 : 0) +
//                4 * (ledCont.leds[2].status ? 1 : 0) +
//                8 * (ledCont.leds[3].status ? 1 : 0) +
//                16 * (ledCont.leds[4].status ? 1 : 0) +
//                32 * (ledCont.leds[5].status ? 1 : 0) +
//                64 * (ledCont.leds[6].status ? 1 : 0) +
//                128 * (ledCont.leds[7].status ? 1 : 0) +
//                256 * (ledCont.leds[8].status ? 1 : 0) +
//                512 * (ledCont.leds[9].status ? 1 : 0);
//
//
//        boolean counting = 2*ledrValue2-ledrValue1 - 5 < ledrValue3 && 2*ledrValue2-ledrValue1 + 5 > ledrValue3;
//        Assertions.assertTrue(counting);
//
//        try {
//            TimeUnit.SECONDS.sleep(1);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        stopSim();
//    }

    @Test
    void displaySim() {

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");
        SevenSegContainer ssCont = (SevenSegContainer) Main.nodeMap.get("SevenSegContainer");

        openCompileSimulate("display");

        setSW(swCont, 0);
        pulseKey(keyCont, 0, 100);

        int hexValue = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);

        // A corresponds to hexValue of 119.
        Assertions.assertEquals(119, hexValue);

        setSW(swCont, 1);
        pulseKey(keyCont, 0, 100);
        pulseKey(keyCont, 0, 100);

        hexValue = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);

        // B corresponds to hex value of 124
        Assertions.assertEquals(124, hexValue);
        pulseKey(keyCont, 0, 100);

        hexValue = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);

        // C corresponds to hex value of 57
        Assertions.assertEquals(57, hexValue);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @Test
    void gpioSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        GPIOContainer gpioCont = (GPIOContainer) Main.nodeMap.get("GPIOContainer");

        openCompileSimulate("gpio");

        // Load inputs with fibonacci
        int a = 1;
        int b = 1;
        int c = 1;
        for (int i=0;i<16;i++) {
            if (i == c) {
                gpioCont.setGPIO(i, true);
                a = b;
                b = c;
                c = a + b;
                System.out.println(i);
            }
            else {
                gpioCont.setGPIO(i, false);
            }
        }

        setSW(swCont, 0);

        Assertions.assertEquals(gpioCont.ports[16].statusBox.isSelected(), gpioCont.ports[0].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[21].statusBox.isSelected(), gpioCont.ports[5].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[25].statusBox.isSelected(), gpioCont.ports[9].statusBox.isSelected());

        setSW(swCont, 1);

        Assertions.assertEquals(gpioCont.ports[16].statusBox.isSelected(), gpioCont.ports[9].statusBox.isSelected() || gpioCont.ports[1].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[19].statusBox.isSelected(), gpioCont.ports[11].statusBox.isSelected() || gpioCont.ports[3].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[23].statusBox.isSelected(), gpioCont.ports[15].statusBox.isSelected() || gpioCont.ports[7].statusBox.isSelected());

        setSW(swCont, 2);

        Assertions.assertEquals(gpioCont.ports[16].statusBox.isSelected(), gpioCont.ports[9].statusBox.isSelected() && gpioCont.ports[1].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[19].statusBox.isSelected(), gpioCont.ports[11].statusBox.isSelected() && gpioCont.ports[3].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[23].statusBox.isSelected(), gpioCont.ports[15].statusBox.isSelected() && gpioCont.ports[7].statusBox.isSelected());

        setSW(swCont, 3);

        Assertions.assertEquals(gpioCont.ports[16].statusBox.isSelected(), gpioCont.ports[9].statusBox.isSelected() ^ gpioCont.ports[1].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[19].statusBox.isSelected(), gpioCont.ports[11].statusBox.isSelected() ^ gpioCont.ports[3].statusBox.isSelected());
        Assertions.assertEquals(gpioCont.ports[23].statusBox.isSelected(), gpioCont.ports[15].statusBox.isSelected() ^ gpioCont.ports[7].statusBox.isSelected());


        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @Test
    void ps2demoSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");
        SevenSegContainer ssCont = (SevenSegContainer) Main.nodeMap.get("SevenSegContainer");

        openCompileSimulate("ps2_demo");

        setSW(swCont, 0);
        pulseKey(keyCont, 0, 100);
        keyCont.keys[0].checkBox.setSelected(true);

        setSW(swCont, Integer.parseInt("EE",16));
        pulseKey(keyCont, 1, 100);


        int hexValue0 = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);
        int hexValue1 = (ssCont.sevenSegments[1].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[1].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[1].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[1].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[1].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[1].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[1].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);

        // E corresponds to 121 hex value
        Assertions.assertEquals(121, hexValue0);
        Assertions.assertEquals(121, hexValue1);

        setSW(swCont, Integer.parseInt("ED",16));
        pulseKey(keyCont, 1, 100);

        hexValue0 = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);
        hexValue1 = (ssCont.sevenSegments[1].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[1].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[1].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[1].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[1].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[1].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[1].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);


        // F is 119, A is 113
        Assertions.assertEquals(119, hexValue0);
        Assertions.assertEquals(113, hexValue1);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @Test
    void ledhexSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        LEDContainer ledCont = (LEDContainer) Main.nodeMap.get("LEDContainer");
        SevenSegContainer ssCont = (SevenSegContainer) Main.nodeMap.get("SevenSegContainer");

        openCompileSimulate("led_hex");

        setSW(swCont, 0);
        pulseKey(keyCont, 0, 100);

        setSW(swCont, 42);

        int ledrValue = (ledCont.leds[0].status ? 1 : 0) +
                2 * (ledCont.leds[1].status ? 1 : 0) +
                4 * (ledCont.leds[2].status ? 1 : 0) +
                8 * (ledCont.leds[3].status ? 1 : 0) +
                16 * (ledCont.leds[4].status ? 1 : 0) +
                32 * (ledCont.leds[5].status ? 1 : 0) +
                64 * (ledCont.leds[6].status ? 1 : 0) +
                128 * (ledCont.leds[7].status ? 1 : 0) +
                256 * (ledCont.leds[8].status ? 1 : 0) +
                512 * (ledCont.leds[9].status ? 1 : 0);

        int hexValue = (ssCont.sevenSegments[0].strokes[0].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                2 * (ssCont.sevenSegments[0].strokes[1].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                4 * (ssCont.sevenSegments[0].strokes[2].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                8 * (ssCont.sevenSegments[0].strokes[3].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                16 * (ssCont.sevenSegments[0].strokes[4].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                32 * (ssCont.sevenSegments[0].strokes[5].getFill().equals(Color.ORANGERED) ? 1 : 0) +
                64 * (ssCont.sevenSegments[0].strokes[6].getFill().equals(Color.ORANGERED) ? 1 : 0);

        Assertions.assertEquals(85, hexValue);
        Assertions.assertEquals(42, ledrValue);

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @Test
    void vgaSim() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }


        SwitchContainer swCont = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        KeyContainer keyCont = (KeyContainer) Main.nodeMap.get("KeyContainer");
        VGAContainer vgaCont = (VGAContainer) Main.nodeMap.get("VGAContainer");

        openCompileSimulate("vga_demo");

        setSW(swCont, 0);
        pulseKey(keyCont, 0, 100);


        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopSim();
    }

    @AfterAll
    static void endTesting() {
        try {
            Platform.exit();
            t1.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

}