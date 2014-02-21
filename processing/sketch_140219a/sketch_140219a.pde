/*
 * ZOOM-ABLE MANDELBROT SET 
 * on mouse click: x-axis determins zoom level, y-axis determines black/yellow colouring.
 */
// the max/min actual complex values
int resolution = 200;
int grid_delta = 50;
int max_inf_loop_count = 100;
int max_abs_count = 10;
int speed_multiplier = 3;

int pixel_offset_x = 150;
int pixel_offset_y = 0;

boolean showGrid = true;

double min_value_x;
double min_value_y;
double delta_value;



void reset() {
  clear();
  resolution = 200;
  grid_delta = 50;
  max_inf_loop_count = 100;
  max_abs_count = 200;
  speed_multiplier = 5; 
  pixel_offset_x = 0;
  pixel_offset_y = 0;
}

void setup() {  
  size(600, 600);
}

void initValues() {
  clear();
  // for now assume width = height
  min_value_x = (double) -width/(2 * resolution); 
  min_value_y = (double) -height/(2 * resolution); 
  double max_value = (double) width/(2 * resolution); // at x = width
  delta_value = (double) (max_value - min_value_x) / width; // ie value increase with 1 dx
  min_value_x -= delta_value * pixel_offset_x;
  min_value_y -= delta_value * pixel_offset_y;
}

void draw() {
  pushMatrix();
  initValues();
  fill(#000000);
  drawMandel();  
  if (showGrid) drawGrid();  
  popMatrix();
}

//void mousePressed() {
// resolution = mouseX;
// speed_multiplier = mouseY/10;
// if (mouseY > height/2) speed_multiplier *= -1;
//}

//void keyPressed() {
// switch (key) {
//   case BACKSPACE: 
//     reset();
//   break;
////   case 's': 
////     save("screenshot.png");
////   break;
// }
// 
// last_x = mouseX;
// last_y= mouseY;
// 
//}
//


void mouseDragged() {
  pixel_offset_x += (mouseX - pmouseX);
  pixel_offset_y += (mouseY - pmouseY);
}

void mouseWheel(MouseEvent event) {
  resolution += event.getAmount()*10;
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
      if ((speed = goesToInfinity(value_at_i_and_j)) > -1) {
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
int goesToInfinity(final Complex z) {

  Complex test = z;

  for (int count = 0; count < max_inf_loop_count; count++) {
    test = test.multiply(test).add(z);    
    if (test.isNaN() || test.abs() > max_abs_count) return count;
  }

  return -1;
}

