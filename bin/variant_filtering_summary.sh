#!/bin/bash
#SBATCH --job-name=ROSE-7-summary
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)

# set variables
sob_vcf=$1

sampleid=$(basename $sob_vcf | grep -P '^[^.]*' -o)
raw_vcf="${BASE_DIR}/data/raw/${sampleid}*/*.adrlar.mutect2.filtered.vcf"

name=$(echo $raw_vcf | xargs basename | grep -P '^[^.]*' -o)
filter_vcf="${BASE_DIR}/results/filter_vcf/$name.hcfiltered.adrlar.mutect2.filtered.vcf"

# create table
mkdir -p ${BASE_DIR}/results/filtered_variants_summary/${sampleid}/
echo "raw_vcf,qual_filt_vcf,sob_filt_vcf" > ${BASE_DIR}/results/filtered_variants_summary/${sampleid}/${sampleid}_filteredvariants_summary.csv

# Identify mutations in each file and ammend to table
paste -d ',' <(grep -v "#" $raw_vcf | wc -l) <(grep -v "#" $filter_vcf | wc -l) <(grep -v "#" $sob_vcf | wc -l) >> ${BASE_DIR}/results/filtered_variants_summary/${sampleid}/${sampleid}_filteredvariants_summary.csv