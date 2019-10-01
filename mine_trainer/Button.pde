class Button{
  String label;
  float x;
  float y;
  boolean clicked;
  float w;
  float h;
  Button(String label, float x, float y){
    this.label = label;
    this.x = x;
    this.y = y;
    this.clicked = false;
    textSize(16);
    this.h = 16;
    this.w = textWidth(label);
  }
  boolean clicked(){
    if(this.clicked){
      this.clicked = false;
      return true;
    }
    return false;
  }
  void update(){
    if(mouseX > this.x && mouseX < this.x+this.w && mouseY > this.y && mouseY < this.y+this.h){
      textSize(this.h);
      textAlign(LEFT,TOP);
      text("*",this.x-10,this.y);
      if(mouse){
        this.clicked = true;
        mouse = false;
      }
    }
  }
  void show(){
    fill(255,255,255);
    rect(this.x,this.y,this.w,this.h);
    fill(0,0,0);
    textSize(this.h);
    textAlign(LEFT,TOP);
    text(this.label,this.x,this.y);
  }
}
