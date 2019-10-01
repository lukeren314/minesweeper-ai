class GradientDescent{
  int cols;
  int rows;
  int numOfMines;
  MineTrainer trainer;
  MineTrainer savedTrainer;
  GradientDescent(int boardW, int boardH, int numOfMines){
    this.cols = boardW;
    this.rows = boardH;
    this.numOfMines = numOfMines;
    this.trainer = new MineTrainer(this.cols,this.rows,this.numOfMines);
  }
  void trainStep(){
    this.trainer.reset();
    while(!this.trainer.gameComplete){
      this.trainer.computerPick();
    }
    if(this.trainer.win == false){
      this.trainer.nn.backpropagate(this.trainer.target);
    }
  }
  float calculateLoss(){
    gd.trainer.calculateFitness();
    return(1-gd.trainer.fitness/(gd.trainer.cols*gd.trainer.rows-gd.numOfMines));
  }
  void nextStep(){
    if(this.trainer.gameComplete){
      if(this.trainer.win == false){
        this.trainer.nn.backpropagate(this.trainer.target);
      }
    } else{
      this.trainer.computerPick();
    }
  }
  void saveTrainer(){
    
  }
  void loadTrainer(){
    
  }
}
