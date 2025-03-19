#!/bin/bash
#SBATCH --job-name=array_pvactools_mismatches
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=72:00:00
#SBATCH --array=0-3
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname $(pwd))

# script to run VCFs which had mismatches in previous run, who have now had problematic variants removed. 
VCFs=(${BASE_DIR}/results/ref_mismatch_reporter/*)
srun bash ${BASE_DIR}/bin/pvactools.sh ${VCFs[$SLURM_ARRAY_TASK_ID]}