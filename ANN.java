import java.util.*;

class ANN{
	private Random random;
	private double[] input;
	private ArrayList<double[]> output;
	private ArrayList<double[]> error;
	private ArrayList<double[][]> weight;
	private ArrayList<double[]> bias;
	private int[] shape;
	private double learningRate;

	public ANN(int[] shape){
		this.random = new Random();
		this.shape = shape;
		this.learningRate = .1;
		this.input = new double[shape[0]];
		this.bias = new ArrayList<double[]>();
		this.weight = new ArrayList<double[][]>();
		this.output = new ArrayList<double[]>();
		this.error = new ArrayList<double[]>();
		for(int i=0; i<this.input.length; i++)
			this.input[i] = 0;
		for(int i=1; i<shape.length; i++){
			this.weight.add(new double[shape[i]][shape[i-1]]);
			this.output.add(new double[shape[i]]);
			this.error.add(new double[shape[i]]);
			this.bias.add(new double[shape[i]]);
		}
		for(int i=0; i<this.weight.size(); i++)
			for(int j=0; j<this.weight.get(i).length; j++)
				for(int k=0; k<this.weight.get(i)[j].length; k++)
					this.weight.get(i)[j][k] = random.nextDouble() * 2 - 1;
		for(int i=0; i<this.output.size(); i++){
			for(int j=0; j<this.output.get(i).length; j++){
				this.output.get(i)[j] = 0;
				this.error.get(i)[j] = 0;
				this.bias.get(i)[j] = random.nextDouble() * 2 - 1;
			}
		}
	}


	public ANN(int[] shape, ArrayList<double[][]> weight, ArrayList<double[]> bias){
		this.weight = weight;
		this.bias = bias;
		this.learningRate = .1f;
		this.input = new double[shape[0]];
		this.output = new ArrayList<double[]>();
		this.error = new ArrayList<double[]>();
		for(int i=0; i<this.input.length; i++)
			this.input[i] = 0;
		for(int i=1; i<shape.length; i++){
			this.output.add(new double[shape[i]]);
			this.error.add(new double[shape[i]]);
		}
		for(int i=0; i<this.output.size(); i++){
			for(int j=0; j<this.output.get(i).length; j++){
				this.output.get(i)[j] = 0;
				this.error.get(i)[j] = 0;
			}
		}
	}


	public ANN feedForward(double[] inputs){
		this.input = inputs;
		double sum = 0;
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


	public void propagateAndDescent(double[] input, double[] target){
		for(int i=this.weight.size()-1; i>=0; i--)
			for(int j=0; j<this.weight.get(i).length; j++){
				for(int k=0; k<this.weight.get(i)[j].length; k++){
					this.weight.get(i)[j][k] -= this.learningRate * this.derivateW(i, j, k, input, target, this.weight.size(), 0);
				}
				this.bias.get(i)[j] -= this.learningRate * this.derivateB(i, j, input, target, this.weight.size(), 0);
			}
	}

	private double derivateW(int i, int j, int k, double[] input, double[] target, int xdepth, int ydepth){ //<>//
		double dweight = 0; //<>//
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

	private double derivateB(int i, int j, double[] input, double[] target, int xdepth, int ydepth){
		double dweight = 0;
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


	public void backPropagate(double[] target){
		for(int i=0; i<this.error.get(this.error.size()-1).length; i++)
			this.error.get(this.error.size()-1)[i] = Math.sqrt(target[i] - this.output.get(this.output.size()-1)[i])/2;
		for(int i=this.error.size()-2; i>=0; i--){
			for(int j=0; j<this.error.get(i).length; j++){
				double wSum = 0;
				for(int k=0; k<this.error.get(i+1).length; k++)
					wSum += Math.abs(this.weight.get(i+1)[k][j]);
				double errsum = 0;
				for(int k=0; k<this.error.get(i+1).length; k++)
					errsum += this.error.get(i+1)[k] * (this.weight.get(i+1)[k][j]/wSum);
				this.error.get(i)[j] = errsum;
			}
		}
	}


	double sigmoid(double x){
		return 1 /(1 + Math.exp(-x));
	}


	double activate(int n, double x){ // x is the sum of moderated inputs and bias
		double y = 0;
		switch(n){
			default: y = sigmoid(x);
		}
		return y;
	}


	public double getRot(){
		double sum = 0;
		int amount = 0;
		for(int i=0; i<this.weight.size(); i++){
			for(int j=0; j<this.weight.get(i).length; j++){
				for(int k=0; k<this.weight.get(i)[j].length; k++){
					sum += Math.abs(this.weight.get(i)[j][k]);
					amount++;
				}
			}
		}
		return sum / amount;
	}

	// Encapsulation
	public ArrayList<double[][]> getWeight(){return this.weight;}
	public ArrayList<double[]> getBias(){return this.bias;}
	public int[] getShape(){return this.shape;}
	public ArrayList<double[]> getError(){return this.error;}
	public double[] getInput(){return this.input;}
	public double[] getOutput(){return this.output.get(this.output.size()-1);}
	public int getAction(){
		int max = 0;
		for(int i=0; i<this.output.get(this.output.size()-1).length; i++)
			if(this.output.get(this.output.size()-1)[i] > this.output.get(this.output.size()-1)[max])max = i;
		return max;
	}

	public void setWeight(ArrayList<double[][]> weight){this.weight = weight;}
	public void setBias(ArrayList<double[]> bias){this.bias = bias;}
}
