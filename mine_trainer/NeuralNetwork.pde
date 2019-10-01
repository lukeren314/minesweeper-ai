//class NeuralNetwork{
//  int num_of_layers;
//  int size_of_layer;
//  float lr; //learning rate
//  float mr; //mutation rate
//  float[][] layers;
//  float[][][] weights;
//  float[][][] gradients;
//  float[] biases;
//  NeuralNetwork(int num_of_layers, int size_of_layer, float lr, float mr){
//    this.num_of_layers = num_of_layers;
//    this.size_of_layer = size_of_layer;
//    this.layers = new float[num_of_layers][size_of_layer];
//    this.weights = new float[num_of_layers][size_of_layer][size_of_layer];
//    for(int i = 0; i < this.weights.length;i++){
//      for(int j = 0; j < this.weights[0].length;j++){
//        for(int k = 0; k < this.weights[0][0].length;k++){
//          this.weights[i][j][k] = random(1);
//        }
//      }
//    }
//    this.gradients = new float[num_of_layers][size_of_layer][size_of_layer];
//    for(int i = 0; i < this.gradients.length;i++){
//      for(int j = 0; j < this.gradients[0].length;j++){
//        for(int k = 0; k < this.gradients[0][0].length;k++){
//          this.weights[i][j][k] = random(1);
//        }
//      }
//    }
//    this.biases = new float[num_of_layers];
//    for(int i = 0; i < this.biases.length;i++){
//      this.biases[i] = random(1);
//    }
//    this.lr = lr;
//    this.mr = mr;
//  }
//  NeuralNetwork(NeuralNetwork nn){
//    this.num_of_layers = nn.num_of_layers;
//    this.size_of_layer = nn.size_of_layer;
//    this.layers = new float[num_of_layers][size_of_layer];
//    for(int i = 0; i < layers.length;i++){
//      layers[i] = nn.layers[i];
//    }
//    this.weights = new float[num_of_layers][size_of_layer][size_of_layer];
//    for(int i = 0; i < this.weights.length;i++){
//      for(int j = 0; j < this.weights[0].length;j++){
//        for(int k = 0; k < this.weights[0][0].length;k++){
//          this.weights[i][j][k] = nn.weights[i][j][k];
//        }
//      }
//    }
//    this.gradients = new float[num_of_layers][size_of_layer][size_of_layer];
//    for(int i = 0; i < this.gradients.length;i++){
//      for(int j = 0; j < this.gradients[0].length;j++){
//        for(int k = 0; k < this.gradients[0][0].length;k++){
//          this.gradients[i][j][k] = nn.gradients[i][j][k];
//        }
//      }
//    }
//    this.biases = new float[num_of_layers];
//    for(int i = 0; i < this.num_of_layers;i++){
//      this.biases[i] = nn.biases[i];
//    }
//    this.lr = nn.lr;
//    this.mr = nn.mr;
//  }
//  float[] feedForward(float[] inputs){
//    this.layers[0] = new Matrix(inputs);
//    for(int i = 0; i < this.num_of_layers - 1;i++){
//      this.layers[i+1] = this.weights[i].multiplyMatrix(this.layers[i]);
//      this.layers[i+1].addConstant(biases[i]);
//      this.layers[i+1].activate();
//    }
//    return(this.layers[this.layers.length-1].asArray());
//  }
//  void backpropagate(){
    
//  }
//  void mutate(){
//    for(int i = 0; i < this.weights.length;i++){
//      weights[i].mutate(this.mr);
//    }
//    for(int i = 0; i < this.biases.length;i++){
//      if(random(1) < this.mr){
//        this.biases[i] += random(-0.1,0.1);
//      }
//    }
//  }
//  void mate(){
    
//  }
//}


///old matrix implementation



class NeuralNetwork{
  int num_of_layers;
  int size_of_layer;
  float lr; //learning rate
  float mr; //mutation rate
  Matrix[] layers;
  Matrix[] weights;
  float[] biases;
  NeuralNetwork(int num_of_layers, int size_of_layer, float lr, float mr){
    this.num_of_layers = num_of_layers;
    this.size_of_layer = size_of_layer;
    this.layers = new Matrix[num_of_layers];
    for(int i = 0; i < this.layers.length;i++){
      this.layers[i] = new Matrix(1,size_of_layer);
    }
    this.weights = new Matrix[num_of_layers];
    for(int i = 0; i < this.weights.length;i++){
      this.weights[i] = new Matrix(size_of_layer,size_of_layer);
      this.weights[i].randomize();
    }

    this.biases = new float[num_of_layers];
    for(int i = 0; i < this.biases.length;i++){
      this.biases[i] = 0;
    }
    this.lr = lr;
    this.mr = mr;
  }
  NeuralNetwork(NeuralNetwork nn){
    this.num_of_layers = nn.num_of_layers;
    this.size_of_layer = nn.size_of_layer;
    this.layers = new Matrix[num_of_layers];
    for(int i = 0; i < layers.length;i++){
      layers[i] = new Matrix(nn.layers[i]);
    }
    this.weights = new Matrix[num_of_layers];
    for(int i = 0; i < weights.length;i++){
      weights[i] = new Matrix(nn.weights[i]);
    }

    this.biases = new float[num_of_layers];
    for(int i = 0; i < this.num_of_layers;i++){
      this.biases[i] = nn.biases[i];
    }
    this.lr = nn.lr;
    this.mr = nn.mr;
  }
  float[] feedForward(float[] inputs){
    this.layers[0] = new Matrix(inputs);
    for(int i = 0; i < this.num_of_layers - 1;i++){
      this.layers[i+1] = this.weights[i].multiplyMatrix(this.layers[i]);
      this.layers[i+1].addConstant(biases[i]);
      this.layers[i+1].activate();
    }
    return(this.layers[this.layers.length-1].asArray());
  }

  void mutate(){
    for(int i = 0; i < this.weights.length;i++){
      weights[i].mutate(this.mr);
    }
    for(int i = 0; i < this.biases.length;i++){
      if(random(1) < this.mr){
        this.biases[i] += random(-0.1,0.1);
      }
    }
  }
  void saveNN(String filename){
    JSONObject nn = new JSONObject();
    nn.setInt("num_of_layers",this.num_of_layers);
    nn.setInt("size_of_layer",this.size_of_layer);
    
    JSONArray layers = new JSONArray();
    for(int i = 0; i < this.layers.length;i++){
      layers.setJSONArray(i,this.layers[i].toJSONArray());
    }
    nn.setJSONArray("layers",layers);
    
    JSONArray weights = new JSONArray();
    for(int i = 0; i < this.weights.length;i++){
      weights.setJSONArray(i,this.weights[i].toJSONArray());
    }
    nn.setJSONArray("weights",weights);
    
    JSONArray biases = new JSONArray();
    for(int i = 0; i < this.biases.length;i++){
      biases.setFloat(i,this.biases[i]);
    }
    nn.setJSONArray("biases",biases);
    nn.setFloat("lr",lr);
    nn.setFloat("mr",mr);
    saveJSONObject(nn,"models/"+filename+".json");
  }
  void loadNN(String filename){
    JSONObject nn = loadJSONObject("models/"+filename+".json");
    this.num_of_layers = nn.getInt("num_of_layers");
    this.size_of_layer = nn.getInt("size_of_layer");
    JSONArray layers = nn.getJSONArray("layers");
    this.layers = new Matrix[this.num_of_layers];
    for(int i = 0; i < this.layers.length;i++){
      this.layers[i] = new Matrix(layers.getJSONArray(i));
    }
    
    JSONArray weights = nn.getJSONArray("weights");
    this.weights = new Matrix[this.num_of_layers];
    for(int i = 0; i < this.weights.length;i++){
      this.weights[i] = new Matrix(layers.getJSONArray(i));
    }
    
    JSONArray biases = nn.getJSONArray("biases");
    this.biases = new float[num_of_layers];
    for(int i = 0; i < this.biases.length;i++){
      this.biases[i] = biases.getFloat(i);
    }
    this.lr = nn.getFloat("lr");
    this.mr = nn.getFloat("mr");
  }
}
