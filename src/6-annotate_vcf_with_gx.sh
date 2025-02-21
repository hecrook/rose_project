#!/bin/bash
#SBATCH --job-name=array_annotate_vcf_with_gx
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=12:00:00
#SBATCH --array=0-32
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname $(pwd))

# script to run all the VCFs in rose project through vcf_expression_annotator.sh script to prepare for input to pvactools
tumour_dirs=($BASE_DIR/results/vep_annotate/*)
srun bash ${BASE_DIR}/bin/vcf_expression_annotator.sh ${tumour_dirs[$SLURM_ARRAY_TASK_ID]}