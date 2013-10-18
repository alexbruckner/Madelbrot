package com.bru.mandelbrot.math;

public class Complex {

    public static final Complex zero = new Complex(0, 0);
    public static final Complex i = new Complex(0, 1);

    private final double re;   // the real part
    private final double im;   // the imaginary part

    // create a new object with the given real and imaginary parts
    public Complex(double real, double imag) {
        re = real;
        im = imag;
    }

    // return a string representation of the invoking Complex object
    public String toString() {
        if (im == 0) return re + "";
        if (re == 0) return im + "i";
        if (im < 0) return re + " - " + (-im) + "i";
        return re + " + " + im + "i";
    }

    // return a new Complex object whose value is (this + b)
    public static Complex plus(Complex a, Complex b) {
        double real = a.re + b.re;
        double imag = a.im + b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this * b)
    public static Complex times(Complex a, Complex b) {
        double real = a.re * b.re - a.im * b.im;
        double imag = a.re * b.im + a.im * b.re;
        return new Complex(real, imag);
    }

    public static double abs(Complex a) {
        return Math.sqrt(a.re * a.re + a.im * a.im);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Complex complex = (Complex) o;

        if (Double.compare(complex.im, im) != 0) return false;
        if (Double.compare(complex.re, re) != 0) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        temp = Double.doubleToLongBits(re);
        result = (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(im);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }

    public double getRe() {
        return re;
    }

    public double getIm() {
        return im;
    }

    public static boolean isNaN(Complex a) {
        return Double.isNaN(a.re) || Double.isNaN(a.im);
    }

    public static boolean isInfinite(Complex a) {
        return Double.isInfinite(a.re) || Double.isInfinite(a.im);
    }

}