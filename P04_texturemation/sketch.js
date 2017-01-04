var r = 100;
var num = 100;
var angle = 180-45;
var scratches = [];
var col_bg;
var col_sc;
var col_ci;
var entropy = 0.5;

function setup() {
  createCanvas(400,400);
  
  colorMode(HSB, 360, 100, 100, 100);
  col_bg = color(52,22,99);
  col_sc = color(52,31,58);
  col_ci = color(249,22,99);
  background(col_bg);
  
  for(var i=0; i<num; i++){
    var s = new scratch(random(width), random(height), 20, angle, col_sc, entropy);
    scratches.push(s);
  }
}

function draw() {
  background(col_bg);
  
  var dir = p5.Vector.fromAngle(radians(angle));
  for(var i=0; i<num; i++){
    scratches[i].animate(dir);
    scratches[i].display();
  }
  
  noStroke();
  fill(col_ci);
  ellipse(width/2, height/2, 200, 200);
}