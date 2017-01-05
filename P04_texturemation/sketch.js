var r;
var num;
var angle;
var scratches = [];
var pointer;
var col_bg;
var col_sc;
var col_ci;
var entropy = 0.5;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  
  r = 100;
  num = 100;
  angle = 180-45;
  scratches = [];
  pointer = new shapex(0,0);
  
  colorMode(HSB, 360, 100, 100, 100);
  col_bg = color(52,22,99);
  col_sc = color(52,31,58);
  col_ci = color(249,22,99);
  background(col_bg);
  
  createScratches();
}

function draw() {
  background(col_bg);
  
  var dir = p5.Vector.fromAngle(radians(angle));
  for(var i=0; i<num; i++){
    scratches[i].animate(dir);
    scratches[i].display();
  }
  pointer.display();
  
  noStroke();
  fill(col_ci);
  ellipse(width/2, height/2, 200, 200);
}

function createScratches(){
  scratches = [];
  for(var i=0; i<num; i++){
    var l = 20*random(0.75, 1.25);
    var x = random(width);
    var y = random(height);
    var s = new scratch(x, y, l, angle, col_sc, entropy);
    scratches.push(s);
  }
}

function mousePressed() {
  pointer = new shapex(mouseX, mouseY);
  createScratches();
}

window.onresize = function(){
  resizeCanvas(windowWidth, windowHeight);
}
