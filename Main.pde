float xdp, ydp;
int touchX, touchY;
HashMap<String, Screen> screens;
Screen current;
JSONArray levels;
JSONObject level;
int time, timeStart;
Board board;
Pocket pocket;


void setup() {
  fullScreen();
  textAlign(CENTER);
  rectMode(CENTER);
  smooth(4);

  xdp = width/10;
  ydp = height/10;
  
  time = 0;

  levels = loadJSONArray("levels.json");

  screens = new HashMap<String, Screen>();


  /* start TITLE SCREEN */
  // buttons for the title screen:
  ArrayList<Button> btns = new ArrayList<Button>();
  btns.add(new Button(0, -ydp, 6*xdp, ydp, "Progress Mode", #A7133A, #65132B) {
    @Override
    public void onClick() {
      current = screens.get("select");
    }
  }
  );
  btns.add(new Button(0, ydp/2, 6*xdp, ydp, "Endless Mode", #A7133A, #65132B) {
    @Override
    public void onClick() {
      timeStart = millis()/1000;
      board = new Board("hard");
      pocket = new Pocket(new ArrayList<Piece>());
      current = screens.get("infinit");
    }
  }
  );

  screens.put("title", new Screen(btns) {
    @Override
    public void show() {
      background(230);
      stroke(0);
      strokeWeight(5);
      for (int i=0; i<8; i++) {
        for (int j=0; j<20; j++) {
          fill(random(200), random(100), random(255));
          hexagon(-7*xdp + i*2*xdp + (j%2==0?0:xdp), -9.75*xdp + 1.5*j*xdp, xdp/2);
        }
      }
      for (Button btn : this.buttons)
        btn.show();
    }
  }
  );
  /* end TITLE SCREEN */


  /* start LEVEL_SELECTION SCREEN */
  // buttons for the level selection screen:
  btns = new ArrayList<Button>();
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      level = levels.getJSONObject(0);
      btns.add(new Button((10*xdp/3)*i - 3.5*xdp, (10*ydp/3)*j - 3.5*ydp, 2*xdp, ydp, str(level.getInt("level")), #EBAD38, #986D1C) {
        @Override
        public void onClick() {
          board = new Board(level.getString("difficulty"), level.getJSONArray("grid"));
          ArrayList<Piece> parts = new ArrayList<Piece>();
          for (int k=0; k<level.getJSONArray("pieces").size(); k++)
            parts.add(new Piece(level.getJSONArray("pieces").getJSONArray(k), new PVector(k*2*xdp - 2.5*xdp, 4*ydp), ydp/7));
          pocket = new Pocket(parts);
          //for(int i=0; i<3; i++)
          //parts.get(i).setPosition(new PVector(i*2*xdp + 2*xdp, 4*ydp));
          timeStart = millis()/1000;
          current = screens.get("level");
        }
      }
      );
    }
  }

  screens.put("select", new Screen(btns) {
    @Override
    public void show() {
      // select select draws
      background(54);
      for (Button btn : this.buttons)
        btn.show();
    }
  }
  );
  /* end LEVEL_SELCTION SCREEN */
  
  
  /* start WIN SCREEN */
  // buttons for the win screen:
  btns = new ArrayList<Button>();
  btns.add(new Button(-3*xdp, 2*ydp, 2*xdp, ydp, "<<", #A7133A, #65132B) {
    @Override
    public void onClick() {
      
    }
  }
  );
  btns.get(0).setToggled(true);
  btns.add(new Button(0, 2*ydp, 2*xdp, ydp, "O", #A7133A, #65132B) {
    @Override
    public void onClick() {
      text("stfu", 0, -2*ydp);
    }
  }
  );
  btns.add(new Button(3*xdp, 2*ydp, 2*xdp, ydp, ">>", #A7133A, #65132B) {
    @Override
    public void onClick() {
      
    }
  }
  );

  screens.put("win", new Screen(btns) {
    @Override
    public void show() {
      // win draws
      background(54);
      screens.get("level").show();
      fill(0, 200);
      noStroke();
      rect(0, 0, width, height);
      for (Button btn : this.buttons)
        btn.show();
      fill(#00E9E8);
      textSize(xdp);
      text("You Won?", 0, -3*ydp);
      fill(#DFA107);
      stroke(#DFA107);
      strokeWeight(5);
      star(-3*xdp, 0, 1.3*xdp, -PI/8);
      if(time >= 60)
        noFill();
      star(0, -ydp/2, 1.5*xdp, 0);
      if(time >= 30)
        noFill();
      star(3*xdp, 0, 1.3*xdp, PI/8);
    }
  }
  );
  /* end WIN SCREEN */


  /* start INFINIT_PLAY SCREEN */
  // buttons for the infinit play screen:
  btns = new ArrayList<Button>();

  screens.put("infinit", new Screen(btns) {
    @Override
      public void show() {
      // infinite play draws
      if(current == screens.get("level"))
        time += (millis()/1000-timeStart) > time ? 1 : 0;
      background(54);
      fill(255);
      text(str(time)+"s", -3.5*xdp, -4*ydp);
      board.show();
      for (Button btn : this.buttons)
        btn.show();
    }
  }
  );
  /* end INFINIT_PLAY SCREEN */


  /* start LEVEL_PLAY SCREEN */
  // buttons for the level play screen:
  btns = new ArrayList<Button>();
  
  screens.put("level", new Screen(btns) {
    @Override
      public void show() {
      // levels play draws
      if(current == screens.get("level"))
        time += (millis()/1000-timeStart) > time ? 1 : 0;
      background(54);
      fill(255);
      text(str(time)+"s", -3.5*xdp, -4*ydp);
      board.show();
      pocket.updateAndShow();
    }
  }
  );
  /* end LEVEL_PLAY SCREEN */

  current = screens.get("title");
}



void draw() {
  background(54);
  translate(width/2, height/2);
  if (mouseX != touchX || mouseY != touchY) {
    touchX = mouseX-width/2;
    touchY = mouseY-height/2;
  }//pointLight(255, 255, 255, 255, 255, 255);
  
  // Draw The Current Screen:
  current.show();
  
  fill(255);text(floor(frameRate)+"fps", 260, -500);//ellipse(0,0,5,5)
}



void touchStarted() {
  touchX = mouseX-width/2;
  touchY = mouseY-height/2;
  for (Button btn : current.getButtons())
    btn.update(false);
    
  if(current.equals(screens.get("level")) || current.equals(screens.get("infinit"))){
    board.updateTouch(false);
    pocket.updateTouch(false);
  }
  
}


void touchEnded() {
  for (Button btn : current.getButtons())
    btn.update(true);
  
  if(current.equals(screens.get("level")) || current.equals(screens.get("infinit"))){
    pocket.updateTouch(true);
    if(pocket.isEmpty())
      current = screens.get("win");
  }
}


void keyPressed() {
  if (key == CODED && keyCode == android.view.KeyEvent.KEYCODE_BACK) {
    keyCode = 0;  // don't quit by default
    println("BACK key pressed") ; // to prove the code ran to here ...
    return;
  }
}


void hexagon(float x, float y, float radius) {
  float hx = radius*sin(2*PI/3);
  float hy = radius*cos(2*PI/3);
  beginShape();
  vertex(x, y + radius);
  vertex(x + hx, y - hy);
  vertex(x + hx, y + hy);
  vertex(x, y - radius);
  vertex(x - hx, y + hy);
  vertex(x - hx, y - hy);
  vertex(x, y + radius);
  endShape();
}


void star(float x, float y, float radius, float rotation){
  rotation += 3*PI/10;
  beginShape();
  for(int i=0; i<11; i++){
    vertex(x+radius*cos(i*2*PI/5+rotation),
           y+radius*sin(i*2*PI/5+rotation));
    vertex(x+(radius/2)*cos(i*2*PI/5+PI/5+rotation),
           y+(radius/2)*sin(i*2*PI/5+PI/5+rotation));
  }
  endShape();
}
