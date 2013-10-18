package com.bru.mandelbrot.math;

public final class Functions {
    private Functions() {
    }

    public static final int STEP_LIMIT = 45;

    // Z <=> Z^2 + C
    public static ComplexResult mandel(Complex c) {
        return recurse(c, c, 0);
    }

    private static ComplexResult recurse(Complex z, Complex c, long steps) {
        if (limit(z, steps)) return new ComplexResult(c, z, steps);
        else return recurse(Complex.plus(Complex.times(z, z), c), c, steps + 1);
    }

    private static boolean limit(Complex z, long steps) {
        return Complex.isNaN(z) || Complex.isInfinite(z) || steps >= STEP_LIMIT;
    }

    public static class ComplexResult {

        private Complex c;
        private Complex z;
        private long steps;

        public ComplexResult(Complex c, Complex z, long steps) {
            this.c = c;
            this.z = z;
            this.steps = steps;
        }

        public boolean isNaNOrInfinite() {
            return Complex.isNaN(z) || Complex.isInfinite(z);
        }

        public Complex getZ() {
            return z;
        }

        public Complex getC() {
            return c;
        }

        public long getSteps() {
            return steps;
        }

        @Override
        public String toString() {
            return "ComplexResult{" +
                    "c=" + c +
                    ", z=" + z +
                    ", steps=" + steps +
                    '}';
        }
    }
}
