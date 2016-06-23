class VisualP {
  int[] prevFrame;  // previous frame for movement sensor
  int seed;         // seed for noise
  float xoff, yoff; // noise offsets
  float[][] shMatrix = {{-1, -1, -1},  // matrix used for sharpen command
                        {-1,  9, -1},
                        {-1, -1, -1}};
  
  VisualP() {
    seed = (int) random(10000);
    xoff = 0.0;
    yoff = 0.0;
    prevFrame = null;
  }

  /* Creates a Vertical reflection from the input image.
   float posY = center of reflection block
   PImage img = source image
   int mode  0: reflects LOWER part
             1: reflects UPPER part
   */
  PImage MirrorY(PImage img, float posY, int mode) {
    // Create and load target image
    PImage mirrorImg = new PImage(img.width, img.height, HSB);
    mirrorImg.loadPixels();
    // Establish position + upper and lower limits
    int mirPos = img.height/2;
    int upBound = constrain((int) posY-img.height/4, 0, img.height/2-1);
    int lowBound = upBound+img.height/2;
    // Go over all the pixels in the target image
    for (int x=0; x<img.width; x++) {
      for (int y=0; y<img.height; y++) {
        int loc = x +y*img.width;    // Array pixel location
        int mirDif = abs(mirPos-y);  // Height difference
        int y2 = 0;                  // Variable initialization
        // Sets reflection location
        if (mode == 0) {
          y2 = constrain(lowBound-mirDif, 0, img.height-1);
        } else {
          y2 = constrain(upBound+mirDif, 0, img.height-1);
        }
        int loc2 = x +y2*img.width;  // Get SOURCE location
        color c = img.pixels[loc2];  // Get SOURCE pixel
        mirrorImg.pixels[loc] = c;   // Paste in proper location 
      }
    }
    mirrorImg.updatePixels();
    return mirrorImg;
  }
  
  /* Creates a Horizontal reflection from the input image.
   float posX = center of reflection block
   PImage img = source image
   int mode  0: reflects LEFT part
             1: reflects RIGHT part
   */
  PImage MirrorX(PImage img, float posX, int mode) {
    // Create and load target image
    PImage mirrorImg = new PImage(img.width, img.height, HSB);
    mirrorImg.loadPixels();
    // Establish position + left and right limits
    int mirPos = img.width/2;
    int lBound = constrain((int) posX-img.width/4, 0, img.width/2-1);
    int rBound = lBound+img.width/2;
    // Go over all the pixels in the target image
    for (int x=0; x<img.width; x++) {
      for (int y=0; y<img.height; y++) {
        int loc = x +y*img.width;    // Array pixel location
        int mirDif = abs(mirPos-x);  // Height difference
        int x2 = 0;                  // Variable initialization
        // Sets reflection location
        if (mode == 0) {
          x2 = constrain(rBound-mirDif, 0, img.width-1);
        } else {
          x2 = constrain(lBound+mirDif, 0, img.width-1);
        }
        int loc2 = x2 +y*img.width;  // Get SOURCE location
        color c = img.pixels[loc2];  // Get SOURCE pixel
        mirrorImg.pixels[loc] = c;   // Paste in proper location 
      }
    }
    mirrorImg.updatePixels();
    return mirrorImg;
  }
  
  PImage CentralMirror(PImage img, float posX){
    PImage mirror = new PImage(img.width, img.height);
    int mirPos = img.width/3;
    int lBound = constrain((int) posX-img.width/6, 0, img.width*5/6-1);
    int rBound = lBound+img.width/6;
    for(int x=0; x<img.width; x++){
      for(int y=0; y<img.height; y++){
        int loc = x+y*img.width;
        int mirDif = abs(mirPos -x);
        int x2 = lBound +mirDif;
        x2 = constrain(x2, 0, img.width-1);
        int loc2 = x2 +y*width;
        color c = img.pixels[loc2];
        mirror.pixels[loc] = c;
      }
    }
    return mirror;
  }
  
  PImage ThreeBars(PImage img, float posX){
    PImage bar = new PImage(img.width, img.height);
    int lBound = constrain((int) posX-img.width/6, 0, img.width*5/6-1);
    //int rBound = lBound+img.width/6;
    for(int x=0; x<img.width; x++){
      for(int y=0; y<img.height; y++){
        int loc = x+y*img.width;
        int x2 = lBound + x%(img.width/3);
        int loc2 = x2 +y*width;
        color c = img.pixels[loc2];
        bar.pixels[loc] = c;
      }
    }
    return bar;
  }
  
  /* Creates a motion sensor by sending the image to grayscale and comparing
     the brightness level of the current frame with the previous one.
  */
  PImage MotionSensor(PImage img){
    PImage sensor = new PImage(img.width, img.height);
    img.filter(GRAY); // Send image to grayscale
    // If there's no previous frame saved, saves the current one and
    // waits for the next one
    if (prevFrame == null){
      sensor = img;
    } else {
      // Load image pixels
      img.loadPixels();
      sensor.loadPixels();
      for(int x=0; x<sensor.width; x++){
        for(int y=0; y<sensor.height; y++){
          int loc = x +y*sensor.width;  // current location on array
          int bright = (int) brightness(img.pixels[loc]);  // pixel brightness
          int diff = abs(bright - prevFrame[loc]);  // brightness difference
          sensor.pixels[loc] = color(diff);  // new pixel color (grayscale)
        }
      }
    }
    prevFrame = getBrightArray(img);
    return sensor;
  }
  
  /* Method returns a 1D array of the brightness level of each pixel */
  int[] getBrightArray(PImage img){
    int[] array = new int[width*height];  // Initialize array
    img.loadPixels();
    for(int x=0; x<width; x++){
      for(int y=0; y<height; y++){
        int loc = x +y*width;             // Location of each pixel
        array[loc] = (int) brightness(img.pixels[loc]);  // save Brightness level
      }
    }
    return array;
  }
  
  /* Creates a crystalized effect from the current image */
  PImage Crystal(PImage img, int sides, int cellSize){
    noiseSeed(seed);                // Loads noise seed
    PImage crystals = new PImage(img.width, img.height);  // new image
    int cols = img.width/cellSize;  // Number of columns
    int rows = img.height/cellSize; // Number of rows
    colorMode(HSB);
    img.loadPixels();
    for(int i=0; i<cols; i++){
      for(int j=0; j<rows; j++){
        int x = i*cellSize;  // x location
        int y = j*cellSize;  // y location
        int loc = x +y*img.width;  // location in array
        float h = hue(img.pixels[loc]);         // hue in location
        float s = saturation(img.pixels[loc]);  // saturation in location
        float b = brightness(img.pixels[loc]);  // brightness in location
        color c = color(h,s,b,90);              // color for the crystal
        
        pushMatrix();
        translate(x+cellSize/2, y+cellSize/2);  // center polygon
        fill(c);  // polygon color
        // if sides==0, it's an ellipse, otherwise it's a polygon
        if(sides == 0){
          ellipse(0, 0, cellSize*1.2, cellSize*1.2);
        } else {
          rotate(noise(x+xoff, y+yoff) *TWO_PI);  // rotates with noise
          this.polygon(cellSize*1.2, sides);
        }
        popMatrix();
      }
    }
    return crystals;
  }
  
  /* Draws a regular polygon */
  void polygon(float radius, int sides){
    float angle = TWO_PI/sides;    // internal angle
    beginShape();
    for(float a=0; a<TWO_PI; a+=angle){ 
      float posX = cos(a)*radius;  // x position
      float posY = sin(a)*radius;  // y position
      vertex(posX, posY);
    }
    endShape(CLOSE);
  }
  
  /* Applies threshold effect to image, with 3 different options */
  PImage Threshold(PImage img, int brightLimit, int mode){
    colorMode(HSB, 360, 100, 100);
    PImage thres = new PImage(img.width, img.height);  // destination img
    img.loadPixels();
    thres.loadPixels();
    for(int x=0; x<img.width; x++){
      for(int y=0; y<img.height; y++){
        int loc = x+y*img.width;
        float h = hue(img.pixels[loc]);         // hue
        float s = saturation(img.pixels[loc]);  // normal saturation (mode 0)
        if(mode == 1) s = 1;                    // no saturation (mode 1)
        else if(mode == 2) s = 99;              // full saturation
        float b = brightness(img.pixels[loc]);  // we filter according to brightness
        if(b < brightLimit){
          thres.pixels[loc] = color(h, s, 0);
        } else { 
          thres.pixels[loc] = color(h, s, 100);
        }
      }
    }
    return thres;
  }
  
  /* Applies inverted threshold effect to image, with 3 different options */
  PImage InvThreshold(PImage img, int brightLimit, int mode){
    colorMode(HSB, 360, 100, 100);
    PImage thres = new PImage(img.width, img.height);  // destination img
    img.loadPixels();
    thres.loadPixels();
    for(int x=0; x<img.width; x++){
      for(int y=0; y<img.height; y++){
        int loc = x+y*img.width;
        float h = hue(img.pixels[loc]);         // hue
        float s = saturation(img.pixels[loc]);  // normal saturation (mode 0)
        if(mode == 1) s = 1;                    // no saturation (mode 1)
        else if(mode == 2) s = 99;              // full saturation
        float b = brightness(img.pixels[loc]);  // we filter according to brightness
        if(b > brightLimit){
          thres.pixels[loc] = color(h, s, 0);
        } else { 
          thres.pixels[loc] = color(h, s, 100);
        }
      }
    }
    return thres;
  }
  
  /* Applies sharpen effect to the image */
  PImage Sharpen(PImage img){
    PImage sharp = new PImage(img.width, img.height);
    img.loadPixels();
    sharp.loadPixels();
    for(int x=0; x<img.width; x++){
      for(int y=0; y<img.height; y++){
        int loc = x +y*img.width;
        color c = convolution(x, y, shMatrix, 3, img);
        sharp.pixels[loc] = c;
      }
    }
    colorMode(HSB);
    return sharp;
  }
  
  color convolution(int x, int y, float[][] matrix, int mSize, PImage img){
    colorMode(RGB);
    float r = 0.0;
    float g = 0.0;
    float b = 0.0;
    int offset = mSize/2;
    for(int i=0; i<mSize; i++){
      for(int j=0; j<mSize; j++){
        int xloc = x+i-offset;
        int yloc = y+j-offset;
        int loc = xloc +yloc*img.width;
        loc = constrain(loc, 0, img.pixels.length -1);
        
        r += (red(img.pixels[loc]) *matrix[i][j]);
        g += (green(img.pixels[loc]) *matrix[i][j]);
        b += (blue(img.pixels[loc]) *matrix[i][j]);
      }
    }
    r = constrain(r,0,255);
    g = constrain(g,0,255);
    b = constrain(b,0,255);
    return color(r,g,b);
  }
  
  /* Applies grayscale filter */
  PImage Grayscale(PImage img){
    img.filter(GRAY);
    return img;
  }
  PImage Tint(PImage img, int hue){
    colorMode(HSB, 360, 100, 100);
    return img;
  }
  
}