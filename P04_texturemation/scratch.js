function scratch(px, py, size, angle, col, e){
  this.pos = createVector(px, py);
  this.vel = p5.Vector.fromAngle(angle);
  this.acc = createVector(0, 0);
  this.maxspeed = 5;
  
  this.l = size;  // scratch length
  this.c = col;   // color
  this.theta = radians(angle);
  
  this.entropy = e;
  
  this.animate = function(dir){
    this.applyForce(dir);
    this.update();
  }
  
  this.applyForce = function(force){
    this.acc.add(force);
  }
  this.update = function(){
    this.vel.add(this.acc);
    this.vel.limit(this.maxspeed);
    this.pos.add(this.vel);
    this.borders();
    this.acc.set(0);
  }
  this.borders = function(){
    if (this.pos.x < -this.l){
      this.pos.x = width + this.l;
      if(random(1) < this.entropy) this.pos.y = random(height);
    } 
    if (this.pos.y < -this.l){ 
      this.pos.y = height + this.l;
      if(random(1) < this.entropy) this.pos.x = random(width);
    }
    if (this.pos.x > width + this.l){
      this.pos.x = -this.l;
      if(random(1) < this.entropy) this.pos.y = random(height);
    }
    if (this.pos.y > height + this.l){ 
      this.pos.y = -this.l;
      if(random(1) < this.entropy) this.pos.x = random(width);
    }
  }
  this.display = function(){
    stroke(this.c);
    push();
    translate(this.pos.x, this.pos.y);
    rotate(this.theta);
    line(0,0, this.l,0);
    pop();
  }
}