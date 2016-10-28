#!/bin/bash

#SBATCH --job-name=sumavectores
#SBATCH --output=res_mpi_sumavectores.out
#SBATCH --ntasks=48
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100

mpirun sumavectores
