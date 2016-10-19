var playing = false;
var vid;
var img;
var audioStep;
var curStep;    // current step sound index 
var curBack;    // current background sound index 
var stepTime;   // variable that stores the time when a step sound must be played
var button;
var textStep;
var textBack;
var curFrame;

function preload(){
  vid = createVideo('walkNY_noSound.mp4');  // video files
  // Step sounds preload
  audioStep = [];
  // audioStep[0] = ""; // null, no step sound, just as in original;
  audioStep[1] = loadSound('sounds/Beer_Can.mp3');
  // audioStep.playMode("sustain");
  // Background sounds preload
  audioBack = [];
  audioBack[0] = loadSound('sounds/walkNY_sound.wav');
  // Current index initialization
  curStep = 0;
  curBack = 0;
  // Text descriptions
  textStep = [];
  textStep[0] = "No step sound (Original)";
  textStep[1] = "Beer Can";
  textBack = [];
  textBack[0] = "Original";
}

function setup() {
  createCanvas(600,340);
  vid.hide();
  curFrame = 0;
  frameRate(48);
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
    text("Step: "       +curStep +" - " +textStep[curStep], 390,40);
    text("Background: " +curBack +" - " +textBack[curBack], 350,60);
  }
  text("Frame: " + curFrame, 20,320);
  if(playing){ curFrame++;}
}

function keyPressed(){
  // console.log()
  if(key == 0){   // PLAY - PAUSE
    toggleVid();
    toggleStep();
    toggleBack();
  } else if(key == 1){  // CYCLE STEP
    if(curStep!=0){ audioStep[curStep].stop();}
    curStep++;
    if(curStep>=audioStep.length){ curStep=0;}
    if(playing){ toggleStep();}
  } else if(key == 2){  // CYCLE BACKGROUND
    curBack++;
    if(curBack>=audioBack.length){ curBack=0;}
  }
}
function toggleStep(){
  if(curStep == 0){}
  else if(audioStep[curStep].isPlaying()){
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
