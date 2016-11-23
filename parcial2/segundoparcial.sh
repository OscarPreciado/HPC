#!/bin/bash
#
#SBATCH --job-name=segundoparcial
#SBATCH --output=segundoparcial.out
#SBATCH --nodes=2
#SBATCH --tasks=2
#SBATCH --gres=gpu:1

echo $CUDA_VISIBLE_DEVICES
mpirun segundoparcial
