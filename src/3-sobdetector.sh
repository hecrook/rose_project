#!/bin/bash
#SBATCH --job-name=array_sobdetector
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=12:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

# Array job: running all cram files for rose_project through cram_to_bam.sh script to convert to bam files
# bam files are needed as input for SOBDetector 

BASE_DIR=$(dirname `pwd`)
vcfs=($BASE_DIR/results/filter_vcf/*)

echo "running script on the following files: " ${vcfs[@]}

srun bash sobdetector.sh ${vcfs[$SLURM_ARRAY_TASK_ID]}
