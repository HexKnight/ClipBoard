ArrayList<Particle> wind;

void setup(){
  fullScreen();
  
  wind = new ArrayList<Particle>();
  for (int i=0; i<150; i++)
    wind.add(new Particle());
    
  stroke(255);
  strokeWeight(3);
  fill(255);
  textAlign(CENTER);
  textSize(40);
}

void draw(){
  background(0, 100);
  text("من ذا اللّذي يشفع عنده\nإلّا بإذنه", width/2, height/2);
  for (Particle p : wind)
    p.updateAndShow();
}