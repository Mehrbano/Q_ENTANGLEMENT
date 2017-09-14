//***Particle class***///
class PartiManager {
  MainCofig config;

  // flowfield influencing drawing
  OpticalFlow flowfield;

  // managed particles
  Particle particles[];
  
  //index particles
  int particleId = 0;

////////////////////////////////////////////////////////////
//***CONSTRUCTOR***///
  public PartiManager (MainCofig _config) {
  //call config
  config = _config;

    //count particle drawing
    int particleCount = config.MAX_particleMaxCount;
    particles = new Particle[particleCount];
    for (int i=0; i < particleCount; i++) {
      particles[i] = new Particle(this, config);
    }
  }

  void updateWithRender() {
    pushStyle();
    // loop particles and quantity
    int particleCounts = config.particleMaxCount;
    for (int i = 0; i < particleCounts; i++) {
      Particle particle = particles[i];
      if (particle.isAlive()) {
        particle.update();
        particle.render();
      }
    }
    popStyle();
  }

//particle force
void addParticlesForForce(float x, float y, float dx, float dy) {
    regenerateParticles(x * width, 
    y * height, dx , dy * config.particleForceMultiplier);
  }

  // set of particles based on a force vector
  void regenerateParticles(float startX, float startY, float forceX, float forceY) {
    for (int i = 0; i < config.particleGenerateRate; i++) {
      
      float originX = startX + random(-100, 100);
      float originY = startY + random(-config.particleGenerateSpread, config.particleGenerateSpread);
      float noiseZ = particleId/float(config.particleMaxCount);

      particles[particleId].preset(originX, originY, noiseZ, forceX, forceY);

      // increment counter -- go back to 0 if we're past the end
      particleId++;
      if (particleId >= config.particleMaxCount) particleId = 0;
    }
  }

}
