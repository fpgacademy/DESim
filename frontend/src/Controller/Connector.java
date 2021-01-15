// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Controller;

import GUI.ButtonConfigs;
import GUI.Main;
import GUI.devicecontainer.*;
import GUI.windows.Message;
import GUI.windows.MessageType;
import Shell.StartSimTask;
import javafx.application.Platform;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.Arrays;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Connector implements Runnable {

    // <editor-fold defaultstate="collapsed" desc="Private Constants">
    private static final Message MSG_SERVER_RUNNING =
            new Message("The server is running...", MessageType.INFO, false);
    private static final Message MSG_SERVER_FAILED =
            new Message("Server setup failed", MessageType.INFO, false);

    private static final Message MSG_CONNECTED =
            new Message("Connected to the simulator", MessageType.INFO, false);
    private static final Message MSG_CONNECTION_BROKEN =
            new Message("Connection broken to the simulator", MessageType.WARNING, false);
    private static final Message MSG_DISCONNECTED =
            new Message("Disconnected from the simulator", MessageType.INFO, false);
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private Socket socket = null;
    private boolean stopServerThread = false;
    private boolean serverThreadHasStopped = false;
    private PrintWriter signalOut;
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Run server
     */
    @Override
    public void run() {
        // starts the server
        try (ServerSocket listener = new ServerSocket(54321)) {
            Main.messageBox.addMessage(MSG_SERVER_RUNNING);

            // set # of clients to 1
            ExecutorService pool = Executors.newFixedThreadPool(1);

            // Set socket timeout to 0.5 second. This timeout allows for
            // gracefully shutdown of the server upon exit of this program
            listener.setSoTimeout(500);

            // listen for connection
            while (!stopServerThread) {
                // Do this first so that the exit conditions work correctly.
                // (As opposed to listening for a connection first)
                if (socket != null) {
                    // set output devices to initial state
                    clearSignal();
                    signalOut = new PrintWriter(socket.getOutputStream(), true);
                    pool.execute(new SigReceiver(socket));
                    // send initial input signals
                    sendInitSignal();
                }

                while (!stopServerThread) {
                    try {
                        socket = listener.accept();
                        // The accept didn't timeout therefore this loop should be exited
                        break;
                    } catch (SocketTimeoutException e) {
                    }
                }
            }
        } catch (IOException e) {
            Main.messageBox.addMessage(MSG_SERVER_FAILED);
        }finally{
            try {
                if(signalOut != null) {
                    signalOut.close();
                }
                if(socket != null) {
                    socket.close();
                }
            }catch(IOException ignored){

            }
        }
        serverThreadHasStopped = true;
    }

    public void stop() {
        // Tell the socket thread to exit
        stopServerThread = true;

        // Check if the socket thread has exited
        while (!serverThreadHasStopped) {
            // Give the socket thread a chance to exit.
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
            }
        };
    }

    public void sendSignal(String signal) {
        try {
            // send signal
            int padLen = 12 - signal.length();
            char[] charArray = new char[padLen];
            Arrays.fill(charArray, ' ');
            String str = new String(charArray);

            String padSignal = signal + str;
            signalOut.println(padSignal);
            System.out.println("Sent signal: " + padSignal);
        }
        // stop Signal Receiver if socket closed
        catch (NullPointerException ignored) {
        }
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void clearSignal(){
        Platform.runLater(() -> {
            ((LEDContainer) Main.nodeMap.get("LEDContainer")).reset();
            ((SevenSegContainer) Main.nodeMap.get("SevenSegContainer")).reset();
            ((KeyboardContainer) Main.nodeMap.get("KeyboardContainer")).reset();
            ((VGAContainer) Main.nodeMap.get("VGAContainer")).reset();
            ((GPIOContainer) Main.nodeMap.get("GPIOContainer")).reset();
        });
    }

    private void sendInitSignal(){
        SwitchContainer switchContainer = (SwitchContainer) Main.nodeMap.get("SwitchContainer");
        for(int i=0; i < switchContainer.getSwitchNum(); i++){
            if(switchContainer.getStatus(i)){
                sendSignal(Device.SW + " " + i + " " + "1");
            }
        }
        KeyContainer keyContainer = (KeyContainer) Main.nodeMap.get("KeyContainer");
        for(int i=0; i < keyContainer.getKeyNum(); i++){
            if(!keyContainer.getStatus(i)){
                sendSignal(Device.KEY + " " + i + " " + "0");
            }
        }

    }
    // </editor-fold>
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Nested Classes">
    /**
     * Receive and process simulator outputs
     */
    private static class SigReceiver implements Runnable {
        // <editor-fold defaultstate="collapsed" desc="Private Variables">
        private final Socket socket;
        private boolean connectError;
        // </editor-fold>

        // <editor-fold defaultstate="collapsed" desc="Private Constructors">
        private SigReceiver(Socket socket) {
            this.socket = socket;
            this.connectError = false;
        }
        // </editor-fold>

        // <editor-fold desc="Methods">
        @Override
        public void run() {
            Scanner in = null;
            PrintWriter out = null;
            try {
                in = new Scanner(socket.getInputStream());
                out = new PrintWriter(socket.getOutputStream(), true);

                Main.messageBox.addMessageFromThread(MSG_CONNECTED);
                // Enable the appropriate buttons
                Main.enableButtons(StartSimTask.SUCCESS_BTN_CFG);

                while (in.hasNextLine()) {
                    SignalParser.processSignal(in.nextLine());
                }

            } catch (Exception e) {
                this.connectError = true;
                Main.messageBox.addMessageFromThread(MSG_CONNECTION_BROKEN);

            } finally {
                try {
                    if (in != null) {
                        in.close();
                    }
                    if (out != null) {
                        out.close();
                    }
                    socket.close();
                } catch (IOException ignored) {}

                if (!connectError) {
                    System.out.println("Disconnect " + socket);
                    Main.messageBox.addMessageFromThread(MSG_DISCONNECTED);
                }

                // The simulator has discontinued. Make sure the buttons in the GUI
                // goes back to the compiled state.
                Platform.runLater(()->{
                    Main.enableButtons(ButtonConfigs.COMPILED);
                });
            }
        }
        // </editor-fold>
    }
    // </editor-fold>
}
