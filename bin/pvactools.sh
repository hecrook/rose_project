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

# Input is the VCF file that has been filtered and annotated with VEP. 

# set variables
pvac_sif="/data/scratch/shared/SINGULARITY-DOWNLOAD/tools/.singularity/pvactools_latest.sif"
tumour_dir=$1
sampleid=$(basename $tumour_dir)
hlafile="${BASE_DIR}/results/optitype/${sampleid}_Germline_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_FFPE_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_Cysectomy_T1_result.tsv"
hlas=$(sed -n '2p' "$hlafile" | cut -d$'\t' -f2-7 | sed -E 's/[[:space:]]+/,/g; s/(^|,)/\1HLA-/g')
vcf="${tumour_dir}/*.vcf"
vcfsampleid=$(zgrep "##tumor_sample=" $vcf | sed -e "s/^##tumor_sample=//")

# Printing sample name for log (and vcf for troubleshooting)
echo "Running pvacseq on $sampleid"
echo "VCF file: $vcf"
echo "HLA alleles: $hlas"

# make output directory
if [ -d "${BASE_DIR}/results/pvacseq_expression_sif2/${sampleid}/" ]; then
    echo "Previous run detected, deleting previous results"
    rm -r ${BASE_DIR}/results/pvacseq_expression_sif2/${sampleid}/
    mkdir -p ${BASE_DIR}/results/pvacseq_expression_sif2/${sampleid}/
else
    echo "Output directory does not exist, creating"
    mkdir -p ${BASE_DIR}/results/pvacseq_expression_sif2/${sampleid}/
fi

# run pvacseq
singularity exec --bind $BASE_DIR::$BASE_DIR $pvac_sif \
pvacseq run \
$vcf \
$vcfsampleid \
$hlas \
NetMHCpan NetMHC NetMHCcons NetMHCpanEL PickPocket SMM SMMPMBEC BigMHC_EL BigMHC_IM DeepImmuno\
${BASE_DIR}/results/pvacseq_expression_sif2/${sampleid}/ \
--iedb-install-directory /opt/iedb