package com.bru.mandelbrot;

import com.bru.mandelbrot.math.Complex;
import com.bru.mandelbrot.math.Functions;

import javax.swing.*;
import java.awt.*;

public class Display extends JPanel {

    public static final boolean INVERSE = true;

    private static int min_x = -2;
    private static int max_x = 1;
    private static int min_y = -1;
    private static int max_y = 1;

    private int width;
    private int height;

    private double pixel_delta_x;
    private double pixel_delta_y;

    private volatile int[][] colours;
    private volatile double percentDone;

    public Display(int width, int height) {
        this.width = width;
        this.height = height;
        pixel_delta_x = (double) (max_x - min_x) / width;
        pixel_delta_y = (double) (max_y - min_y) / height;
    }

    private int[][] calculate() {
        percentDone = 1;

        int[][] colours = new int[width][height];

        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {

                double re = min_x + i * pixel_delta_x;
                double im = min_y + j * pixel_delta_y;
                Complex c = new Complex(re, im);

                Functions.ComplexResult result = Functions.mandel(c);

                colours[i][j] = interpret(result);
            }
            percentDone = (double) (i + 1) * 100 / width;
            repaint();
        }

        return colours;

    }

    private int interpret(Functions.ComplexResult result) {
        if (result.isNaNOrInfinite()) {
            // steps in percentage of step limit.
            int stepPercentage =  (int) result.getSteps() * 255 / Functions.STEP_LIMIT;
            if (!INVERSE) stepPercentage = 255 - stepPercentage;
            return new Color(stepPercentage, stepPercentage, stepPercentage).getRGB();
        } else {
            return Color.BLACK.getRGB();
        }
    }

    public void paint(Graphics g) {

        setBackground(Color.WHITE);

        if (colours == null) {
            g.clearRect(0, 0, width, height);
            Font font = new Font("Verdana", Font.BOLD, 12);
            g.setFont(font);
            g.setColor(Color.BLACK);
            g.drawString(String.format("Calculating the set...: %s %% done.", (int) percentDone), 10, 20);
            if (percentDone == 0) {
                new Thread() {
                    public void run() {
                        colours = calculate();
                        repaint();
                    }
                }.start();
            }
        } else {
            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    g.setColor(new Color(colours[i][j]));
                    g.drawLine(i, j, i, j);
                }
            }
        }

    }

    public static void main(String[] args) {
        Display p = new Display(800, 600);

        JFrame f = new JFrame();
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.getContentPane().add(p);

        f.setSize(p.width, p.height + 20);

        f.setVisible(true);
    }

}
