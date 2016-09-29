#include <stdio.h>
#include <iostream>
#include <assert.h>
#include <cuda.h>
#include <time.h>

#define TILE_WIDTH 32


using namespace std;
// Multiplicacion con shared mem
__global__ void matrixMulKernelTiled(float *d_M, float *d_N, float *d_P, int width1, int height1, int width2) {
  __shared__ float ds_M[TILE_WIDTH][TILE_WIDTH];
  __shared__ float ds_N[TILE_WIDTH][TILE_WIDTH];

  int bx = blockIdx.x;
  int by = blockIdx.y;
  int tx = threadIdx.x;
  int ty = threadIdx.y;

  int row = by * TILE_WIDTH + ty;
  int col = bx * TILE_WIDTH + tx;

  float Pvalue = 0;

  for (int p = 0; p < width1 / TILE_WIDTH; p++) {
	 //Nos ubicamos en el elemento de la matriz 1 que deseamos multiplicar
    if (row < height1 and (p * TILE_WIDTH + tx) < width1) {
      ds_M[ty][tx] = d_M[row * width1 + p * TILE_WIDTH + tx];
    } else {
    //si esta fuera del rango llenamos con cero
      ds_M[ty][tx] = 0.0;
    }
         //Nos ubicamos en el elemento de la matriz 2 que deseamos multiplicar
    if ((p * TILE_WIDTH + ty) < width1 and col < width1) {
      ds_N[ty][tx] = d_N[(p * TILE_WIDTH + ty) * width2 + col];
    } else {
	//si esta fuera del rango llenamos con cero
      ds_N[ty][tx] = 0.0;
    }
    __syncthreads();
       //Se hace la multiplicacion utilizando shared mem
    if (row < height1 and col < width2)
      for (int k = 0; k < TILE_WIDTH; k++) {
        Pvalue += ds_M[ty][k] * ds_N[k][tx];
      }
    __syncthreads();
  }
  //Se guardan los resultados.
  if (row < height1 and col < width2)
    d_P[row * width2 + col] = Pvalue;
}

//Multiplicacón en GPU: 
void MatrixMulCPU(float *M, float *N, float *P, int width1, int height1, int width2) {
  //Aqui se guarda el resultado de la multiplicacion
  int sum = 0;
  for (int i = 0; i < height1; i++) {
    for (int j = 0; j < width2; j++) {
      sum = 0;
      for (int k = 0; k < width1; k++)
        //Se hace el productto y se guarda en la variable
        sum += M[i * width1 + k] * N[k * width2 + j];
      //Se colocan los valores en la matriz resultado  
      P[i * width2 + j] = sum; 
    }
  }
}


//Inicializa las matrices a multiplicar. 
int initValues(float *data, int width, int heigth){
    for(int i = 0; i < width*heigth; i++)
        data[i] = 1.0; 
    return 0;
}


int main()
{
  
    clock_t start, end;
    float *h_M, *h_N, *h_P,*h_P_d; //Matrices del host
    float *d_M, *d_N,*d_P; // Matrices del device

    //Aqui introducimos los tamaños de las matrices 1 y 2 (heigth y width)
  
    int heigth1 = 10;
    int width1 = 10; 
    int heigth2 = 10;
    int width2 = 15; 
  
    cudaError_t error = cudaSuccess; 
    
    int size1 = width1 * heigth1 * sizeof(float); //Dimension de la matriz 1
    int size2 = width2 * heigth2 * sizeof(float); //Dimension de la matriz 2
    int size3 = width2 * heigth1 * sizeof(float); //Dimension de la matriz resultado

	//Reservamos memoria para las matrices del host
    h_M = (float*)malloc(size1);
    h_N = (float*)malloc(size2);
    h_P = (float*)malloc(size3);
    h_P_d = (float*)malloc(size3);

    if(h_P_d == NULL)
        return 0;
	//Inicializamos las matrices 
    initValues(h_M, width1, heigth1);
    initValues(h_N, width2, heigth2);
  
	//Procedimiento en GPU:
  
   //Reservamos espacio en el device para una matriz  de dimensión size1
   error = cudaMalloc((void**)&d_M,size1);
    if(error != cudaSuccess){
        printf("Error reservando memoria para d_M");
        exit(0);
    }
	//Reservamos espacio en el device para una matriz  de dimensión size2
    error = cudaMalloc((void**)&d_N,size2);
    if(error != cudaSuccess){
        printf("Error reservando memoria para d_N");
        exit(0);
    }
	//Reservamos espacio en el device para la matriz resultante de size3
    error = cudaMalloc((void**)&d_P,size3);
    if(error != cudaSuccess){
        printf("Error reservando memoria para d_P");
        exit(0);
    }
	
	//Copiamos los datos de las matrices del host al device con las mismas dimensiones.
	error = cudaMemcpy(d_M, h_M, size1, cudaMemcpyHostToDevice);
	if(error != cudaSuccess){
        printf("Error copiando datos a d_M");
        exit(0);
    }
    
    error = cudaMemcpy(d_N, h_N, size2, cudaMemcpyHostToDevice);
    if(error != cudaSuccess){
        printf("Error copiando datos a d_N");
        exit(0);
    }
    
    int blockSize = 1;
    dim3 dimBlock(blockSize,blockSize,1); 
    dim3 dimGrid(ceil(width2 / float(blockSize)), ceil(heigth1 / float(blockSize)), 1); 
  
  
    // CICLO DE TIEMPOS
    for(int x=1; x<=5;x++)
    {
    printf ("Ciclo numero %d\n",x);  

    //multiplicación con CPU
    start = clock();
    MatrixMulCPU(h_M, h_N, h_P, width1, heigth1, width2); //Invocamos la multiplicacion secuencial en CPU.
    end = clock();
    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("Tiempo en CPU: %.10f\n", cpu_time_used);
    //Fin
    
    //Multiplicacion con GPU
    start = clock();
  	matrixMulKernelTiled<<<dimGrid, dimBlock>>>(d_M, d_N, d_P, width1, heigth1, width2);// Invocamos la multiplicacion con Tiles.
    cudaMemcpy(h_P_d,d_P,size3,cudaMemcpyDeviceToHost); //Copiamos el resultado de la matriz  del device al host.
    end = clock();
    double gpu_time_used = double(end - start) / CLOCKS_PER_SEC;
    printf("Tiempo en GPU: %.10f\n",gpu_time_used);
    //FIN
    }

  	  	
    cudaFree(d_M);
    cudaFree(d_N);
    cudaFree(d_P);
    

    return 0;
}
