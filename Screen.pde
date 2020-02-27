abstract class Screen{
  protected ArrayList<Button> buttons;
  
  public Screen(ArrayList<Button> buttons){
    this.buttons = buttons;
  }
  
  public abstract void show();
  
  public ArrayList<Button> getButtons(){
    return this.buttons;
  }
}