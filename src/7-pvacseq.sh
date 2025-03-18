#!/bin/bash
#SBATCH --job-name=rose-pvacseq
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=24:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

# Script to run all samples through pvacseq. The input are the vep annotated, fully filtered VCF files. The script pulls these from the directory
BASE_DIR=$(dirname `pwd`)
tumour_dirs=($BASE_DIR/results/vcf_expression_annotator/*)

srun bash ${BASE_DIR}/bin/pvactools.sh ${tumour_dirs[$SLURM_ARRAY_TASK_ID]} 