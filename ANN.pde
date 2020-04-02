class ANN{
  private float[] input;
  private ArrayList<float[]> output;
  private ArrayList<float[]> error;
  private ArrayList<float[][]> weight;
  private ArrayList<float[]> bias;
  private int[] shape;
  private float learningRate;

  public ANN(int[] shape){
    this.shape = shape;
    this.learningRate = .1f;
    this.input = new float[shape[0]];
    this.bias = new ArrayList<float[]>();
    this.weight = new ArrayList<float[][]>();
    this.output = new ArrayList<float[]>();
    this.error = new ArrayList<float[]>();
    for(int i=0; i<this.input.length; i++)
      this.input[i] = 0;
    for(int i=1; i<shape.length; i++){
      this.weight.add(new float[shape[i]][shape[i-1]]);
      this.output.add(new float[shape[i]]);
      this.error.add(new float[shape[i]]);
      this.bias.add(new float[shape[i]]);
    }
    for(int i=0; i<this.weight.size(); i++)
      for(int j=0; j<this.weight.get(i).length; j++)
        for(int k=0; k<this.weight.get(i)[j].length; k++)
          this.weight.get(i)[j][k] = random(-1, 1);
    for(int i=0; i<this.output.size(); i++){
      for(int j=0; j<this.output.get(i).length; j++){
        this.output.get(i)[j] = 0;
        this.error.get(i)[j] = 0;
        this.bias.get(i)[j] = random(-1, 1);
      }
    }
  }
  

  public ANN(int[] shape, ArrayList<float[][]> weight, ArrayList<float[]> bias){
    this.weight = weight;
    this.bias = bias;
    this.learningRate = .1f;
    this.input = new float[shape[0]];
    this.output = new ArrayList<float[]>();
    this.error = new ArrayList<float[]>();
    for(int i=0; i<this.input.length; i++)
      this.input[i] = 0;
    for(int i=1; i<shape.length; i++){
      this.output.add(new float[shape[i]]);
      this.error.add(new float[shape[i]]);
    }
    for(int i=0; i<this.output.size(); i++){
      for(int j=0; j<this.output.get(i).length; j++){
        this.output.get(i)[j] = 0;
        this.error.get(i)[j] = 0;
      }
    }
  }


  public ANN feedForward(float[] inputs){
    this.input = inputs;
    float sum = 0;
    for(int i=0; i<this.weight.size(); i++){
      for(int j=0; j<this.weight.get(i).length; j++){
        sum = this.bias.get(i)[j];
        for(int k=0; k<this.weight.get(i)[j].length; k++){
          if(i == 0){
            sum += this.input[k] * this.weight.get(i)[j][k];
          }else{
            sum += this.output.get(i-1)[k] * this.weight.get(i)[j][k];
          }
        }
        if(i == this.weight.size()-1)
          this.output.get(i)[j] = this.activate(j, sum);
        else
          this.output.get(i)[j] = this.sigmoid(sum);
      }
    }
    return this;//this.output.get(this.output.size()-1);
  }

  
  public void propagateAndDescent(float[] input, float[] target){
    for(int i=this.weight.size()-1; i>=0; i--)
      for(int j=0; j<this.weight.get(i).length; j++){
        for(int k=0; k<this.weight.get(i)[j].length; k++){
          this.weight.get(i)[j][k] -= this.learningRate * this.derivateW(i, j, k, input, target, this.weight.size(), 0);
        }
        this.bias.get(i)[j] -= this.learningRate * this.derivateB(i, j, input, target, this.weight.size(), 0);
      }
  }
  
  private float derivateW(int i, int j, int k, float[] input, float[] target, int xdepth, int ydepth){ //<>//
    float dweight = 0; //<>//
    if(xdepth == this.weight.size()){
      if(i == this.weight.size()-1){
        dweight = -(target[j] - this.output.get(i)[j]) * this.output.get(i)[j] * (1 - this.output.get(i)[j]) * (i==0?input[k]:this.output.get(i-1)[k]);
        return dweight;
      }
      for(int m=0; m<this.shape[this.shape.length-1]; m++)
        dweight += -(target[m] - this.output.get(this.output.size()-1)[m]) * this.derivateW(i, j, k, input, target, xdepth-1, m);
        return dweight;
    } else if(xdepth == i){
      dweight += i == 0 ? input[k] : this.output.get(i-1)[k];
      dweight *= this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    } else if(xdepth == i+1){
      dweight += this.weight.get(xdepth)[ydepth][j] * this.derivateW(i, j, k, input, target, xdepth-1, j);
      dweight *= this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    } else {
      for(int m=0; m<this.shape[xdepth]; m++)
        dweight += this.weight.get(xdepth)[ydepth][m] * this.derivateW(i, j, k, input, target, xdepth-1, m);
      dweight *= this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    }
  }
  
  private float derivateB(int i, int j, float[] input, float[] target, int xdepth, int ydepth){
    float dweight = 0;
    if(xdepth == this.weight.size()){
      if(i == this.weight.size()-1){
        dweight = -(target[j] - this.output.get(i)[j]) * this.output.get(i)[j] * (1 - this.output.get(i)[j]);
        return dweight;
      }
      for(int m=0; m<this.shape[this.shape.length-1]; m++)
        dweight += -(target[m] - this.output.get(this.output.size()-1)[m]) * this.derivateB(i, j, input, target, xdepth-1, m);
        return dweight;
    } else if(xdepth == i){
      dweight = this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    } else if(xdepth == i+1){
      dweight += this.weight.get(xdepth)[ydepth][j] * this.derivateB(i, j, input, target, xdepth-1, j);
      dweight *= this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    } else {
      for(int m=0; m<this.shape[xdepth]; m++)
        dweight += this.weight.get(xdepth)[ydepth][m] * this.derivateB(i, j, input, target, xdepth-1, m);
      dweight *= this.output.get(xdepth)[ydepth] * (1 - this.output.get(xdepth)[ydepth]);
      return dweight;
    }
  } 
  

  public void backPropagate(float[] target){
    for(int i=0; i<this.error.get(this.error.size()-1).length; i++)
      this.error.get(this.error.size()-1)[i] = sq(target[i] - this.output.get(this.output.size()-1)[i])/2;
    for(int i=this.error.size()-2; i>=0; i--){
      for(int j=0; j<this.error.get(i).length; j++){
        float wSum = 0;
        for(int k=0; k<this.error.get(i+1).length; k++)
          wSum += abs(this.weight.get(i+1)[k][j]);
        float errsum = 0;
        for(int k=0; k<this.error.get(i+1).length; k++)
          errsum += this.error.get(i+1)[k] * (this.weight.get(i+1)[k][j]/wSum);
        this.error.get(i)[j] = errsum;
      }
    }
  }
  
  
  float sigmoid(float x){
    return 1 /(1 + exp(-x));
  }


  float activate(int n, float x){ // x is the sum of moderated inputs and bias
   float y = 0;
    switch(n){
      case 0: // Additional rotation
        y = sigmoid(x)*2*PI-PI;
      break;
      case 1: // Distance to travel
        y = sigmoid(x)*(width/10);
      break;
      case 2: // Rotation agility
        y = map(sigmoid(x), 0, 1, Settings.minAgility, Settings.maxAgility);
      break;
      case 3: // Traveling speed
        y = map(sigmoid(x), 0, 1, Settings.minSpeed, Settings.maxSpeed);
      //default:
      //  y = sigmoid(x);
    }
    return y;
  }


  public float getRot(){
    float sum = 0;
    int amount = 0;
    for(int i=0; i<this.weight.size(); i++){
      for(int j=0; j<this.weight.get(i).length; j++){
        for(int k=0; k<this.weight.get(i)[j].length; k++){
          sum += abs(this.weight.get(i)[j][k]);
          amount++;
        }
      }
    }
    return sum / amount;
  }

  // Encapsulation
  public ArrayList<float[][]> getWeight(){return this.weight;}
  public ArrayList<float[]> getBias(){return this.bias;}
  public int[] getShape(){return this.shape;}
  public ArrayList<float[]> getError(){return this.error;}
  public float[] getInput(){return this.input;}
  public float[] getOutput(){return this.output.get(this.output.size()-1);}
  public int getAction(){
    int max = 0;
    for(int i=0; i<this.output.get(this.output.size()-1).length; i++)
      if(this.output.get(this.output.size()-1)[i] > this.output.get(this.output.size()-1)[max])max = i;
    return max;
  }

  public void setWeight(ArrayList<float[][]> weight){this.weight = weight;}
  public void setBias(ArrayList<float[]> bias){this.bias = bias;}
}
