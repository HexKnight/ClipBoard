class Piece{
  private JSONArray dataGrid;
  private ArrayList<Hexagon> grid;
  private color clr;
  private PVector position;
  private float radius, defRadius;
  private float hx, hy;
  
  
//  public Piece(HashMap<int[], Hexagon> grid){
//    this.grid = grid;
//  }
  
  
  public Piece(JSONArray dataGrid, PVector position, float radius){
    this.dataGrid = dataGrid;
    this.grid = new ArrayList<Hexagon>();
    this.clr = pieceColor[int(random(0, pieceColor.length))];
    this.position = position;
    this.radius = radius;
    this.defRadius = radius;
    this.hx = radius*sin(2*PI/3);
    this.hy = radius*cos(2*PI/3);
    int temp = 0;
    for(int j=0; j<4; j++){
      for(int i=0; i<4; i++){
        if(dataGrid.getInt(temp) == 1){
          this.grid.add(new Hexagon(new PVector(i*2*this.hx - (j%2==0?0:this.hx) + this.position.x,
                                                j*1.5*this.radius + this.position.y),
                                    i, j,
                                    this.radius,
                                    this.clr,
                                    SpotType.ENABLED));
        }else{
          this.grid.add(new Hexagon(new PVector(i*2*this.hx - (j%2==0?0:this.hx) + this.position.x,
                                                j*1.5*this.radius + this.position.y),
                                    i, j,
                                    this.radius,
                                    this.clr,
                                    SpotType.PLACE_HOLDER));
        }
        temp++;
      }
    }
  }
  
  
  public Piece(JSONArray dataGrid, PVector position, float radius, float defRadius, color clr){
    this(dataGrid, position, radius);
    this.defRadius = defRadius;
    this.setColor(clr);
  }
  
  
  public void show(){
    for (int i=0; i<this.grid.size(); i++)
      if(!(this.grid.get(i).getSpot() == SpotType.PLACE_HOLDER))
        this.grid.get(i).show();
  }
  
  
  
  public boolean isTouched(){
    for(Hexagon h : this.grid)
      if(h.isTouched() && h.getSpot() == SpotType.ENABLED)
        return true;
    return false;
  }
  
  
  public boolean isAreaTouched(){
    float cornerX = this.position.x - this.hx;
    float cornerY = this.position.y - this.radius;
    float cornerW = cornerX + 7*this.radius;
    float cornerH = cornerY - 13*this.hy;
    if(cornerX <= touchX
       && cornerY <= touchY
       && cornerW >= touchX
       && cornerH >= touchY)
      return true;
    else
      return false;
  }
  
  
  public int keyToIndex(int[] k){
    if(k[0] == 4-1)
      return k[1]+4*k[0]-floor(k[1]/2+1);
    else
      return k[1]+4*k[0];
  }
  
  
  public int[] indexToKey(int i){
    int x = i % 4;
    int y = floor(i / 4);
    return new int[]{x, y}; // attention!
  }
  
  
//  public void setGrid(HashMap<int[], Hexagon> grid){
//    this.grid = grid;
//  }
  
  public void setPosition(PVector position){
    this.position = position;
    int[] k;
    for (int i=0; i<this.grid.size(); i++){
      k = indexToKey(i);
      this.grid.get(i).setPosition(new PVector(k[0]*2*this.hx - (k[1]%2==0?0:this.hx) + this.position.x,
                                               k[1]*1.5*this.radius + this.position.y));
    }
  }
  
  
  public void setRadius(float radius){
    this.radius = radius;
    this.hx = radius*sin(2*PI/3);
    this.hy = radius*cos(2*PI/3);
    for (int i=0; i<this.grid.size(); i++)
      this.grid.get(i).setRadius(radius);
    this.setPosition(this.position);
  }
  
  
  public void resetRadius(){
    this.setRadius(this.defRadius);
  }
  
  
  public void setColor(color clr){
    this.clr = clr;
    for (int i=0; i<this.grid.size(); i++){
      this.grid.get(i).setColor(clr);
    }
  }
  
  
  public ArrayList<Hexagon> getGrid(){
    return this.grid;
  }
  
  public color getColor(){
    return this.clr;
  }
  
  public PVector getPosition(){
    return this.position;
  }
  
  public float getRadius(){
    return this.radius;
  }
  
  
  public Piece copy(){
    return new Piece(this.dataGrid, this.position, this.radius, this.defRadius, this.clr);
  }
  
}

color[] pieceColor = new color[]{
  #B91A3F,
  #249D4B,
  #3669A0,
  #D1A80D,
  #D75B0F,
  #2FD4C3,
  #84D42F,
  #782FD4,
  #823400,
  #B4309A,
  #5919BA,
  #E5EF3D,
  #EF543D,
  #3DEFBD,
  #3DA6EF,
  #963DEF,
  #EF3D74
};