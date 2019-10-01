final int SQUARE_SIZE = 8;
final int GENERATION_SIZE = 250;
final int BOARD_WIDTH = 16;
final int BOARD_HEIGHT = 16;
final int NUM_OF_MINES = 40;
final int SPACING = 250;
GeneticAlgorithm ga = new GeneticAlgorithm(GENERATION_SIZE,BOARD_WIDTH,BOARD_HEIGHT,NUM_OF_MINES);
int mode = 0;
int timer = 0;
int gensTrained = 0;
float timeElapsed = 0;
float trainingTime = 0;
boolean repeatTraining = false;
float fitnessAverage = 0;
ArrayList<Float> graphData = new ArrayList<Float>();
Button modeButton;
Button[] trainButtons;
Button[] predictButtons;
MineTrainer[] topTen = new MineTrainer[4];
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
    new Button("Train 1 Generation",1000,150),
    new Button("Train 100 Generations",1000,250),
    new Button("Save Trainers",1000,350),
    new Button("Load Trainers",1000,450),
    new Button("Next Step",1000,550),
    new Button("Train X Generations",1000,650)
  };
  predictButtons = new Button[] {
    new Button("Use Best Trainer",1000,150),
    new Button("Use Random by Fitness",1000,250),
    new Button("Predict Move",1000,350)
  };
  for(int i = 0; i < topTen.length;i++){
    topTen[i] = ga.trainers.get(i);
  }
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
  fill(0,0,255);
  for(int i = 0; i < graphData.size();i++){
    rect(50+i*2,height-100-graphData.get(i),2,2);
  }
  //buttons
  switch(mode){
    case 0:
      //show like top 10
      for(int i = 0; i < topTen.length; i++){
        topTen[i].x = (i%2)*(topTen[i].w+SPACING);
        topTen[i].y = (int)(i/2)*(topTen[i].h+SPACING/5);
        topTen[i].show();
        fill(0,0,0);
        textAlign(LEFT,TOP);
        text(String.format("Fitness: %f\n Won?: %b",topTen[i].fitness,topTen[i].win),(i%2)*(topTen[i].w+SPACING)+topTen[i].w+10,(int)(i/2)*(topTen[i].h+SPACING/5));
        //display fitness next to the graph???
      }
      //train gen if timer is > 0
      if(repeatTraining){
        timer = 1;
      }
      if(timer > 0){
        int start = millis();
        ga.nextGeneration();
        topTen = ga.calculateTopTen();
        timeElapsed = millis()-start;
        trainingTime += timeElapsed;
        timer--;
        gensTrained++;
        fitnessAverage = 0;
        for(int i = 0; i < this.topTen.length;i++){
          fitnessAverage += topTen[i].fitness;
        }
        fitnessAverage /= topTen.length;
        graphData.add(fitnessAverage);
        if(graphData.size() > 1000){
          graphData.remove(0);
        }
      }
      for(int i = 0; i < trainButtons.length;i++){
        trainButtons[i].update();
        trainButtons[i].show();
        if(trainButtons[i].clicked()){
          
          switch(i){
            case 0: //train 1 gen
              timer = 1;
              break;
            case 1: //train 100 gen
              timer = 100;
              break;
            case 2: //save trainers
              ga.saveTrainers();
              break;
            case 3: //load trainers
              ga.loadTrainers();
              break;
            case 4: //next step
              topTen = ga.nextStep();
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
          case 0: //use best trainer
            break; 
          case 1: //use random trainer by fitness
            break;
          case 2: //predict the best move
            break;
        }
      }
      //do some kind of configurable board stuff and have computer predict
      break;
  }
}
