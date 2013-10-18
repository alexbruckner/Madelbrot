package com.bru.mandelbrot.math;

import org.junit.Test;

public class FunctionsTest {

    @Test
    public void testRecursion(){

        Complex c = new Complex(-2.0001, 0);  // reaches infinity in 17 steps
        System.out.println(Functions.mandel(c));

        c = new Complex(-2, 0);  // doesn't change until step limit is reached
        System.out.println(Functions.mandel(c));

        c = new Complex(2, 0);  // reaches infinity in 10 steps
        System.out.println(Functions.mandel(c));

        c = new Complex(0.1, 0);  // hardly changes until step limit is reached (but delta is pos -> inf?)
        System.out.println(Functions.mandel(c));

        c = new Complex(-0.1, 0);  // hardly changes until step limit is reached (but delta is neg -> 0)
        System.out.println(Functions.mandel(c));

        c = Complex.i;
        System.out.println(Functions.mandel(c));  // doesn't go to infinity but not zero either (but delta is pos)

        c = new Complex(-0.5, 0.5);
        System.out.println(Functions.mandel(c));

        c = new Complex(0.05, 0.1);
        System.out.println(Functions.mandel(c));

    }
}
