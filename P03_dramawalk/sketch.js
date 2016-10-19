var playing = false;
var vid;
var img;
var audioStep;
var curStep;    // current step sound index 
var curBack;    // current background sound index 
var stepTime;   // variable that stores the time when a step sound must be played
var button;

function preload(){
  vid = createVideo('walkNY_noSound.mp4');  // video files
  audioStep = [];
  audioStep[0] = loadSound('sounds/walkNY_sound.wav');
  // audiostep[1] = loadSound('sounds/');
  audioBack = [];
  audioBack[0] = loadSound('sounds/walkNY_sound.wav');
  curStep = 0;
  curBack = 0;
}

function setup() {
  createCanvas(600,340);
  vid.hide();
  // button = createButton('Play');
  // button.mousePressed(toggleVid); // button listener
  
}

function toggleVid() {
  if(playing){
    vid.pause();
    // button.html('Play');
  } else {
    vid.loop();
    // button.html('Pause');
  }
  playing = !playing;
}

function draw() {
  background(42);
  img = vid;
  var imgScalar = width/img.width;
  image(img, 0, 0, imgScalar*img.width, imgScalar*img.height);
  if(mouseY < 100){
    noStroke();
    fill(255,255,255,70);
    rect(0,0,width,100);
    fill(0);
    text("Press:",10,20);
    text("0 - to play/pause",60,20);
    text("1 - to cycle step sounds",60,40);
    text("2 - to cycle background sound",60,60);
    text("Current sounds",400,20);
    text("Step - " +curStep,390,40);
    text("Background - " +curBack,350,60);
  }
}

function keyPressed(){
  // console.log()
  if(key == 0){   // PLAY - PAUSE
    toggleVid();
    toggleStep();
    toggleBack();
  } else if(key == 1){  // CYCLE STEP
    
  } else if(key == 2){  // CYCLE BACKGROUND
    
  }
}

function toggleStep(){
  if(audioStep[curStep].isPlaying()){
    audioStep[curStep].pause();
  } else {
    audioStep[curStep].loop();
  }
}
function toggleBack(){
  if(audioBack[curBack].isPlaying()){
    audioBack[curBack].pause();
  } else {
    audioBack[curBack].loop();
  }
}
