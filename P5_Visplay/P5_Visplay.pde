
import processing.video.*;
import codeanticode.syphon.*;

// canvas for video mapping
int nServers = 3;
PGraphics[] canvas;
SyphonServer[] server;
Shaper shap;

// canvas resolution
int w = 1280;
int h = 800;

// video variables
String[] videoList = {"ThisIsHalloween.mp4", 
  "Britney1.mp4", 
  "BackstreetBoys.mp4", 
  "Chromacurrents.mp4",
  "Britney2.mp4", 
  "Cats.mp4", 
  "BarbieGirl.mp4", 
  "PsychillPsychedelic3D.mp4", };
Movie[] vids;
int baseVid, overVid;

// shapes variables
float[] rot = {0., 0., 0.};
float[] pos;


void setup() {
  // internal control screen
  size(400, 400, P3D);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  smooth();

  // create projected canvases
  canvas = new PGraphics[nServers];
  for (int i=0; i<nServers; i++) {
    canvas[i] = createGraphics(w, h, P3D);
  }

  // create Syphon servers
  server = new SyphonServer[nServers];
  for (int i=0; i<nServers; i++) {
    server[i] = new SyphonServer(this, "ProceSyphon_" +i);
  }

  // load videos
  vids = new Movie[videoList.length];
  for (int i=0; i<videoList.length; i++) {
    vids[i] = new Movie(this, videoList[i]);
  }
  baseVid = 0;
  overVid = 1;

  // play first videos
  vids[baseVid].loop();
  vids[overVid].loop();
  
  // shapes
  shap = new Shaper(w, h);
}

void draw() {
  background(0);

  // reset all canvas (draw only backgrounds)
  for (int i=0; i<nServers; i++) {
    canvas[i].beginDraw();
    canvas[i].clear();
    canvas[i].endDraw();
  }

  // display base video
  displayVid(0, 0, 255);

  // display over video
  displayVid(1, 1, 128);

  // display graphics
  displayShapes(2);

  // display on internal screen
  image(canvas[0], 0, 0, width/2, height/2);
  image(canvas[1], width/2, 0, width/2, height/2);
  image(canvas[2], 0, height/2, width/2, height/2);
  //image(canvas[3], width/2, height/2, width/2, height/2);

  // send images via Syphon
  for (int i=0; i<nServers; i++) {
    server[i].sendImage(canvas[i]); // sends through syphon
  }
}

// drawings
void displayShapes(int canvas_i){
  canvas[canvas_i] = shap.display();
}


/*
 * == MOVIES ==
 */

// run every time there's a new available frame
void movieEvent(Movie m) {
  m.read();
}

// displays a video to the target canvas
void displayVid(int vid_i, int canvas_i, int alphaTint) {
  // create temp target image and variables
  PImage img = vids[vid_i];
  int wid = canvas[canvas_i].width;
  int hei = canvas[canvas_i].height;

  // display
  canvas[canvas_i].beginDraw();
  canvas[canvas_i].tint(255, alphaTint);
  canvas[canvas_i].image(img, 0, 0, wid, hei);
  canvas[canvas_i].endDraw();
}


/*
 * == CONTROLS ==
 */

// function that changes the active movie
void loadVideo(int play_index, int stop_index) {
  // stop the specified video
  vids[stop_index].stop();

  // loop the one selected
  vids[play_index].loop();
  vids[play_index].jump(random(vids[play_index].duration()-10));
}

// replaces one of the active videos with a new random one
void randomVideo(int ind) {
  int rand = (int) random(videoList.length);
  if (ind == 0){
    loadVideo(rand, baseVid);
    baseVid = rand;
    println("");
  } else if (ind == 1){
    loadVideo(rand, overVid);
    overVid = rand;
  }
}
void randomLocation(int ind) {
  if (ind == 0){
    vids[baseVid].jump(random(vids[baseVid].duration()-10));
  } else if (ind == 1){
    vids[overVid].jump(random(vids[overVid].duration()-10));
  }
}

void keyPressed(){
  if(key == '0'){ shap.changeMode(0);} 
  else if(key == '1'){ shap.changeMode(1);}
  else if(key == 'q'){ randomVideo(0); }
  else if(key == 'a'){ randomVideo(1); }
  else if(key == 'w'){ randomLocation(0); }
  else if(key == 's'){ randomLocation(1); }
}