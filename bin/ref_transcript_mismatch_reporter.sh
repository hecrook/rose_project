#!/bin/bash
#SBATCH --job-name=ROSE-7-ref_mismatch_reporter
#SBATCH --partition=compute
#SBATCH --ntasks=2
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=2000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)
source ~/.bashrc

# Script to remove any variants from the VCFs whose reference allele does not match the reference transcript. This error occurs when different versions of the reference are used, and the error it produces is fatal in pvacseq.
# The input VCFs should be annotated with the wildtype plugin in VEP.

# set variables
pvac_sif="${BASE_DIR}/tools/sifs/pVACtools_4.1.1.sif"
input_vcf=$1
output_vcf=$(basename $input_vcf .vcf).ref_mismatch.vcf
output_dir=$(basename $input_vcf | grep -oP '^[^.]+')

# make output directory
if [ -d "${BASE_DIR}/results/ref_mismatch_reporter/$output_dir" ]; then
    rm -r ${BASE_DIR}/results/ref_mismatch_reporter/$output_dir
    mkdir -p ${BASE_DIR}/results/ref_mismatch_reporter/$output_dir
else
    mkdir -p ${BASE_DIR}/results/ref_mismatch_reporter/$output_dir
fi

# Run command
singularity exec --bind $BASE_DIR::$BASE_DIR $pvac_sif \
ref-transcript-mismatch-reporter $input_vcf \
--filter hard \
--output-vcf ${BASE_DIR}/results/ref_mismatch_reporter/$output_dir/$output_vcf 