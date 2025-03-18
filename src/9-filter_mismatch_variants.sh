#!/bin/bash
#SBATCH --job-name=filter_mismatch_variants
#SBATCH --partition=smp
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16000
#SBATCH --time=12:00:00
#SBATCH --array=0-3
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname $(pwd))

# script to run VCF through vcf_expression_annotator.sh script to prepare for input to pvactools. The VCFs here had a previous fatal error to do with a mismatch between the references so I am filtering those out here. 
VCFs=("$BASE_DIR/results/vcf_expression_annotator/PLUMMB_26/PLUMMB_26.sobdetector.hcfiltered.adrlar.mutect2.filtered.snvsonly_VEP.ann.gx.vcf" "${BASE_DIR}/results/vcf_expression_annotator/R11_BL/R11_BL.sobdetector.hcfiltered.adrlar.mutect2.filtered.snvsonly_VEP.ann.gx.vcf" "${BASE_DIR}/results/vcf_expression_annotator/PLUMMB_16/PLUMMB_16.sobdetector.hcfiltered.adrlar.mutect2.filtered.snvsonly_VEP.ann.gx.vcf" "${BASE_DIR}/results/vep_annotate/PLUMMB_21/PLUMMB_21.sobdetector.hcfiltered.adrlar.mutect2.filtered.snvsonly_VEP.ann.vcf")

srun bash ${BASE_DIR}/bin/ref_transcript_mismatch_reporter.sh ${VCFs[$SLURM_ARRAY_TASK_ID]}