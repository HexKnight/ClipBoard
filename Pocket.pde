class Pocket{
  public ArrayList<Piece> parts;
  private Piece draggedPiece;
  private int draggedIndex;
  private Button leftbtn, rightbtn;
  
  public Pocket(ArrayList<Piece> parts){
    this.parts = parts;
    
    for(int i=0; i<this.parts.size(); i++){
      int rand1 = floor(random(this.parts.size()));
      int rand2 = 0;
      while(rand2 == rand1){
        rand2 = floor(random(this.parts.size()));
      }
      Piece temp = this.parts.get(rand1);
      this.parts.set(rand1, this.parts.get(rand2));
      this.parts.set(rand2, temp);
    }
    
    int partsSize = this.parts.size() >= 3 ? 3 : this.parts.size();
    for (int i=0; i<partsSize; i++)
      this.parts.get(i).setPosition(new PVector(i*2*xdp - 2.5*xdp, 4*ydp));
    
    this.leftbtn = new Button(-4*xdp, 4.25*ydp, 1.5*xdp, 1.2*ydp, "<", #A7133A, #65132B) {
      @Override
      public void onClick() {
        if(pocket.parts.size() != 0){
          Piece temp = pocket.parts.get(pocket.parts.size()-1);
          pocket.parts.remove(pocket.parts.size()-1);
          pocket.parts.add(0, temp);
          int partsSize = pocket.parts.size() >= 3 ? 3 : pocket.parts.size();
          for (int i=0; i<partsSize; i++)
            pocket.parts.get(i).setPosition(new PVector(i*2*xdp - 2.5*xdp, 4*ydp));
        }
      }
    };
    
    this.rightbtn = new Button(4*xdp, 4.25*ydp, 1.5*xdp, 1.2*ydp, ">", #A7133A, #65132B) {
      @Override
      public void onClick() {
        if(pocket.parts.size() != 0){
          Piece temp = pocket.parts.get(0);
          pocket.parts.remove(0);
          pocket.parts.add(temp);
          int partsSize = pocket.parts.size() >= 3 ? 3 : pocket.parts.size();
          for (int i=0; i<partsSize; i++)
            pocket.parts.get(i).setPosition(new PVector(i*2*xdp - 2.5*xdp, 4*ydp));
        }
      }
    };
    
  }
  
  
  public void updateAndShow(){
    if(this.draggedPiece != null){
      //if(this.draggedPiece.isTouched()){ can be removed?
      this.draggedPiece.setPosition(new PVector(touchX-board.getRadius()*2, touchY-board.getRadius()*2));
      board.snapPiece(draggedPiece);
    }
    
    fill(40);
    noStroke();
    rect(0, 4.32*ydp, 8*xdp, 1.2*ydp);
    
    int partsSize = this.parts.size() >= 3 ? 3 : this.parts.size();
    for (int i=0; i<partsSize; i++)
      this.parts.get(i).show();
    
    this.leftbtn.show();
    this.rightbtn.show();
    
    if(draggedPiece != null)
      draggedPiece.show();
    
  }
  
  
  public void updateTouch(boolean click){
    this.leftbtn.update(click);
    this.rightbtn.update(click);
    if(!click){ /* Touch Started */
    
      int partsSize = this.parts.size() >= 3 ? 3 : this.parts.size();
      for(int i=0; i<partsSize; i++){
        partsSize = this.parts.size() >= 3 ? 3 : this.parts.size();
        if(i >= partsSize)
          continue;
        if(parts.get(i).isAreaTouched()){
          this.draggedPiece = this.parts.get(i).copy();
          this.draggedPiece.setRadius(board.getRadius());
          for(int j=0; j<this.draggedPiece.getGrid().size(); j++)
            if(this.draggedPiece.getGrid().get(j).getSpot() != SpotType.PLACE_HOLDER)
              this.draggedPiece.getGrid().get(j).setStrokeWeight(3);
          this.draggedIndex = i;
          if(this.parts.size() > 3)
            for (int j=0; j<partsSize; j++)
              this.parts.get(j).setPosition(new PVector(j*2*xdp - 2.5*xdp, 4*ydp));
        }
      }
      if(this.draggedPiece != null)
        for(int j=0; j<this.draggedPiece.getGrid().size(); j++)
          if(this.draggedPiece.getGrid().get(j).getSpot() != SpotType.PLACE_HOLDER)
            this.draggedPiece.getGrid().get(j).setStrokeColor(255);
      
    } else { /* Touch Ended */
    
      if(this.draggedPiece != null){
//        if(this.isTouched()){
//          this.parts.add(1, this.draggedPiece = null);
//        }
        if(board.placeIfCanBePlaced(this.draggedPiece)){
          this.parts.remove(this.draggedIndex);
          this.draggedPiece = null;
          int partsSize = pocket.parts.size() >= 3 ? 3 : pocket.parts.size();
          for (int i=0; i<partsSize; i++)
            pocket.parts.get(i).setPosition(new PVector(i*2*xdp - 2.5*xdp, 4*ydp));
        }
      }
    
    }
  }
  
  
  public void setDragged(Piece piece){
    this.draggedPiece = piece; // add to pocket
    this.draggedIndex = 1;
    Piece temp = piece.copy();
    temp.resetRadius();
    this.parts.add(1, temp);
    int partsSize = this.parts.size() >= 3 ? 3 : this.parts.size();
    for (int i=0; i<partsSize; i++)
      this.parts.get(i).setPosition(new PVector(i*2*xdp - 2.5*xdp, 4*ydp));
  }
  
  
  private boolean isTouched(){
    return touchY >= 4.32 * ydp;
  }
  
  
  public boolean isEmpty(){
    return this.parts.size() == 0;
  }
  
}