abstract class Button{
  protected float x;
  protected float y;
  protected float w;
  protected float h;
  protected String txt;
  protected color clr, shd;
  protected boolean pressed;
  protected boolean toggled;
  
  public Button(float x, float y, float w, float h, String txt, color clr, color shd){
    this.x = x; this.y = y;
    this.w = w; this.h = h;
    this.txt = txt;
    this.clr = clr; this.shd = shd;
    this.pressed = false;
    this.toggled = false;
  }
  
  public void show(){
    noStroke();
    fill(this.shd);
    rect(this.x, this.y + xdp/5, this.w, this.h, xdp/3.5);
    fill(this.toggled?this.shd:this.clr);
    rect(this.x, this.y + (this.pressed||this.toggled?xdp/5:0), this.w,  this.h, xdp/3.5);
    textSize(xdp*.8);
    fill(this.toggled?this.clr:this.shd);
    text(this.txt, this.x, this.y + xdp/3 + (this.pressed||this.toggled?xdp/5:0));
  }
  
  abstract public void onClick();
  
  public void update(boolean click){
    if (this.toggled){
      this.pressed = true;
    }else if (touchX >= this.x-this.w/2
              && touchX <= this.x+this.w/2
              && touchY >= this.y-this.h/2
              && touchY <= this.y+this.h/2){
      this.pressed = true;
      if(click){
        this.onClick();
        this.pressed = false;
      }
    } else this.pressed = false;
  }
  
  public void setToggled(boolean toggled){
    this.toggled = toggled;
  }
  
  public boolean getToggled(){
    return this.toggled;
  }
  
  public String getName(){
    return this.txt;
  }
  
}