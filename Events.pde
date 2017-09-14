
//Handle keypress to adjust parameters
	void keyPressed() {

	  // up arrow to move kinect down
	  if (keyCode == UP) {
		gConfig.kinectAngle = constrain(++gConfig.kinectAngle, 0, 30);
		gKinecter.kinect.setTilt(gConfig.kinectAngle);
	  }
	  // down arrow to move kinect down
	  else if (keyCode == DOWN) {
		gConfig.kinectAngle = constrain(--gConfig.kinectAngle, 0, 30);
		gKinecter.kinect.setTilt(gConfig.kinectAngle);
	  }

	  // toggle showParticles on/off
	  else if (key == 'q') {
		gConfig.showParticles = !gConfig.showParticles;
		println("showing particles: " + gConfig.showParticles);
	  }
	  // toggle showFlowLines on/off
	  else if (key == 'w') {
		gConfig.showFlowLines = !gConfig.showFlowLines;
		println("showing optical flow: " + gConfig.showFlowLines);
	  }
	  // toggle showDepthImage on/off
	  else if (key == 'e') {
		gConfig.showDepthImage = !gConfig.showDepthImage;
		println("showing depth image: " + gConfig.showDepthImage);
	  }
	  // toggle showFade on/off
	  else if (key == 'r') {
		gConfig.showFade = !gConfig.showFade;
		println("showing depth pixels: " + gConfig.showFade);
	  }

	// different blend modes
	  else if (key == '1') {
		gConfig.blendMode = BLEND;
		println("Blend mode: BLEND");
	  }
	  else if (key == '2') {
		gConfig.blendMode = ADD;
		println("Blend mode: ADD");
	  }
	  else if (key == '3') {
		gConfig.blendMode = SUBTRACT;
		println("Blend mode: SUBTRACT");
	  }
	  else if (key == '4') {
		gConfig.blendMode = DARKEST;
		println("Blend mode: DARKEST");
	  }
	  else if (key == '5') {
		gConfig.blendMode = LIGHTEST;
		println("Blend mode: LIGHTEST");
	  }
	  else if (key == '6') {
		gConfig.blendMode = DIFFERENCE;
		println("Blend mode: DIFFERENCE");
	  }
	  else if (key == '7') {
		gConfig.blendMode = EXCLUSION;
		println("Blend mode: EXCLUSION");
	  }
	  else if (key == '8') {
		gConfig.blendMode = MULTIPLY;
		println("Blend mode: MULTIPLY");
	  }
	  else if (key == '9') {
		gConfig.blendMode = SCREEN;
		println("Blend mode: SCREEN");
	  }
	}
