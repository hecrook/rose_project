#!/bin/bash
#SBATCH --job-name=rose-variant_filtering_summary
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=24:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

# Script to run all samples through bin/variant_filtering_summary.sh. The input are the directory of the final filtered VCFs.
BASE_DIR=$(dirname `pwd`)
sob_vcfs=($BASE_DIR/results/sobdetector/*snvsonly*)

srun bash ${BASE_DIR}/bin/variant_filtering_summary.sh ${sob_vcfs[$SLURM_ARRAY_TASK_ID]}