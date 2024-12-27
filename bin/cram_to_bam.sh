#!/bin/bash
#SBATCH --job-name=ROSE-2-cram_to_bam
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

# script to convert cram files to bam files. Provide cram file as command line argument to this script 
BASE_DIR=$(dirname `pwd`)
source ~/.bashrc

module load Mamba
mamba activate samtools

# define bam and cram files
cram=$1
bam=$(basename $cram | grep -oP '^[^_]+_[^_]+').bam
fasta="${BASE_DIR}/data/reference/Homo_sapiens_assembly38.fasta"

# CONVERT
# -u specifies uncompressed output, the default of which is bam so no need for -b
# -o is the output 
samtools view -uo ${BASE_DIR}/data/clean/bam/${bam} -T $fasta $cram

# Index bam files
# bam files need to be indexed for input of sobdetector
samtools index -bo ${BASE_DIR}/data/clean/bam/${bam}.bai ${BASE_DIR}/data/clean/bam/${bam}