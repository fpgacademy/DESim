// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.windows;

import javafx.application.Platform;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;

public class MessageBox extends VBox {
    // <editor-fold defaultstate="collapsed" desc="Private Static Methods">
    private static Text formatMessage(Message msg) {
        if ((msg == null) || (msg.txt == null))
            return null;

        Text text = new Text("");
        text.setStyle("-fx-font-size: 14;");

        if (msg.shell)
            text.setStyle("-fx-font-size: 12;-fx-font-style: italic;");

        text.setText(msg.txt);
        switch (msg.type) {
            case ERROR:
                text.setFill(Color.RED);
                break;
            case WARNING:
                text.setFill(Color.ORANGE);
                break;
            case INFO:
                if (msg.shell)
                    text.setFill(Color.GREY);
                else
                    text.setFill(Color.GREEN);
                break;

            default:
                text.setFill(Color.BLACK);
        }

        return text;
    }
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public MessageBox() {
        super.setSpacing(2.0);
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void addMessage(Message msg) {
        Text text = formatMessage(msg);
        this.getChildren().add(text);
    }

    public void addMessageFromThread(Message msg) {
        Platform.runLater(() -> {
            addMessage(msg);
        });
    }
    // </editor-fold>
}
