#!/bin/bash
#SBATCH --job-name=ROSE-4-SOPRANO
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)
source ~/.bashrc

module load Mamba
mamba activate soprano

# set variables
vcf=$1
sampleid=$(basename $vcf | grep -oP '^[^_]+_[^_]+_[^_]+')
annot=$(basename $vcf | grep -oP '^[^.]*').sopranoannotated.hcfiltered.adrlar.mutect2.filtered
hlafile="${BASE_DIR}/results/optitype/${sampleid}_T1_result.tsv"
hlas=$(sed -n '2p' $hlafile | cut -d$'\t' -f2-7 | tr -d '*:')
impep="${BASE_DIR}/results/soprano/immunopeptidomes/${sampleid}.sopranoimmunopeptidome.bed"

# create output folder
mkdir -p ${BASE_DIR}/results/soprano/output/${sampleid}/

############ SOPRANO #############

# create VCF input for script
soprano-annotate -s $vcf -o $annot -d ${BASE_DIR}/results/soprano/annotated_inputs/

# create immunopeptidome for script
soprano-hla2ip --alleles $hlas --output $impep

# run soprano
soprano-run -n $sampleid \
			-o ${BASE_DIR}/results/soprano/output/ \
			-i ${BASE_DIR}/results/soprano/annotated_inputs/${annot}.vcf.anno \
			-b $impep