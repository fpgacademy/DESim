// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.device;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.geometry.Insets;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.image.PixelWriter;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;


public class VGA extends VBox {
    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final PixelWriter pixelWriter;
    private final Canvas canvas;
    private int screenHeight;
    private int screenWidth;
    private int resolutionLevel;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public VGA() {

        super();
        this.screenHeight = 480;
        this.screenWidth = 640;

        ToggleGroup group = new ToggleGroup();
        RadioButton lowRes = new RadioButton("160x120");
        RadioButton midRes = new RadioButton("320x240");
        RadioButton highRes = new RadioButton("640x480");
        lowRes.setToggleGroup(group);
        midRes.setToggleGroup(group);
        highRes.setToggleGroup(group);

        this.resolutionLevel = 0;
        lowRes.setSelected(true);


        HBox resolution = new HBox();
        resolution.getChildren().addAll(new Label("Resolution:"), lowRes, midRes, highRes);
        resolution.setSpacing(10);
        // Insets(double top, double right, double bottom, double left)
        VBox.setMargin(resolution, new Insets(20, 0, 0, 20));


        //------------------------------------------------------------------------------------

        canvas = new Canvas();
        this.getChildren().addAll(resolution, canvas);
        canvas.setHeight(screenHeight);
        canvas.setWidth(screenWidth);
        zoomCanvas((float) 0.5);

        GraphicsContext graphicsContext = canvas.getGraphicsContext2D();
        graphicsContext.setFill(Color.BLACK);
        graphicsContext.fillRect(0, 0, screenWidth, screenHeight);
        pixelWriter = graphicsContext.getPixelWriter();


        group.selectedToggleProperty().addListener(new ChangeListener<>() {
            public void changed(ObservableValue<? extends Toggle> ov,
                                Toggle old_toggle, Toggle new_toggle) {
                if (new_toggle == lowRes) {
                    resolutionLevel = 0;
                } else if (new_toggle == highRes) {
                    graphicsContext.setFill(Color.BLACK);
                    graphicsContext.fillRect(0, 0, screenWidth, screenHeight);
                    resolutionLevel = 2;
                } else {
                    graphicsContext.setFill(Color.BLACK);
                    graphicsContext.fillRect(0, 0, screenWidth, screenHeight);
                    resolutionLevel = 1;
                }
            }
        });
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    public void clearScreen(){
        GraphicsContext graphicsContext = canvas.getGraphicsContext2D();
        graphicsContext.setFill(Color.BLACK);
        graphicsContext.fillRect(0, 0, screenWidth, screenHeight);
    }

    public void setPixel(int x, int y, char pixel){
        if('0' <= pixel && pixel <= '7') {
            int c = pixel - '0';
            Color color = Color.rgb(255 * ((c >> 2) & 1), 255 * ((c >> 1) & 1), 255 * (c & 1));
            if (resolutionLevel == 2) {
                setPixelHighRes(x, y, color);
            } else if (resolutionLevel == 1) {
                setPixelMidRes(x, y, color);
            } else {
                setPixelLowRes(x, y, color);
            }
        }
    }

    /**
     * Setters and Getters
     */
    public void setScreenHeight(int screenHeight) {
        this.screenHeight = screenHeight;
    }

    public void setScreenWidth(int screenWidth) {
        this.screenWidth = screenWidth;
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    private void setPixelHighRes(int x, int y, Color color){
        pixelWriter.setColor(x, y, color);
    }

    private void setPixelMidRes(int x, int y, Color color){
        int xx = x*2;
        int yy = y*2;
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                pixelWriter.setColor(xx + i, yy + j, color);
            }
        }
    }

    private void setPixelLowRes(int x, int y, Color color){
        int xx = x*4;
        int yy = y*4;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                pixelWriter.setColor(xx + i, yy + j, color);
            }
        }
    }

    private void zoomCanvas(float scale) {
        canvas.setScaleX(scale);
        canvas.setScaleY(scale);
        if (scale < 1) {
            canvas.setTranslateX(320 * (scale - 1) + 20);
            canvas.setTranslateY(240 * (scale - 1) + 20);
        }
    }
    // </editor-fold>
    // </editor-fold>
}


