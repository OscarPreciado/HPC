#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 1000000       // Tamaño de los vectores
#define MASTER 0      // id del primer task
#define FROM_MASTER 1 // enviando tipo de mensaje
#define FROM_WORKER 2 // enviando tipo de mensaje

//Definiciones
//Rank: Identificador de los procesos
//size: Tamaño de la lista de procesos
//MPI_COMM_WORLD: Tiene todos los procesos que se estan usando para el task

int main() {
  int taskid, numtask, numworkers, source, mtype, rc;
  int i, aversize, elements, extra, offset, dest;
  double *a; // vector A 
  double *b; // vector B 
  double *c; // vector C Resultante
  MPI_Status mpi_status;

  MPI_Init(NULL, NULL);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid); 
  MPI_Comm_size(MPI_COMM_WORLD, &numtask);

  if (numtask < 2) {
    printf("Need at least two MPI tasks. Quitting...\n");
    MPI_Abort(MPI_COMM_WORLD, rc);
    exit(1);
  }

  numworkers = numtask - 1;
a = (double*)malloc(SIZE*sizeof(double));
b = (double*)malloc(SIZE*sizeof(double));
c = (double*)malloc(SIZE*sizeof(double));

  //------------------------ master task --------------------------------------
  if (taskid == MASTER) {
    printf("mpi_sumavectores has started with %d tasks.\n", numtask);
    printf("Vectores iniciales:\n");
    for (i = 0; i < SIZE; i++) {
      a[i] = rand() % SIZE;
      b[i] = rand() % SIZE;
      printf("a[%d] = %6.2f   b[%d] = %6.2f\n", i, a[i], i, b[i]);
    }

    // Datos a workers
    aversize = SIZE / numworkers;
    extra = SIZE % numworkers;
    offset = 0;
    mtype = FROM_MASTER;

    for (dest = 1; dest <= numworkers; dest++) {
      elements = (dest <= extra) ? aversize + 1 : aversize;
    //  printf("Sending %d elements to task %d offset = %d\n", elements, dest,
             //offset);

      MPI_Send(&offset, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
      MPI_Send(&elements, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
      MPI_Send(&a[offset], elements, MPI_DOUBLE, dest, mtype, MPI_COMM_WORLD);
      MPI_Send(&b[offset], elements, MPI_DOUBLE, dest, mtype, MPI_COMM_WORLD);
      offset += elements;
    }

    // Receive results from worker tasks
    mtype = FROM_WORKER;
    for (i = 1; i <= numworkers; i++) {
      source = i;
      MPI_Recv(&offset, 1, MPI_INT, source, mtype, MPI_COMM_WORLD, &mpi_status);
      MPI_Recv(&elements, 1, MPI_INT, source, mtype, MPI_COMM_WORLD,
               &mpi_status);
      MPI_Recv(&c[offset], elements, MPI_DOUBLE, source, mtype, MPI_COMM_WORLD,
               &mpi_status);
      //printf("Received results from task %d\n", source);
    }

    //printf SUMA
    // printf("******************************************************\n");
    printf("Vector total:\n");
     for (i = 0; i < SIZE; i++) {
       printf("c[%d] = %6.2f \n",i, c[i]);
    }
    // printf("\n******************************************************\n");
   // printf("Done.\n");
  }

  //------------------------ worker task --------------------------------------
  if (taskid > MASTER) {
    mtype = FROM_MASTER;
    MPI_Recv(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &mpi_status);
    MPI_Recv(&elements, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &mpi_status);
    MPI_Recv(a, elements, MPI_DOUBLE, MASTER, mtype, MPI_COMM_WORLD,
             &mpi_status);
    MPI_Recv(b, elements, MPI_DOUBLE, MASTER, mtype, MPI_COMM_WORLD,
             &mpi_status);

    for (i = 0; i < elements; i++) {
      c[i] = a[i] + b[i];
    }

    mtype = FROM_WORKER;
    MPI_Send(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
    MPI_Send(&elements, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
    MPI_Send(c, elements, MPI_DOUBLE, MASTER, mtype, MPI_COMM_WORLD);
  }

  MPI_Finalize();
 free(a);
 free(b);
 free(c);
}
