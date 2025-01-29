#!/bin/bash
#SBATCH --job-name=ROSE-5-pvactools
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)
source ~/.bashrc

module load Mamba
mamba activate pVACtools

# Input is the VCF file that has been filtered and annotated with VEP. 

# make output directory
mkdir -p ${BASE_DIR}/results/pvacseq

# set variables
tumour_dir=$1
sampleid=$(basename $tumour_dir)
hlafile="${BASE_DIR}/results/optitype/${sampleid}_Germline_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_FFPE_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_Cysectomy_T1_result.tsv"
hlas=$(sed -n '2p' "$hlafile" | cut -d$'\t' -f2-7 | sed -E 's/[[:space:]]+/,/g; s/(^|,)/\1HLA-/g')
vcf="${tumour_dir}/*.vcf.gz"
vcfsampleid=$(zgrep "#CHROM" $vcf | cut -f10)

# run pvacseq
pvacseq run \
$vcf \
$vcfsampleid \
$hlas \
NetMHCpan NetMHC PickPocket SMM SMMPMBEC MHCflurry MHCnuggetsI \
${BASE_DIR}/results/pvacseq/${sampleid}/ \
--iedb-install-directory ${BASE_DIR}/tools/iedb_binding_prediction_tools/ 