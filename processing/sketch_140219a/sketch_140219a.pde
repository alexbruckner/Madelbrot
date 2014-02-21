/*
 * ZOOM-ABLE MANDELBROT SET 
 * on mouse drag: move contents around
 * mouse wheel: increase resolution
 * space bar: show/hide grid
 * back space: reset
 * double-click: random color multiplier
 * key 1-9: change function to increase power by one
 * Author: Alex Bruckner Feb 2014
 */

int resolution = 200;
int grid_delta = 50;
int max_inf_loop_count = 100;
int max_abs_count = 10;
int speed_multiplier = 3;

int pixel_offset_x = 150;
int pixel_offset_y = 0;

boolean showGrid = true;
int function_power = 2;

double min_value_x;
double min_value_y;
double delta_value;


void reset() {
  clear();
  resolution = 200;
  grid_delta = 50;
  max_inf_loop_count = 100;
  max_abs_count = 10;
  speed_multiplier = 3;
  pixel_offset_x = 150;
  pixel_offset_y = 0;
  showGrid = true;
  function_power = 2;
}

void setup() {  
  size(800, 600);
}

void initValues() {
  //clear();
  // for now assume width = height
  min_value_x = (double) -width/(2 * resolution); 
  min_value_y = (double) -height/(2 * resolution); 
  double max_value = (double) width/(2 * resolution); // at x = width
  delta_value = (double) (max_value - min_value_x) / width; // ie value increase with 1 dx
  min_value_x -= delta_value * pixel_offset_x;
  min_value_y -= delta_value * pixel_offset_y;
}

void draw() {
  //pushMatrix();
  initValues();
  fill(#000000);
  drawMandel();  
  if (showGrid) drawGrid();  
  //popMatrix();
}

void keyPressed() {
  switch (key) {
  case BACKSPACE: 
    reset();
    break;
  case ' ': 
    showGrid = !showGrid;
    break;
  case 's': 
    save("screenshot.png");
    break;
  case '1':
    function_power = 1;
    break;
  case '2':
    function_power = 2;
    break;
  case '3':
    function_power = 3;
    break;
  case '4':
    function_power = 4;
    break;
  case '5':
    function_power = 5;
    break;
  case '6':
    function_power = 6;
    break;
  case '7':
    function_power = 7;
    break;
  case '8':
    function_power = 8;
    break;
  case '9':
    function_power = 9;
    break;
  case '0':
    function_power = 0;
    break;
    
  }
}

void mousePressed() {
  if (mouseEvent.getClickCount()==2) {
    speed_multiplier = new java.util.Random().nextInt();
  } 
}

void mouseDragged() {
  pixel_offset_x += (mouseX - pmouseX);
  pixel_offset_y += (mouseY - pmouseY);
}

void mouseWheel() {
  resolution +=mouseEvent.getAmount()*10;
}

void drawGrid() {

  double x_val = min_value_x;
  stroke(#FF0000);
  fill(#FF0000);
  textSize(8);

  for (int i = 0; i < width; i++) { 
    if (i % grid_delta == 0) {
      line(i, height/2-5, i, height/2+5); 
      text("" + roundToSignificantFigures(x_val, 2), i - 1, height/2+14);
    }
    x_val += delta_value;
  }

  double y_val = min_value_y; 
  for (int j = 0; j < width; j++) { 
    if (j % grid_delta == 0) {
      line(width/2 -5, j, width/2 +5, j); 
      text("" + roundToSignificantFigures(y_val, 2), width/2 +10, j + 3);
    }
    y_val += delta_value;
  }
}

double roundToSignificantFigures(double num, int n) {
  if (num == 0) {
    return 0;
  }

  final double d = Math.ceil(Math.log10(num < 0 ? -num: num));
  final int power = n - (int) d;

  final double magnitude = Math.pow(10, power);
  final long shifted = Math.round(num*magnitude);
  return shifted/magnitude;
}

void drawMandel() {
  loadPixels(); 
  double x_val = min_value_x;
  for (int i = 0; i < width; i++) {
    double y_val = min_value_y;
    for (int j = 0; j < height; j++) {

      Complex value_at_i_and_j = new Complex(x_val, y_val);

      int speed;
      if ((speed = goesToInfinity(value_at_i_and_j, function_power)) > -1) {
        //stroke(speed*speed_multiplier);
        pixels[i+j*width] = color(speed*speed_multiplier);
      } 
      else {
        //stroke(0);
        pixels[i+j*width] = 0;
      }

      //rect(i, j, 1, 1);
      y_val += delta_value;
    }
    x_val += delta_value;
  }
  updatePixels();
}

// helper classes and methods:

class Complex {
  double x;
  double y; 

  Complex(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Complex add(Complex another) {
    double real = x + another.x;
    double imag = y + another.y;
    return new Complex(real, imag);
  }

  Complex multiply(Complex another) {
    double real = x * another.x - y * another.y;
    double imag = x * another.y + y * another.x;   
    return new Complex(real, imag);
  }

  double abs() {
    return Math.sqrt(x * x + y * y);
  }
  public String toString() {
    return String.format("(%s,%s)", x, y);
  }

  boolean isNaN() {
    return Double.isNaN(x) || Double.isNaN(y) || Double.isInfinite(x) || Double.isInfinite(y);
  }
}

// Z <-> Z^2 + C  with initial Z = 0, if Z > cutoff after N iterations, position C -> inf.
int goesToInfinity(final Complex z, int power) {

  Complex test = z;

  for (int count = 0; count < max_inf_loop_count; count++) {
    test = pow(test, power).add(z);    
    if (test.isNaN() || test.abs() > max_abs_count) return count;
  }

  return -1;
}

Complex pow(Complex z, int power) {
   if (power == 0) return new Complex(1,0);
   Complex test = z;
   for (int i = 2; i <= power; i++){
      test = test.multiply(test);
   } 
   return test;
}




