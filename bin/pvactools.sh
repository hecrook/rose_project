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
pvac_sif="${BASE_DIR}/tools/sifs/pVACtools_4.1.1.sif"
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
if [ -d "${BASE_DIR}/results/pvacseq_expression/${sampleid}/" ]; then
    echo "Previous run detected, deleting previous results"
    rm -r ${BASE_DIR}/results/pvacseq_expression/${sampleid}/
    mkdir -p ${BASE_DIR}/results/pvacseq_expression/${sampleid}/
else
    echo "Output directory does not exist, creating"
    mkdir -p ${BASE_DIR}/results/pvacseq_expression/${sampleid}/
fi

# run pvacseq
singularity exec --bind $BASE_DIR::$BASE_DIR $pvac_sif \
pvacseq run \
$vcf \
$vcfsampleid \
$hlas \
NetMHCpan NetMHCpanEL PickPocket SMM SMMPMBEC BigMHC_EL \
${BASE_DIR}/results/pvacseq_expression/${sampleid}/ \
--iedb-install-directory ${BASE_DIR}/tools/iedb_binding_prediction_tools/ 