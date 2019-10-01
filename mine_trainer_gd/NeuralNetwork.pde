class NeuralNetwork{
  int numOfLayers;
  int inputSize;
  int outputSize;
  int layerSize;
  
  float lr; //learning rate

  Matrix[] layers;
  Matrix[] weights;
  Matrix[] gradients;
  Matrix[] losses;
  float[] biases;
  NeuralNetwork(int numOfLayers, int inputSize, int outputSize, int layerSize, float lr){
    this.numOfLayers = numOfLayers;
    this.inputSize = inputSize;
    this.outputSize = outputSize;
    this.layerSize = layerSize;
    this.layers = new Matrix[numOfLayers];
    this.layers[0] = new Matrix(1,inputSize);
    this.layers[this.layers.length-1] = new Matrix(1,outputSize);
    for(int i = 1; i < this.layers.length-1;i++){
      this.layers[i] = new Matrix(1,layerSize);
    }
    this.weights = new Matrix[numOfLayers-1];
    this.weights[0] = new Matrix(layerSize,inputSize);
    this.weights[this.weights.length-1] = new Matrix(outputSize,layerSize);
    for(int i = 1; i < this.weights.length-1;i++){
      this.weights[i] = new Matrix(layerSize,layerSize);
      this.weights[i].randomize();
    }
    this.gradients = new Matrix[numOfLayers-1];
    this.gradients[0] = new Matrix(layerSize,inputSize);
    this.gradients[this.gradients.length-1] = new Matrix(outputSize,layerSize);
    for(int i = 1; i < this.gradients.length-1;i++){
      this.gradients[i] = new Matrix(layerSize,layerSize);
      this.gradients[i].randomize();
    }
    this.losses = new Matrix[numOfLayers];
    this.losses[0] = new Matrix(1,inputSize);
    this.losses[this.losses.length-1] = new Matrix(1,outputSize);
    for(int i = 1; i < this.losses.length-1;i++){
      this.losses[i] = new Matrix(1,layerSize);
    }
    this.biases = new float[numOfLayers];
    for(int i = 0; i < this.biases.length;i++){
      this.biases[i] = 0;
    }
    this.lr = lr;
  }
  NeuralNetwork(NeuralNetwork nn){
    this.numOfLayers = nn.numOfLayers;
    this.layerSize = nn.layerSize;
    this.layers = new Matrix[numOfLayers];
    for(int i = 0; i < layers.length;i++){
      layers[i] = new Matrix(nn.layers[i]);
    }
    this.weights = new Matrix[numOfLayers];
    for(int i = 0; i < weights.length;i++){
      weights[i] = new Matrix(nn.weights[i]);
    }

    this.biases = new float[numOfLayers];
    for(int i = 0; i < this.numOfLayers;i++){
      this.biases[i] = nn.biases[i];
    }
    
    this.lr = nn.lr;
  }
  float[] feedForward(float[] inputs){
    this.layers[0] = new Matrix(inputs);
    for(int i = 0; i < this.numOfLayers - 1;i++){
      this.layers[i+1] = this.weights[i].multiplyMatrix(this.layers[i]).addConstant(biases[i]).activate();
    }
    return(this.layers[this.layers.length-1].asArray());
  }
  void backpropagate(float[] targets){
    this.losses[this.losses.length-1] = (new Matrix(targets)).subtractMatrix(this.layers[this.numOfLayers-1]);
    for(int i = this.gradients.length-1; i >= 0; i--){
      this.gradients[i] = this.losses[i+1].multiplyConstant(this.lr).multiplyElements(this.layers[i+1].dactivate()).multiplyMatrix(this.layers[i].transpose());
      this.losses[i] = this.weights[i].transpose().multiplyMatrix(this.losses[i+1]);
    }
    for(int i = 0; i < this.gradients.length-1;i++){
      this.gradients[i] = this.gradients[i].clipValues(-5,5);
      this.weights[i] = this.weights[i].addMatrix(this.gradients[i]);
    }
  }
  void saveNN(String filename){
    JSONObject nn = new JSONObject();
    nn.setInt("numOfLayers",this.numOfLayers);
    nn.setInt("layerSize",this.layerSize);
    
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
    saveJSONObject(nn,"models/"+filename+".json");
  }
  void loadNN(String filename){
    JSONObject nn = loadJSONObject("models/"+filename+".json");
    this.numOfLayers = nn.getInt("numOfLayers");
    this.layerSize = nn.getInt("layerSize");
    JSONArray layers = nn.getJSONArray("layers");
    this.layers = new Matrix[this.numOfLayers];
    for(int i = 0; i < this.layers.length;i++){
      this.layers[i] = new Matrix(layers.getJSONArray(i));
    }
    
    JSONArray weights = nn.getJSONArray("weights");
    this.weights = new Matrix[this.numOfLayers];
    for(int i = 0; i < this.weights.length;i++){
      this.weights[i] = new Matrix(layers.getJSONArray(i));
    }
    
    JSONArray biases = nn.getJSONArray("biases");
    this.biases = new float[numOfLayers];
    for(int i = 0; i < this.biases.length;i++){
      this.biases[i] = biases.getFloat(i);
    }
    this.lr = nn.getFloat("lr");
  }
}
