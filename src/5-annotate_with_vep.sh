#!/bin/bash
#SBATCH --job-name=array_vep_annotate
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=12:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname $(pwd))

# script to run all the VCFs in rose project through vep_annotate.sh script to prepare for input to pvactools

# load VCFs
vcfs=($BASE_DIR/results/sobdetector/*snvsonly*)

srun bash ${BASE_DIR}/bin/vep_annotate.sh ${vcfs[$SLURM_ARRAY_TASK_ID]}