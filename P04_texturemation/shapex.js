function shapex(px, py){
  colorMode(HSB, 360, 100, 100, 100);
  noiseSeed(random(10000));

  this.c1 = color(249,22,99);
  this.c2 = color(249,12,99);
  this.c3 = color(249,42,99);

  this.pos = createVector(px, py);
  this.points = [];
  var angle = 0;
  // var v = createVector(0,0);
  // this.points.push(v);

  for(var i=0; i<6; i++){
    angle = i*2*PI/6;
    var len = random(15,25);
    var v = p5.Vector.fromAngle(angle);
    v.setMag(len);
    this.points.push(v);
    // print(v.x + " | " + v.y);
  }

  this.update = function(){
    for(var i=0; i<this.points.length; i++){
      // caca
    }
  }

  this.display = function(){
    stroke(this.c3);
    strokeWeight(0.5);

    push();
    translate(mouseX, mouseY);

    fill(this.c2);
    beginShape();
    vertex(0,0);
    vertex(this.points[2].x, this.points[2].y);
    vertex(this.points[3].x, this.points[3].y);
    endShape(CLOSE);

    fill(this.c1);
    beginShape();
    vertex(0,0);
    vertex(this.points[3].x, this.points[3].y);
    vertex(this.points[4].x, this.points[4].y);
    vertex(this.points[5].x, this.points[5].y);
    endShape(CLOSE);

    fill(this.c2);
    beginShape();
    vertex(0,0);
    vertex(this.points[5].x, this.points[5].y);
    vertex(this.points[0].x, this.points[0].y);
    endShape(CLOSE);

    fill(this.c1);
    beginShape();
    vertex(0,0);
    vertex(this.points[0].x, this.points[0].y);
    vertex(this.points[1].x, this.points[1].y);
    vertex(this.points[2].x, this.points[2].y);
    endShape(CLOSE);

    // fill(this.c2);
    // beginShape();
    // vertex(0,0);
    // vertex(this.points[4].x, this.points[4].y);
    // vertex(this.points[0].x, this.points[0].y);
    // vertex(this.points[1].x, this.points[1].y);
    // endShape(CLOSE);

    pop();
  }

}
