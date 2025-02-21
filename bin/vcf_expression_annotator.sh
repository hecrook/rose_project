#!/bin/bash
#SBATCH --job-name=ROSE-5-pvactools
#SBATCH --partition=compute
#SBATCH --ntasks=2
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=2000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)
source ~/.bashrc

# Script to annotate VCFs with gene expression data using vcf-expression-annotator from pvactools.
# The input should be the correctly annotated VEP VCF files.
# This must be done BEFORE pvactools if you want to identify the EXPRESSION of any neoantigens.

# set variables
pvac_sif="${BASE_DIR}/tools/sifs/pVACtools_4.1.1.sif"
vcf="${1}/*.vcf.gz"
vcfsampleid=$(zgrep "##tumor_sample=" $vcf | sed -e "s/^##tumor_sample=//")
exp_tsv="${BASE_DIR}/data/clean/expression/ComBatSeq/"
output=$(basename $vcf .vcf.gz).gx.vcf

# creating samplename that matches the column names in the expression tsv. Using the directory name of vep_annotate as a base --> cml input to this script
base_name=$(basename $1)
if [[ $base_name = RADIO_6 ]]; then
    sampleid="R6_Cystectomy"
else
    if [[ $base_name =~ (PLUMMB|RADIO) ]]; then
        trial=$(echo $base_name | grep -o "^.")
        sample=$(echo "$base_name" | cut -d '_' -f 2)
        sampleid="${trial}${sample}"
    else
        sampleid=$(echo "$base_name" | cut -d "_" -f 1)
    fi
fi

# make output directory - forced overwrite of any previous runs
if [ -d "${BASE_DIR}/results/vcf_expression_annotator/${base_name}" ]; then
    rm -r ${BASE_DIR}/results/vcf_expression_annotator/${base_name}
else
    mkdir -p ${BASE_DIR}/results/vcf_expression_annotator/${base_name}
fi

# Run vcf-expression-annotator
singularity exec --bind $BASE_DIR::$BASE_DIR $pvac_sif \
vcf-expression-annotator \
-i gene_ids \
-e $sampleid \
-s $vcfsampleid \
-o ${BASE_DIR}/results/vcf_expression_annotator/${base_name}/${output}


