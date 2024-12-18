#!/bin/bash
#SBATCH --job-name=ROSE-3-filter_FFPE
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)
source ~/.bashrc
SOBDetector="$BASE_DIR/tools/SOBDetector_v1.0.4.jar"
module load Mamba
mamba activate samtools

# Defining variables - sample specific sample file and bam file
####### INPUT SHOULD BE LS OF FILTER_VCF DIR
vcf=$1
sampleid=$(basename $vcf | grep -oP '^[^_]+_[^_]+_[^_]+')
bam="$BASE_DIR/data/clean/bam/${sampleid}.bam"

mkdir -p ${BASE_DIR}/results/sobdetector
output="${BASE_DIR}/results/sobdetector/${sampleid}.sobdetector.hcfiltered.adrlar.mutect2.filtered.vcf"

java -jar $SOBDetector \
    --input-type VCF \
    --input-variants $vcf \
    --input-bam $bam \
    --output-variants $output \
    --only-passed true