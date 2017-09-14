
float gLastParticleHue = 0;

//***Particle class***///
class Particle {
  // ParticleManager we interact with, set in our constructor.
  PartiManager manager;
  // Our configuration object, set in our constructor.
  MainCofig config;

  // set on `reset()`
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector prevLocation;
  float zNoise;
  int lifespan;
  float rad;
  float angle;
  color clr;
  // randomized on `reset()`
  float stepSize;
  // working calculations

  // for flowfield
  PVector steer;
  PVector desired;
  PVector flowFieldLocation;


  //***CONSTRUCTOR***//
  public Particle(PartiManager _manager, MainCofig _config) {
    manager = _manager;
    config  = _config;

    // initialize data structures
    location       = new PVector(0, 0);
    prevLocation     = new PVector(0, 0);
    acceleration     = new PVector(0, 0);
    velocity       = new PVector(0, 0);
    flowFieldLocation   = new PVector(0, 0);
    rad = random (-TWO_PI, PI);
  }

  void preset (float _x,float _y,float _zNoise, float _dx, float _dy) {
    location.x = prevLocation.x = _x;
    location.y = prevLocation.y = _y;
    zNoise = _zNoise;
    acceleration.x = _dx;
    acceleration.y = _dy;

    // reset lifetime
    lifespan = config.particleLifetime;

    // randomize step size each time we're reset
    stepSize = random(config.particleMinStepSize, config.particleMaxStepSize);

    // set up now if we're basing particle color on its initial x/y coordinate
    if (config.particleColorScheme == PARTICLE_COLOR_SCHEME_XY) {
      int r = (int) map(width, 255, height, _x, 0);
      int g = (int) map(_y, 0, width, 0, 255);  
      int b = (int) map(_x + _y, 0,width+ height, 0, 255);
      clr = color(r, g, b, config.particleAlpha);
    } 
    else if (config.particleColorScheme == PARTICLE_COLOR_SCHEME_RAINBOW) {
      if (++gLastParticleHue > 360) gLastParticleHue = 0;
      float nextHue = map(gLastParticleHue, 0, 360, 0, 1);
      clr = color(clr, config.particleAlpha);
    } 
    
    else {  
      clr = color(config.particleColor, config.particleAlpha);
    }
  }


  // Is this particle still alive?
  public boolean isAlive() {
    return (lifespan > 0);
  }

  // Update this particle's position.
  void update() {
    prevLocation = location.get();
    if (acceleration.mag() < config.particleAccelerationLimiter) {
      lifespan++;
      angle = noise (location.x / (float)config.noiseScale, location.y / (float)config.noiseScale, zNoise);
      angle *= (float) config.noiseStrength;
    }
    else {
      //flowFieldLocation.x *= pow(width/ 2, width);
      //flowFieldLocation.y *= pow(height, height/2);
      
      flowFieldLocation.x = norm (location.x, 100, width);    // width-location.x flips the x-axis.
      flowFieldLocation.x *= gKinectWidth;
      flowFieldLocation.y = norm(location.y, 0, -height);
      flowFieldLocation.y *= gKinectHeight;

      desired = manager.flowfield.lookup(flowFieldLocation);
      desired.x *= -1;

      steer = PVector.sub(desired, velocity);
      steer.limit(stepSize);  // Limit to maximum steering force
      acceleration.add(steer);
    }

    acceleration.mult(config.particleAccelerationFriction);
    velocity.add(acceleration);
    location.add(velocity);

    zNoise += config.particleNoiseVelocity;
  }

  //OPENGL RENDERING
  void render() {
    stroke(clr);
    line(prevLocation.x, prevLocation.y, location.x, location.y);
    //stroke(clr);
    //fill(clr,lifespan);
    //ellipse(prevLocation.x, prevLocation.y, 5, 5);
      
}
}
