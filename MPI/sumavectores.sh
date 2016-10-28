#!/bin/bash

#SBATCH --job-name=sumavectores
#SBATCH --output=res_mpi_sumavectores.out
#SBATCH --nodes=6
#SBATCH --ntasks=8
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100

mpirun sumavectores
