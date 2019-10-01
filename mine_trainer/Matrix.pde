class Matrix{
  int rows;
  int cols;
  float[][] values;
  Matrix(int rows,int cols){
    this.rows = rows;
    this.cols = cols;
    this.values = new float[this.rows][this.cols];
    for(int i = 0; i < this.rows;i++){
      for( int j = 0; j < this.cols;j++){
        this.values[i][j] = 0;
      }
    }
  }
  Matrix(float[][] values){
    this.rows = values.length;
    this.cols = values[0].length;
    this.values = new float[this.rows][this.cols];
    for(int i = 0; i < this.rows;i++){
      for( int j = 0; j < this.cols;j++){
        this.values[i][j] = values[i][j];
      }
    }
  }
  Matrix(float[] values){
    this.rows = values.length;
    this.cols = 1;
    this.values = new float[this.rows][this.cols];
    for(int i = 0; i < this.rows;i++){
      for( int j = 0; j < this.cols;j++){
        this.values[i][j] = values[i];
      }
    }
  }
  Matrix(Matrix matrix){
    this.rows = matrix.values.length;
    this.cols = matrix.values[0].length;
    this.values = new float[this.rows][this.cols];
    for(int i = 0; i < this.rows;i++){
      for( int j = 0; j < this.cols;j++){
        this.values[i][j] = matrix.values[i][j];
      }
    }
  }
  Matrix(JSONArray json){
    this.rows = json.size();
    this.cols = json.getJSONArray(0).size();
    for(int i = 0; i < json.size();i++){
      JSONArray row = json.getJSONArray(i);
      for(int j = 0; j < row.size();j++){
        this.values[i][j] = row.getFloat(j);
      }
    }
  }
  void addMatrix(Matrix m2){
    if(this.rows != m2.rows || this.cols != m2.cols){
      print("Matrix dimension mismatch");
    }
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] = this.values[i][j] + m2.values[i][j];
      }
    }
  }
  void addConstant(float c){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] += c;
      }
    }
  }
  Matrix multiplyMatrix(Matrix m2){
    if(this.cols != m2.rows){
      print("Matrix dimension mismatch");
    }
    Matrix newM = new Matrix(this.rows,m2.cols);
    for(int i = 0; i < newM.rows;i++){
      for(int j = 0; j < newM.cols;j++){
        float dot = 0;
        for(int k = 0; k < this.cols; k++){
          dot += this.values[i][k] * m2.values[k][j];
        }
        newM.values[i][j] = dot;
      }
    }
    return newM;
  }
  void multiplyConstant(float c){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] = this.values[i][j] * c;
      }
    }
  }
  void activate(){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] = sigmoid(this.values[i][j]);
      }
    }
  }
  Matrix transpose(){
    Matrix newM = new Matrix(this.cols,this.rows);
    for(int i = 0; i < newM.rows;i++){
      for(int j = 0; j < newM.cols;j++){
        newM.values[i][j] = this.values[j][i];
      }
    }
    return newM;
  }
  void zero(){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] = 0;
      }
    }
  }
  void randomize(){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        this.values[i][j] = random(-1,1);
      }
    }
  }
  void mutate(float mutation_rate){
    for(int i = 0; i < this.rows;i++){
      for(int j = 0; j < this.cols;j++){
        if(random(1) < mutation_rate){
          this.values[i][j] += random(-0.1,0.1);
        }
      }
    }
    
  }
  float[] asArray(){
    float[] arr = new float[this.rows*this.cols];
    for(int i = 0; i < arr.length;i++){
      arr[i] = this.values[(int)(i/this.cols)][i%this.cols];
    }
    return(arr);
  }
  JSONArray toJSONArray(){
    JSONArray json = new JSONArray();
    for(int i = 0; i < this.rows;i++){
      JSONArray row = new JSONArray();
      for(int j = 0; j < this.cols;j++){
        row.setFloat(j,this.values[i][j]);
      }
      json.setJSONArray(i,row);
    }
    return(json);
  }
}
float sigmoid(float x){
  return((float)(1/(1+Math.exp(x))));
}
