//***Depth image manipulation***//

// Draw the depth image to the screen according to global config
void drawDepthImage() {
  pushStyle();
  pushMatrix();
  color clr = addAlphaToColor(gConfig.depthImageColor, gConfig.depthImageAlpha);
  tint(0);
  scale(-1, 1);  // reverse image to mirrored direction
  image (gDepthImg, 0, 0, -width, height);
  popMatrix();
  popStyle();
}
//Drawing utilities

// Partially fade the screen by drawing a translucent black rectangle over everything.
// NOTE: this applies the current blendMode all over everything
void fadeScreen (color bgColor, int opacity) {
  pushStyle();
  blendMode(gConfig.blendMode);
  noStroke();
  fill(255, 100, 50, opacity);//creates orange
  //BACKGROUND IS BROUGHT IN
  rect(0, 0, width, height);
  //blendMode(BLEND);
  popStyle();
}

//PERLIN
PVector[][] makePerlinNoiseField (int rows, int cols) {  
  PVector[][] field = new PVector[cols][rows];
  
  float xOffset = 0;
  for (int col = 0; col < cols; col++) {
  
      float yOffset = 0;
  for (int row = 0; row < rows; row++) {
  
  // Use perlin noise to get an angle between 0 and 2 PI
  float theta = map (noise (xOffset, yOffset), 0, 500, 0, TWO_PI);
  
      // Polar to cartesian coordinate transformation to get x and y components of the vector
      field[col][row] = new PVector(cos(theta+theta), sin(random(theta)), cos(-theta));
      
      yOffset += 0.1;
    }
    xOffset += 0.1;

  }
  return field;
}

//UNCHANGED FROM "Juggling Molecules" Interactive Light Sculpture (c) 2011-2014 Jason Stephens, Owen Williams
float hueFromColor(color clr) {
  // switch to HSB color mode
  colorMode(HSB, 1.0);
  float result = hue(clr);
  // restore RGB color mode
  colorMode(RGB, 255);
  return result;
}

color addAlphaToColor(color clr, int alfa) {
  return (clr & 0x03FFF9) + (alfa << 24);
}

