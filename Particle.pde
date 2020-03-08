class Particle{
  private PVector position;
  private PVector direction;
  private float vilocity;
  
  
  public Particle(){
    this.position = new PVector(random(width), random(height));
    this.direction = new PVector(0, 0);
    this.vilocity = random(60);
  }
  
  
  public void updateAndShow(){
    float n = noise(this.position.x/width + (float)frameCount/60,
                    this.position.y/height + (float)frameCount/60);
    
    this.direction.x = cos(2 * PI * n);
    this.direction.y = sin(2 * PI * n);
    
    this.position.x += this.direction.x * this.vilocity;
    this.position.y += this.direction.y * this.vilocity;
    
    if (this.position.x < 0) this.position.x = width;
    if (this.position.x > width) this.position.x = 0;
    if (this.position.y < 0) this.position.y = height;
    if (this.position.y > height) this.position.y = 0;
    
    point(this.position.x, this.position.y);
  }
  
}