final int SQUARE_SIZE = 8;
final int GENERATION_SIZE = 100;
final int BOARD_WIDTH = 16;
final int BOARD_HEIGHT = 16;
final int NUM_OF_MINES = 40;
final int SPACING = 250;
//GeneticAlgorithm ga = new GeneticAlgorithm(GENERATION_SIZE,BOARD_WIDTH,BOARD_HEIGHT,NUM_OF_MINES);
GradientDescent gd = new GradientDescent(BOARD_WIDTH,BOARD_HEIGHT,NUM_OF_MINES);
int mode = 0;
int timer = 0;
int gensTrained = 0;
float timeElapsed = 0;
float trainingTime = 0;
boolean repeatTraining = false;
ArrayList<Float> graphData = new ArrayList<Float>();
Button modeButton;
Button[] trainButtons;
Button[] predictButtons;
boolean mouse = false;
void mousePressed(){
  mouse = true;
}
void mouseReleased(){
  mouse = false;
}
void setup(){
  size(1280,720);
  modeButton = new Button("Change Mode",1000,50);
  trainButtons = new Button[] {
    new Button("Train 1 Step",1000,150),
    new Button("Train 100 Steps",1000,250),
    new Button("Save Trainer",1000,350),
    new Button("Load Trainer",1000,450),
    new Button("Next Predict",1000,550),
    new Button("Train X Generations",1000,650)
  };
  predictButtons = new Button[] {
    new Button("Predict Move",1000,150),
    new Button("New Board",1000,250),
    new Button("Custom Board",1000,350)
  };
  //for(int i = 0; i < topTen.length;i++){
  //  topTen[i] = ga.trainers.get(i);
  //}
}

void draw(){
  background(255,192,203);
  modeButton.update();
  modeButton.show();
  if(modeButton.clicked()){
    mode = (mode == 0) ? 1 : 0;
  }
  //display data
  fill(0,0,0);
  textAlign(LEFT,TOP);
  text("Time Elapsed: "+timeElapsed+" milliseconds",50,height-50);
  text("Total Training Time:"+trainingTime+" milliseconds",350,height-50);
  for(int i = 0; i < graphData.size();i++){
    rect(50+i*2,height-100-graphData.get(i)*100,2,2);
  }
  if(graphData.size() > 200){
    graphData.remove(0);
  }
  gd.trainer.show();
  //buttons
  switch(mode){
    case 0:
      //train gen if timer is > 0
      if(repeatTraining){
        timer = 1;
      }
      if(timer > 0){
        int start = millis();
        gd.trainStep();
        graphData.add(gd.calculateLoss());
        timeElapsed = millis()-start;
        trainingTime += timeElapsed;
        timer--;
        gensTrained++;
      }
      for(int i = 0; i < trainButtons.length;i++){
        trainButtons[i].update();
        trainButtons[i].show();
        if(trainButtons[i].clicked()){
        //  trainButtons = new Button[] {
        //  new Button("Train 1 Step",1000,150),
        //  new Button("Train 100 Steps",1000,250),
        //  new Button("Save Trainer",1000,350),
        //  new Button("Load Trainer",1000,450),
        //  new Button("Next Predict",1000,550),
        //  new Button("Train X Generations",1000,650)
        //};
        //predictButtons = new Button[] {
        //  new Button("Predict Move",1000,150),
        //  new Button("New Board",1000,250),
        //  new Button("Custom Board",1000,350)
        //};
          switch(i){
            case 0: //train 1 step
              timer = 1;
              break;
            case 1: //train 100 steps
              timer = 100;
              break;
            case 2: //save trainers
              //ga.saveTrainers();
              break;
            case 3: //load trainers
              //ga.loadTrainers();
              break;
            case 4: //next predict
              //topTen = ga.nextStep();
              gd.nextStep();
              break;
            case 5: //train continuously
              if(repeatTraining){
                repeatTraining = false;
              } else{
                repeatTraining = true;
              }
              break;
          }
        }
      }
      break;
    case 1:
      for(int i = 0; i < predictButtons.length;i++){
        switch(i){
          case 0: //predict next move
            this.gd.trainer.highlightSquare(this.gd.trainer.computerPredict());
            break; 
          case 1: //new board
            this.gd.trainer.reset();
            break;
          case 2: //custom board
            break;
        }
      }
      break;
  }
}
