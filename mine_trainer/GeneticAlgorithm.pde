class GeneticAlgorithm{
  int gen_size;
  ArrayList<MineTrainer> trainers;
  ArrayList<MineTrainer> oldTrainers;
  ArrayList<MineTrainer> topTen;
  float averageFitness;
  int cols;
  int rows;
  int num_of_mines;
  GeneticAlgorithm(int gen_size,int boardW, int boardH,int num_of_mines){
    this.cols = boardW;
    this.rows = boardH;
    this.num_of_mines = num_of_mines;
    this.gen_size = gen_size;
    this.trainers = new ArrayList<MineTrainer>();
    this.oldTrainers = new ArrayList<MineTrainer>();
    this.topTen = new ArrayList<MineTrainer>();
    for(int i = 0; i < this.gen_size;i++){
      this.trainers.add(new MineTrainer(boardW,boardH,num_of_mines));
    }
    averageFitness = 0;
  }
  MineTrainer[] nextStep(){
    for(int i = this.trainers.size()-1; i >-1;i--){
        this.trainers.get(i).computerPick();
    }
    this.topTen = new ArrayList<MineTrainer>();
    boolean check;
    for(int i = 0; i < this.gen_size;i++){
      if(this.topTen.size() < 4){
        this.topTen.add(this.trainers.get(i));
      } else{
        check = false;
        for(int j = this.topTen.size()-1; j >= 0; j--){
          if(this.topTen.get(j).fitness < this.trainers.get(i).fitness && !check){
            this.topTen.remove(this.topTen.get(j));
            this.topTen.add(j,this.trainers.get(i));
            check = true;
          }
        }
      }
    }
    return(this.topTen.toArray(new MineTrainer[this.topTen.size()]));
  }
  void nextGeneration(){
    //println("starting ga");
    boolean extinction = false;
    float totalFitness = 0;
    this.oldTrainers = new ArrayList<MineTrainer>();
    while(!extinction){
      //println("Surviving trainers"+this.trainers.size());
      for(int i = this.trainers.size()-1; i >-1;i--){
        this.trainers.get(i).computerPick();
        if(this.trainers.get(i).gameComplete){
          this.trainers.get(i).calculateFitness();
          totalFitness += this.trainers.get(i).fitness;
          this.oldTrainers.add(this.trainers.get(i));
          this.trainers.remove(this.trainers.get(i));
        }
      }
      if(this.trainers.size() < 1){
        extinction = true;
      }
    }
    this.averageFitness = totalFitness/this.gen_size;
    for(int i = 0; i < this.trainers.size();i++){
      this.trainers.get(i).fitness /= totalFitness;
    }
    //println(oldTrainers.size(),trainers.size());
    //println("populating new generation");
    float r;
    int index;
    this.trainers = new ArrayList<MineTrainer>();
    for(int i = 0; i < this.gen_size;i++){
      r = random(1);
      index = 0;
      while(r >= 0){
        r -= this.oldTrainers.get(i).fitness;
        index++;
      }
      index--;
      //add a mutated copy
      //println("Number of new Trainers: "+this.trainers.size());
      this.trainers.add(new MineTrainer(this.oldTrainers.get(index)).reset().mutate());
    }
  }
  MineTrainer[] calculateTopTen(){
    this.topTen = new ArrayList<MineTrainer>();
    boolean check;
    for(int i = 0; i < this.gen_size;i++){
      if(this.topTen.size() < 4){
        this.topTen.add(this.oldTrainers.get(i));
      } else{
        check = false;
        for(int j = this.topTen.size()-1; j >= 0; j--){
          if(this.topTen.get(j).fitness < this.oldTrainers.get(i).fitness && !check){
            this.topTen.remove(this.topTen.get(j));
            this.topTen.add(j,this.oldTrainers.get(i));
            check = true;
          }
        }
      }
    }
    return(this.topTen.toArray(new MineTrainer[this.topTen.size()]));
  }
  void saveTrainers(){
    JSONObject config = new JSONObject();
    config.setInt("cols",this.cols);
    config.setInt("rows",this.rows);
    config.setInt("num_of_mines",this.num_of_mines);
    config.setInt("gen_size",this.gen_size);
    saveJSONObject(config,"data/config.json");
    for(int i = 0; i < this.gen_size;i++){
      this.trainers.get(i).nn.saveNN(Integer.toString(i));
    }
  }
  void loadTrainers(){
    JSONObject config = loadJSONObject("data/config.json");
    this.cols = config.getInt("cols");
    this.rows = config.getInt("rows");
    this.num_of_mines = config.getInt("num_of_mines");
    this.gen_size = config.getInt("gen_size");
    for(int i = 0; i < this.gen_size;i++){
      this.trainers.get(i).nn.loadNN(Integer.toString(i));
    }
  }
}
