#!/bin/bash
#SBATCH --job-name=array_soprano
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=12:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

# Specify samples to be run through script
BASE_DIR=$(dirname `pwd`)
vcfs=($BASE_DIR/results/sobdetector/*snvsonly*)

srun bash ${BASE_DIR}/bin/soprano.sh ${vcfs[$SLURM_ARRAY_TASK_ID]}
