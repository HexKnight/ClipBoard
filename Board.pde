class Board {
  private ArrayList<Hexagon> grid;
  private float radius;
  private int w, h;
  private int anchorX, anchorY;
  private float hx, hy;
  private ArrayList<Piece> parts;

  public Board(String difficulty) {
    if (difficulty.equals("easy")) {
      this.radius = xdp*.8;
      this.w = 6;
      this.h = 9;
      this.anchorX = 2;
      this.anchorY = 4;
    } else if (difficulty.equals("medium")) {
      this.radius = xdp/2;
      this.w = 10;
      this.h = 13;
      this.anchorX = 4;
      this.anchorY = 6;
    } else if (difficulty.equals("hard")) {
      this.radius = xdp/3;
      this.w = 16;
      this.h = 21;
      this.anchorX = 7;
      this.anchorY = 10;
    }

    this.hx = radius*sin(2*PI/3);
    this.hy = radius*cos(2*PI/3);

    this.parts = new ArrayList<Piece>();

//    this.grid = new HashMap<int[], Hexagon>();
//
//    for (int i=0; i<this.w; i++)
//      for (int j=0; j<this.h; j++)
//        if (!(i == this.w-1 && j % 2 == 0))
//          this.grid.put(new int[]{i, j}, new Hexagon(new PVector(i*2*this.hx - (this.w-1)*this.hx + (j%2==0?this.hx:0), j*1.5*this.radius - int(3*this.h/4)*this.radius), i, j, this.radius, color(random(0, 255), random(0, 255), random(0, 255)), false));
//
//    for (int[] k : this.grid.keySet())
//      this.grid.get(k).findNighbors(this.grid);

  }


  public Board(String difficulty, JSONArray grid) {
    if (difficulty.equals("easy")) {
      this.radius = xdp*.8;
      this.w = 6;
      this.h = 9;
      this.anchorX = 2;
      this.anchorY = 4;
    } else if (difficulty.equals("medium")) {
      this.radius = xdp/2;
      this.w = 10;
      this.h = 13;
      this.anchorX = 4;
      this.anchorY = 6;
    } else if (difficulty.equals("hard")) {
      this.radius = xdp/3;
      this.w = 16;
      this.h = 21;
      this.anchorX = 7;
      this.anchorY = 10;
    }

    this.hx = radius*sin(2*PI/3);
    this.hy = radius*cos(2*PI/3);

    this.parts = new ArrayList<Piece>();

    this.grid = new ArrayList<Hexagon>();

    int temp = 0;
    for (int i=0; i<this.w; i++) {
      for (int j=0; j<this.h; j++) {
        if (i == this.w-1 && j % 2 == 0)
          continue;
        if (grid.getInt(temp) == 1)
          this.grid.add(new Hexagon(new PVector(i*2*this.hx - (this.w-1)*this.hx + (j%2==0?this.hx:0),
                                                j*1.5*this.radius - int(3*this.h/4)*this.radius),
                                    i, j,
                                    this.radius,
                                    #B2134F,
                                    SpotType.DISABLED));
        else
          this.grid.add(new Hexagon(new PVector(i*2*this.hx - (this.w-1)*this.hx + (j%2==0?this.hx:0),
                                                j*1.5*this.radius - int(3*this.h/4)*this.radius),
                                    i, j,
                                    this.radius,
                                    #B2134F,
                                    SpotType.PLACE_HOLDER));
        this.grid.get(temp).setStrokeWeight(3);
        temp++;
      }
    }
  }


  public void show() {
    for (int k=0; k<this.grid.size(); k++) {
      if(this.grid.get(k).getSpot()==SpotType.PLACE_HOLDER)continue;
      this.grid.get(k).show();
      PVector pos = this.grid.get(k).getPosition();
      //fill(255);textSize(25);text(this.grid.get(k).getX()+", "+this.grid.get(k).getY()+"\n"+indexToKey(keyToIndex(new int[]{this.grid.get(k).getX(),this.grid.get(k).getY()}))[1], pos.x, pos.y);
    }
    
    for (Piece piece : this.parts)
      piece.show();
  }
  
  
  public void updateTouch(boolean click){//bool aint used
    for(int i=0; i<this.parts.size(); i++){
      if(this.parts.get(i).isTouched()){
        Piece piece = this.parts.get(i);
        pocket.setDragged(piece);
        this.parts.remove(i);
        
        int y = round(piece.getPosition().y/(-3*this.hy))+int(this.h/2-(this.h%2==0?.5:0));
        int x = round((piece.getPosition().x+((y%2==0)?0:this.hx))/(this.hx*2))+int(this.w/2-(this.w%2==0?.5:0));
    
        for(int j=0; j<piece.getGrid().size(); j++){
          if(piece.getGrid().get(j).getSpot() == SpotType.PLACE_HOLDER)
            continue;
          int[] k = piece.indexToKey(j);
          this.grid.get(this.keyToIndex(new int[]{k[0]+x-(y%2==0?0:(k[1]%2==0?0:1)), k[1]+y})).setSpot(SpotType.DISABLED);
        }
      }
    }
  }


  public ArrayList<Piece> crumble() {
    //crumbling algorithm
    ArrayList<Piece> pieces = new ArrayList<Piece>();

    ArrayList<PVector> cluster = new ArrayList<PVector>();
    for (int i=0; i<(this.w*this.h)/7; i++){
      cluster.add(new PVector(random(-(this.w/2)*this.radius,
                                     (this.w/2)*this.radius),
                              random(-(2*this.h/3)*this.radius,
                                     (2*this.h/3)*this.radius)));
      
    }



    return pieces;
  }


  //  private ArrayList<Boolean> connectarr;
  //  private boolean canBeRemoved(int x, int y) {
  //    if (this.grid.get(new int[]{x, y}) == null)
  //      return false;
  //    for (int[] nighbor : this.grid.get(new int[]{x, y}).getNighbors()) {
  //      connectarr = new ArrayList<Boolean>();
  //      if (! this.connectedToAnchor(this.grid.get(nighbor).x, this.grid.get(nighbor).y, new ArrayList<PVector>(), connectarr))
  //        return false;
  //    }
  //    return true;
  //  }
  //
  //
  //  private boolean jump = false;
  //  private boolean connectedToAnchor(int x, int y, ArrayList<PVector> previous, ArrayList<Boolean> connected) {
  //    previous.add(new PVector(x, y));
  //    // add a counter
  //    jump = false;
  //    for (int[] nighbor : this.grid.get(new int[]{x, y}).getNighbors()) {
  //      for (int k=0; k<previous.size(); k++) {
  //        if (this.grid.get(nighbor).x+x == previous.get(k).x && this.grid.get(nighbor).y+y == previous.get(k).y) {
  //          if (connected.size() == k)
  //            jump = true;
  //          else
  //            return true;
  //        }
  //      }
  //      if (jump) {
  //        jump = false;
  //        continue;
  //      }
  //      if (this.grid.get(nighbor).x+x == int(this.w/2) && this.grid.get(nighbor).y+y == int(this.h/2)) {
  //        connected.add(true);
  //        return true;
  //      } else if (this.connectedToAnchor(this.grid.get(nighbor).x+x, this.grid.get(nighbor).y+y, previous, connected)) {
  //        connected.add(true);
  //        return true;
  //      }
  //    }
  //    connected.add(false);
  //    return false;
  //  }


  public void snapPiece(Piece piece) {
    PVector piecePos = piece.getPosition();
    float snapX = round(piecePos.x/(this.hx*2))*(this.hx*2) + ((round(piecePos.y/(-this.hy*3)) % 2 == 0) ? 0 : this.hx);
    float snapY = round(piecePos.y/(-this.hy*3))*(-this.hy*3);
    piece.setPosition(new PVector(snapX, snapY));
  }
  
  
  private int keyToIndex(int[] k){
    if(k[0] == this.w-1)
      return k[1]+this.h*k[0]-floor(k[1]/2+1);
    else
      return k[1]+this.h*k[0];
  }
  
  
  private int[] indexToKey(int i){
    int x = floor(i / this.h);
    int y = i % this.h;
    if(x == this.w-1)
      y += y + 1;
    return new int[]{x, y};
  }
  
  
  private boolean inGrid(int[] k){
    for(Hexagon h : this.grid)
      if(h.getX() == k[0] && h.getY() == k[1])
        if(h.getSpot() != SpotType.PLACE_HOLDER)
          return true;
    return false;
  }
  
  
  public boolean placeIfCanBePlaced(Piece piece){
    int y = round(piece.getPosition().y/(-3*this.hy))+int(this.h/2-(this.h%2==0?.5:0));
    int x = round((piece.getPosition().x+((y%2==0)?0:this.hx))/(this.hx*2))+int(this.w/2-(this.w%2==0?.5:0));
    
    boolean broken = false, partBroken = false;
    
    for(int i=0; i<piece.getGrid().size(); i++){
      if(piece.getGrid().get(i).getSpot() == SpotType.PLACE_HOLDER)
        continue;
      int[] pieceKey = piece.indexToKey(i);
      int[] boardKey = new int[]{pieceKey[0]+x-(y%2==0?0:(pieceKey[1]%2==0?0:1)), pieceKey[1]+y};
      //text(boardKey[0]+", "+boardKey[1], piece.getGrid().get(pieceKey).getPosition().x, piece.getGrid().get(pieceKey).getPosition().y);
      partBroken = false;
      if(!(this.inGrid(boardKey))){
        piece.getGrid().get(i).setStrokeColor(#ff0000);
        broken = true;
        partBroken = true;
      }
      if(partBroken)continue;
      if(this.grid.get(this.keyToIndex(boardKey)).getSpot() == SpotType.ENABLED){
        piece.getGrid().get(i).setStrokeColor(#0000ff);
        broken = true;
      }
    }
    
    if(broken)return false;
    
    this.parts.add(piece);
    
    for(int i=0; i<piece.getGrid().size(); i++){
      if(piece.getGrid().get(i).getSpot() == SpotType.PLACE_HOLDER)
        continue;
      int[] k = piece.indexToKey(i);
      this.grid.get(this.keyToIndex(new int[]{k[0]+x-(y%2==0?0:(k[1]%2==0?0:1)), k[1]+y})).setSpot(SpotType.ENABLED);
    }
    return true;
  }


  public float getRadius() {
    return this.radius;
  }
  
}
