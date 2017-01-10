var r = 100;
var nSC = 100;
var nGr = 100;
var angle = 180-45;
var scratches = [];
var grass = [];
var pointer;
var col_bg;
var col_sc;
var col_ci;
var col_gr;
var entropy = 0.5;
var xoff = 0;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  noiseSeed(random(10000));

  colorMode(HSB, 360, 100, 100, 100);
  col_bg = color(52,22,99);
  col_sc = color(52,31,58);
  col_ci = color(249,22,99);
  col_gr = 120;
  background(col_bg);

  createScratches();
  createGrass();
  pointer = new shapex(0,0);
}

function draw() {
  background(col_bg);

  var dir = p5.Vector.fromAngle(radians(angle));
  for(var i = 0; i < nSC; i++){
    scratches[i].animate(dir);
    scratches[i].display();
  }
  // pointer.display();
  // middleCircle();
  for(var i = 0; i < nGr; i++){
    var wind = map(noise(xoff), 0,1, -1,1);
    grass[i].animate(wind);
    grass[i].display();
    xoff += 0.01;
  }
}

function createScratches(){
  scratches = [];
  for(var i = 0; i < nSC; i++){
    var l = 20*random(0.75, 1.25);
    var x = random(width);
    var y = random(height);
    var s = new scratch(x, y, l, angle, col_sc, entropy);
    scratches.push(s);
  }
}
function createGrass() {
  grass = [];
  for (var i = 0; i < nGr; i++) {
    var x = random(0,1);
    var l = random(40,70);
    var c = color(col_gr, random(6,20), random(80,99));
    var g = new grassy(x, l, c);
    grass.push(g);
  }
}
function mousePressed() {
  pointer = new shapex(mouseX, mouseY);
  createScratches();
  createGrass();
}
function middleCircle() {
  noStroke();
  fill(col_ci);
  ellipse(width/2, height/2, 200, 200);
}

window.onresize = function(){
  resizeCanvas(windowWidth, windowHeight);
}
