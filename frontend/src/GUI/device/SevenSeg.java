// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import javafx.scene.Group;
import javafx.scene.layout.AnchorPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.*;

/**
 *       0
 *     -----
 * 5  |    | 1
 *    --6--
 * 4 |    | 2
 *   -----
 *     3
 */
public class SevenSeg extends AnchorPane {
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    public final Rectangle[] strokes;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public SevenSeg() {
        super();
        this.setHeight(80);
        this.setWidth(72);
        this.setStyle("-fx-background-color: lightgray; -fx-padding: 4px");
        Group group = new Group();
        this.getChildren().add(group);

        strokes = new Rectangle[7];
        strokes[0] = new Rectangle(24, 4);
        strokes[0].setX(11);
        strokes[0].setY(7);

        strokes[3] = new Rectangle(24, 4);
        strokes[3].setX(11);
        strokes[3].setY(63);

        strokes[6] = new Rectangle(24, 4);
        strokes[6].setX(11);
        strokes[6].setY(35);


        strokes[1] = new Rectangle(4, 24);
        strokes[1].setX(35);
        strokes[1].setY(11);
        strokes[2] = new Rectangle(4, 24);
        strokes[2].setX(35);
        strokes[2].setY(39);

        strokes[4] = new Rectangle(4, 24);
        strokes[4].setX(7);
        strokes[4].setY(39);

        strokes[5] = new Rectangle(4, 24);
        strokes[5].setX(7);
        strokes[5].setY(11);


        for (int i = 0; i < 7; i++) {
            group.getChildren().add(strokes[i]);
            strokes[i].setFill(Color.WHITE);
        }

    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void setColor(boolean signal, int val) {
        if (signal) {
            for (int i = 0; i < 7; i++) {
                if (decodeColor(val, i)) {
                    strokes[i].setFill(Color.ORANGERED);
                } else {
                    strokes[i].setFill(Color.WHITE);
                }
            }
        } else {
            for (int i = 0; i < 7; i++) {
                strokes[i].setFill(Color.WHITE);

            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private boolean decodeColor(int val, int shift) {
        return ((val >> shift) & 1) == 1;
    }
    // </editor-fold>
    // </editor-fold>
}
