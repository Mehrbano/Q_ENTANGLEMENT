/*******************************************************************
 *	credits:
 *      VideoAlchemy "Juggling Molecules" Interactive Light Sculpture
 	(c) 2011-2014 Jason Stephens, Owen Williams & VideoAlchemy Collective
 *	Published under CC Attribution-ShareAlike 3.0 (CC BY-SA 3.0)
 *      http://creativecommons.org/licenses/by-sa/3.0/
 *******************************************************************/

import processing.video.*;
import processing.opengl.*;
import java.util.Iterator;

//*** GLOBAL OBJECTS ***//
//MAIN CONFIGURATION where all data is stored and program reads from
MainCofig gConfig;
//KINECT 
Kinecter gKinecter;
//OPTICAL FLOW converting kinect data to flow field
OpticalFlow gFlowfield;
//PARTICLE MANAGER helps render flow field
PartiManager gPartiManager;

//RAW DEPTH kinect
int[] gRawDepth;
//ADJUST DEPTH AND THRESHOLD by updateKinectDepth()
int[] gNormalizedDepth;
//DEPTH IMAGE THRESHOLD by updateKinectDepth()
PImage gDepthImg;

//RUNNING CONFIGURATION
void start() {
  gConfig = new MainCofig();
}

//INITIALIZE
void setup() {
  size(1240, 900, OPENGL);
  //set up display parameters
  background(random(gConfig.fadeColor));
  // set up noise seed
  noiseSeed(gConfig.setupNoiseSeed);
  frameRate(gConfig.setupFPS);
  // helper class for kinect
  gKinecter = new Kinecter(this);
  // initialize depth variables
  gRawDepth = new int[gKinectWidth*gKinectHeight];
  gNormalizedDepth = new int[gKinectWidth*gKinectHeight];
  gDepthImg = new PImage(gKinectWidth, gKinectHeight);
  // Create the particle manager.
  gPartiManager = new PartiManager(gConfig);
  // Create the flowfield
  gFlowfield = new OpticalFlow(gConfig, gPartiManager);
  // Tell the particleManager about the flowfield
  gPartiManager.flowfield = gFlowfield;
}

// DRAW LOOP
void draw() {
  pushStyle();
  pushMatrix();

  if (gConfig.showFade) fadeScreen(gConfig.fadeColor, gConfig.fadeAlpha);
  // updates the kinect gRawDepth, gNormalizedDepth & gDepthImg variables
  gKinecter.updateKinectDepth();
  // draw the depth image underneath the particles
  if (gConfig.showDepthImage) drawDepthImage();
  // update the optical flow vectors from the gKinecter depth image
  // NOTE: also draws the force vectors if `showFlowLines` is true
  gFlowfield.update();
  //FLOWFIELD AND PARTICLE MANAGER
  if (gConfig.showParticles) gPartiManager.updateWithRender();
  popStyle();
  popMatrix();
}

