class MineTrainer{
  int[][] board;
  int rows;
  int cols;
  NeuralNetwork nn;
  float fitness;
  float x;
  float y;
  float w;
  float h;
  boolean firstPicked;
  int num_of_mines;
  ArrayList<int[]> mines;
  boolean gameComplete;
  boolean win;
  MineTrainer(int boardW, int boardH, int num_of_mines){
    this.cols = boardW;
    this.rows = boardH;
    this.board = new int[this.cols][this.rows];
    for(int i = 0; i < this.cols; i++){
      for(int j = 0; j < this.rows;j++){
        this.board[i][j] = -1;
      }
    }
    this.x = 0;
    this.y = 0;
    this.w = boardW*SQUARE_SIZE;
    this.h = boardH*SQUARE_SIZE;
    this.num_of_mines = num_of_mines;
    this.mines = new ArrayList<int[]>();
    this.firstPicked = false;
    this.nn = new NeuralNetwork(3,boardW*boardH,0.1,0.3);
    this.fitness = 0;
    this.gameComplete = false;
    this.win = false;
  }
  MineTrainer(MineTrainer oldTrainer){
    this.cols = oldTrainer.cols;
    this.rows = oldTrainer.rows;
    this.board = new int[this.cols][this.rows];
    for(int i = 0; i < this.cols; i++){
      for(int j = 0; j < this.rows;j++){
        this.board[i][j] = -1;
      }
    }
    this.x = oldTrainer.x;
    this.y = oldTrainer.y;
    this.w = oldTrainer.w;
    this.h = oldTrainer.h;
    this.num_of_mines = oldTrainer.num_of_mines;
    this.mines = new ArrayList<int[]>();
    for(int i = 0; i < this.num_of_mines;i++){
      this.mines.add(oldTrainer.mines.get(i));
    }
    this.firstPicked = oldTrainer.firstPicked;
    this.nn = new NeuralNetwork(oldTrainer.nn);
    this.fitness = oldTrainer.fitness;
    this.gameComplete = oldTrainer.gameComplete;
    this.win = oldTrainer.win;
  }
  int[][] getBoard(){
    return(this.board);
  }
  void setBoard(int[][] newBoard){
    this.board = newBoard;
  }
  boolean checkMines(int x, int y){
    for(int i = 0; i < this.mines.size();i++){
      if(x == this.mines.get(i)[0] && y == this.mines.get(i)[1]){
        return(true);
      }
    }
    return(false);
  }
  void playerPick(float mX, float mY){
    if(!this.gameComplete){
      for(int i = 0; i < this.cols;i++){
        for( int j = 0; j < this.rows;j++){
          if(mX > this.x+i*SQUARE_SIZE && mX < this.x+(i+1)*SQUARE_SIZE && mY > this.y+j*SQUARE_SIZE && mY < this.y+(j+1)*SQUARE_SIZE){
            pickSquare(i,j);
          }
        }
      }
    }
  }
  void pickSquare(int x, int y){
    if(this.board[x][y] < 0){
      if(this.firstPicked){
        if(checkMines(x,y)){
          this.gameComplete = true; //game complete, player lost
          this.win = false;
        } else{
          clearSquare(x,y);
          int count = 0;
          for(int i = 0; i < this.cols;i++){
            for(int j = 0; j < this.rows;j++){
              if(this.board[i][j] == -1){
                count++;
              }
            }
          }
          if(count == this.num_of_mines){
            this.gameComplete = true; //game compelte, player won
            this.win = true;
          }
        }
      } else{
        while(this.mines.size() < this.num_of_mines){
          int randX = floor(random(this.cols));
          int randY = floor(random(this.rows));
          if(!(randX == x && randY == y)){
            if(!checkMines(randX,randY)){
              this.mines.add(new int[] {randX,randY});
            }
          }
        }
        this.firstPicked = true;
        clearSquare(x,y);
        int count = 0;
        for(int i = 0; i < this.cols;i++){
          for(int j = 0; j < this.rows;j++){
            if(this.board[i][j] == -1){
              count++;
            }
          }
        }
        if(count == this.num_of_mines){
          this.gameComplete = true; //game compelte, player won
          this.win = true;
        }
      }
    }
  }
  void clearSquare(int x, int y){
    if(!checkMines(x,y) && x > -1 && x < this.cols && y > -1 && y < this.rows){
      if(this.board[x][y] < 0){
        //do some min maxing stuff
        int newX = Math.max(Math.min(x,this.cols-1),0);
        int newY = Math.max(Math.min(y,this.rows-1),0);
        int num = 0;
        for(int i = 0; i < 3; i++){
          for(int j = 0; j < 3; j++){
            if(checkMines(newX+i-1,newY+j-1)){
              num++;
            }
          }
        }
        this.board[newX][newY] = num;
        if(num == 0){
          for(int i = 0; i < 3; i++){
            for(int j = 0; j < 3; j++){
              clearSquare(newX+i-1,newY+j-1);
            }
          }
        }
      }
    }
  }
  void computerPick(){
    if(!this.gameComplete){
      float[] inputs = new float[this.cols*this.rows];
      for(int i = 0; i < inputs.length;i++){
        inputs[i] = this.board[(int)(i/this.cols)][i%this.rows];
      }
      float[] outputs = this.nn.feedForward(inputs);
      float max = 0;
      int index = 0;
      for(int i = 0; i < outputs.length;i++){
        if(outputs[i] > max){
          max = outputs[i];
          index = i;
        }
      }
      if(this.board[index%this.cols][(int)(index/this.cols)] > -1){
        this.gameComplete = true;
      } else{
        pickSquare(index%this.cols,(int)(index/this.cols));
      }
      
    }
  }
  int[] computerPredict(){
    float[] inputs = new float[this.cols*this.rows];
    for(int i = 0; i < inputs.length;i++){
      inputs[i] = this.board[(int)(i/this.cols)][i%this.rows];
    }
    float[] outputs = this.nn.feedForward(inputs);
    float max = 0;
    int index = 0;
    for(int i = 0; i < outputs.length;i++){
      if(outputs[i] > max){
        max = outputs[i];
        index = i;
      }
    }
    return(new int[] {index%this.cols,(int)(index/this.cols)});
  }
  void calculateFitness(){
    this.fitness = 0;
    for(int i = 0; i < this.board.length;i++){
      for( int j = 0; j < this.board[0].length;j++){
        if(this.board[i][j] > -1){
          this.fitness += 1;
        }
      }
    }
    //calc stuff
  }
  MineTrainer mutate(){
    this.nn.mutate();
    return(this);
  }
  MineTrainer reset(){
    this.gameComplete = false;
    this.win = false;
    this.mines = new ArrayList<int[]>();
    this.firstPicked = false;
    return(this);
  }
  void show(){
    for(int i = 0; i < this.board.length; i++){
      for(int j = 0; j < this.board[0].length;j++){
        fill(255,255,255);
        rect(this.x+i*SQUARE_SIZE,this.y+j*SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
        if(gameComplete){
          if(checkMines(i,j)){
            fill(255,0,0);
            rect(this.x+i*SQUARE_SIZE,this.y+j*SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
          }
        }
        if(this.board[i][j] > -1){
          fill(0,0,0);
          textAlign(CENTER,CENTER);
          text(this.board[i][j],this.x+i*SQUARE_SIZE+SQUARE_SIZE/2,this.y+j*SQUARE_SIZE+SQUARE_SIZE/2);
        
        }
        
      }
    }
  }
}
