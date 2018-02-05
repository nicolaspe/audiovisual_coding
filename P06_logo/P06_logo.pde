float rx = 0;
float ry = 0;
float rz = 0;
float dim = 200;

void setup(){
  //size(1000, 600, P3D);
  size(3000, 1800, P3D);
  //size(600, 1000, P3D);
  //size(1800, 3000, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  
  smooth(8);
  background(275, 88, 23);
  createGrid();
}

void draw(){

}

void keyPressed() {
  if (key == 'x') {
    rx += 0.1;
  } else if (key == 'y') {
    ry += 0.1;
  } else if (key == 'z') {
    rz += 0.1;
  } else if (key == 'g') {
    createGrid();
  } else if (key == 's') {
    saveImg();
  }
}


void createGrid(){
  background(239, 0, 96, 5);
  
  noFill();
  pushMatrix();
  translate(width/2, height*0.5, 0);
  rotateX(PI/2-0.1);
  for(int i=0; i<2000; i++){
    float a = random(0, 100);
    stroke(275, 88, 23, a);
    strokeWeight(random(0.5, 1));
    
    pushMatrix();
    float pz = random(-500, 500);
    translate(0, -1200, pz);
    
    float px = random(-2200, 2000);
    float py = random(-12000, 2000);
    rect(px, py, px+dim, py+dim);
    
    popMatrix();
  }
  popMatrix();
}

void saveImg(){
  String date = nf(year(), 4) +nf(month(), 2) +nf(day(), 2) +nf(minute(), 2) +nf(second(), 2);
  save("background_"+date+".png");
}