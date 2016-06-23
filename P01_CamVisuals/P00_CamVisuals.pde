import processing.video.*;
import oscP5.*;
import netP5.*;

VisualP master;   // Visual processor master class to save all visual functions
Capture video;    // variable that captures the current video frame

int mode = 0;         // mode selector
float posX, posY;     // position for mirror block
int mirrorSide = 0;   // variable for mirror effects
boolean eff_Threshold, eff_iThreshold, eff_Tint,  // booleans for effects 
        eff_Grayscale, eff_Sharpen, eff_Crystal; 
int thresLimit = 50;  // brightness limit for threshold function
int thresMode = 1;    // variable for threshold mode
int hue = 0;          // hue used for tint
int cellSize = 12;    // Crystal cell size
int polygonSides = 5; // number of sides of Crystal polygons

OscP5 oscP5_r;      // OSC receiver
int port_r = 10115; // OSC communication receiving port
String ip = "127.0.0.1";  // local address

void setup(){
  // Canvas initialization
  size(640,480);
  background(0);
  // Settings
  noStroke();
  colorMode(HSB, 360, 100, 100);
  smooth();
  // Visual controller effects' variables
  master = new VisualP();
  posX = width/2;
  posY = height/2;
  eff_Threshold = false;
  eff_iThreshold = false;
  eff_Tint = false;
  eff_Grayscale = false;
  eff_Sharpen = false;
  eff_Crystal = false;
  // OSC Receiver
  oscP5_r = new OscP5(this, port_r);
  // Webcam capture initialization
  video = new Capture(this, 640, 480);
  video.start();
}

void draw(){
  // We have to check if there's an available frame
  if(video.available() == true){
    video.read();
    // casting the video image to a PImage type (instead of Capture) 
    PImage img = video;
    // Image to be displayed
    PImage disp = new PImage(width, height, HSB);
    
    // Mode selection
    switch(mode){
      case 0:  // NORMAL
        disp = img;
        break;
      case 1:  // VERTICAL MIRROR
        disp = master.MirrorY(img, posY, mirrorSide);
        break;
      case 2:  // HORIZONTAL MIRROR
        disp = master.MirrorX(img, posX, mirrorSide);
        break;
      case 3:  // 3 BARS
        disp = master.ThreeBars(img, posX);
        break;
      case 4:  // MOTION SENSOR
        disp = master.MotionSensor(img);
        break;
      case 6:  // 
        break;
    }
    
    // Effects
    if (eff_Threshold) disp = master.Threshold(disp, thresLimit, thresMode);
    else if (eff_iThreshold) disp = master.InvThreshold(disp, thresLimit, thresMode);
    if (eff_Sharpen)   disp = master.Sharpen(disp);
    if (eff_Grayscale) disp = master.Grayscale(disp);
    if (eff_Tint)      disp = master.Tint(disp, hue);
    
    // Display image
    if (eff_Crystal){  master.Crystal(disp, polygonSides, cellSize);}
    else{ image(disp, 0, 0);}
  }
}

// KEYBOARD CONTROL
void keyPressed(){
  if(key == '0'){ mode = 0;}      // NORMAL
  else if(key == '1'){ mode = 1;} // VERTICAL MIRROR
  else if(key == '2'){ mode = 2;} // HORIZONTAL MIRROR
  else if(key == '3'){ mode = 3;} // CENTRAL HORIZONTAL MIRROR
  else if(key == '4'){ mode = 4;} // 3 BARS
  else if(key == '5'){ mode = 5;} // MOTION SENSOR
  else if(key == 'h' || key == 'H'){ 
    eff_Threshold = !eff_Threshold;
    eff_iThreshold= false;
  }
  else if(key == 'i' || key == 'I'){ 
    eff_iThreshold= !eff_iThreshold;
    eff_Threshold = false;
  }
  else if(key == 's' || key == 'S'){ eff_Sharpen   = !eff_Sharpen;}
  else if(key == 'g' || key == 'G'){ eff_Grayscale = !eff_Grayscale;}
  else if(key == 't' || key == 'T'){ eff_Tint      = !eff_Tint;}
  else if(key == 'c' || key == 'C'){ eff_Crystal   = !eff_Crystal;}
  else if(key == 'm' || key == 'M'){
    if(mirrorSide == 0){ mirrorSide = 1;}
    else{ mirrorSide = 0;}
  }
  else if(key == '+'){
    thresLimit++;
    thresLimit = constrain(thresLimit,10,90);
  }
  else if(key == '-'){
    thresLimit--;
    thresLimit = constrain(thresLimit,10,90);
  }
  else if(keyCode == RIGHT){
    thresMode++;
    if(thresMode == 3) thresMode = 0;
  }
  else if(keyCode == LEFT){
    thresMode--;
    if(thresMode == -1) thresMode = 2;
  }
  //println("Mode: " +mode);
}

// PURE DATA OSC CONTROL
void oscEvent(OscMessage oscMsg){
  
  // Check incomming osc label to filter message
  if(oscMsg.checkAddrPattern("/mode") == true){      // mode change
    if(oscMsg.checkTypetag("i")){  // check message variable type
      mode = (int) oscMsg.get(0).intValue();      // extracts value
      println("Mode = " +mode);
    }
  }
  // MODE OPTIONS
  if(oscMsg.checkAddrPattern("/modeOpt") == true){  // mode option
    if(oscMsg.checkTypetag("iff")){  // check message variable type
      mirrorSide = (int) oscMsg.get(0).intValue();// extracts value
      posX = oscMsg.get(1).floatValue()*width;
      posY = oscMsg.get(2).floatValue()*height;
    }
  }
  // THRESHOLD
  if(oscMsg.checkAddrPattern("/eff/thres") == true){
    if(oscMsg.checkTypetag("iii") || oscMsg.checkTypetag("ifi")){
      int thr_mode = oscMsg.get(0).intValue();
      thresLimit = oscMsg.get(1).intValue();
      thresMode  = oscMsg.get(2).intValue();
      if(thr_mode == 1){
        eff_Threshold = true;
        eff_iThreshold= false;
      } else if(thr_mode == 2){
        eff_Threshold = false;
        eff_iThreshold= true;
      } else{
        eff_Threshold = false;
        eff_iThreshold= false;
      }
    }
  }
  // SHARPEN
  if(oscMsg.checkAddrPattern("/eff/sharp") == true){
    if(oscMsg.checkTypetag("i")){
      if(oscMsg.get(0).intValue() == 1){ eff_Sharpen = true;}
      else{ eff_Sharpen = false;}
    }
  }
  // GRAYSCALE
  if(oscMsg.checkAddrPattern("/eff/gray") == true){
    if(oscMsg.checkTypetag("i")){
      if(oscMsg.get(0).intValue() == 1){ eff_Grayscale = true;}
      else{ eff_Grayscale = false;}
    }
  }
  // TINT
  if(oscMsg.checkAddrPattern("/eff/tint") == true){
    if(oscMsg.checkTypetag("ii")){
      if(oscMsg.get(0).intValue() == 1){ eff_Tint = true;}
      else{ eff_Tint = false;}
      hue = oscMsg.get(1).intValue();
    }
  }
  // CRYSTAL DISTORTION
  if(oscMsg.checkAddrPattern("/eff/crystal") == true){
    if(oscMsg.checkTypetag("iii")){
      if(oscMsg.get(0).intValue() == 1){ eff_Crystal = true;}
      else{ eff_Crystal = false;}
      polygonSides = oscMsg.get(1).intValue();
      cellSize = oscMsg.get(2).intValue();
    }
  }
  
}