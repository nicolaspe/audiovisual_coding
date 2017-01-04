var r;
var scratches;
var col_bg;

function setup() {
  createCanvas(400,400);
  colorMode(HSB);
  col_bg = color(52,22,99);
  background(col_bg);
  r = 100;
  scratches = [];
}

function draw() {
  background(col_bg);
  noStroke();
  fill(162,67,93);
  ellipse(width/2, height/2, 200, 200);
  fill(34,74,59);
  noStroke();
  ellipse(mouseX, mouseY, 50, 50);
}