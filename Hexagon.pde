class Hexagon{
  
  private PVector position;
  private int x, y;
  private float radius;
  private color clr;
  private color strokeC;
  private int strokeW;
  private SpotType spot;
  private ArrayList<int[]> nighbors;
  
  
  public Hexagon(PVector position, int x, int y, float radius, color clr, SpotType spot){
    this.position = position;
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.clr = clr;
    this.strokeC = 255;
    this.strokeW = 2;
    this.spot = spot;
    this.nighbors = new ArrayList<int[]>();
  }
  
  
  public Hexagon(PVector position, int x, int y, float radius, color clr, color strokeC, int strokeW, SpotType spot){
    this.position = position;
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.clr = clr;
    this.strokeC = strokeC;
    this.strokeW = strokeW;
    this.spot = spot;
    this.nighbors = new ArrayList<int[]>();
  }
  
  
  public void findNighbors(HashMap<int[], Hexagon> grid){
    int[][] nighborPos = new int[][]{{this.x-1, this.y-1},
                                     {this.x-1, this.y},
                                     {this.x-1, this.y+1},
                                     {this.x, this.y-1},
                                     {this.x, this.y+1},
                                     {this.x+1, this.y}};
    for(int[] nighbor : nighborPos)
      if(grid.get(nighbor) != null)
        this.nighbors.add(nighbor);
  }
  
  
  public void show(){
    strokeWeight(this.strokeW);
    stroke(this.strokeC);
    fill(this.spot==SpotType.ENABLED?this.clr:0);
    hexagon(this.position.x, this.position.y, this.radius);
  }
  
  
  public boolean isTouched(){
    return dist(this.position.x, this.position.y, touchX, touchY) <= this.radius;
  }
  
  
  public PVector getPosition(){
    return this.position;
  }
  
  
  public ArrayList<int[]> getNighbors(){
    return this.nighbors;
  }
  
  
  public int getX(){
    return this.x;
  }
  
  
  public int getY(){
    return this.y;
  }
  
  public SpotType getSpot(){
    return this.spot;
  }
  
  
  public void setPosition(PVector position){
    this.position = position;
  }
  
  public void setRadius(float radius){
    this.radius = radius;
  }
  
  public void setColor(color clr){
    this.clr = clr;
  }
  
  public void setStrokeColor(color strokeC){
    this.strokeC = strokeC;
  }
  
  public void setStrokeWeight(int strokeW){
    this.strokeW = strokeW;
  }
  
  public void setSpot(SpotType spot){
    this.spot = spot;
  }
}

public static enum SpotType{
  PLACE_HOLDER,
  ENABLED,
  DISABLED
}