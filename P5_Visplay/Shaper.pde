class Shaper {
	PGraphics canvas;
	int wid, hei;
	int modeMain;
	boolean modeExtra;
	int seed;
	float[] rotObj = {0, 0, 0};
	float[] rotCam = {0, 0, 0};
  float rotVel = 1;
	color mainCol, backCol;
	int[][] floaties;

	Shaper(int w, int h) {
		wid = w;
		hei = h;
		canvas = createGraphics(wid, hei, P3D);
		modeMain = 0;
		modeExtra = false;
		seed = (int) random(10000);

		colorMode(HSB, 360, 100, 100);
		mainCol = color(220, 50, 100);
		backCol = color(300, 40, 100);

		floaties = new int[15][3];
		for(int i = 0; i < floaties.length; i++){
			floaties[i][0] = 0;
			floaties[i][1] = 0;
			floaties[i][2] = 0;
		}
	}

	PGraphics display(){
		canvas.beginDraw();
    canvas.clear();
    canvas.noStroke();
		canvas.pushMatrix();

		canvas.translate(wid/2, hei/2);
		canvas.rotateX(radians(rotCam[0]));
		canvas.rotateY(radians(rotCam[1]));
		canvas.rotateZ(radians(rotCam[2]));
		canvas.lights();

		switch(modeMain){
			case 0:
				singleBox();
				break;
			case 1:
				multiBox();
				break;
		}
		if(modeExtra){
			exBox();
		}

		canvas.popMatrix();
		canvas.endDraw();

		for(int i=0; i<rot.length; i++){
			rotCam[i] += rotVel;
      rotObj[i] += rotVel;
    }

		return canvas;
	}

	void singleBox(){
		canvas.rotateX(radians(rotObj[0]));
		canvas.rotateY(radians(rotObj[1]));
		canvas.rotateZ(radians(rotObj[2]));

		canvas.fill(mainCol);
		canvas.box(100, 100, 100);
	}

	void multiBox(){
		canvas.fill(mainCol);
		for(int i = 0; i < 5; i++){
			canvas.pushMatrix();
			canvas.rotateZ(i* TWO_PI/5);
			canvas.translate(500, 0, 0);

			canvas.rotateX(radians(rotObj[0]));
			canvas.rotateY(radians(rotObj[1]));
			canvas.rotateZ(radians(rotObj[2]));
			canvas.box(100, 100, 100);
			canvas.popMatrix();
		}
	}

	void exBox(){
		canvas.fill(mainCol);
		for(int i = 0; i < floaties.length; i++){
			canvas.pushMatrix();
			canvas.rotateZ(i* TWO_PI/5);
			canvas.translate(500, 0, 0);

			canvas.rotateX(radians(rotObj[0]));
			canvas.rotateY(radians(rotObj[1]));
			canvas.rotateZ(radians(rotObj[2]));
			canvas.box(100, 100, 100);
			canvas.popMatrix();
		}
	}

	void changeMode(int m){
		modeMain = m;
	}
	void changeExtra(){
		modeExtra = !modeExtra;
	}

}