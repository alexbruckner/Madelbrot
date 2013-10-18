package com.bru.mandelbrot.math;

import org.junit.Assert;
import org.junit.Test;

public class ComplexTest {

    @Test
    public void test(){
        Complex c = new Complex(2,3);
        Assert.assertEquals(new Complex(-3, 15), Complex.plus(Complex.times(c, c), c)); // c * c + c
    }

}
