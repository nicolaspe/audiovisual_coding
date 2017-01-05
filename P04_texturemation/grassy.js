function grassy(px, l, c){
  this.coord = createVector(px, random(-20,20));
  this.len = l;
  this.wid = l/random(12,15);
  this.top = this.coord.y;
  this.col = c;

  this.animate = function(force){
    var move = force*this.len/80;
    this.top += move;
    this.top = constrain(this.top, this.coord.y-10, this.coord.y+10);
  }

  this.display = function(){
    stroke(this.col);
    strokeWeight(2);
    fill(this.col);

    push();
    translate(this.coord.x, windowHeight);
    beginShape();
    vertex(0,0);
    bezierVertex(0,0, 0,-this.len/2, -this.top,-l);
    bezierVertex(-this.top,-l, 0,-this.len/2, this.wid,0);
    endShape(CLOSE);
    pop();
  }
}
