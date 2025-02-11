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

# make output directory
if [ -d "${BASE_DIR}/results/pvacseq2" ]; then
    rm -r ${BASE_DIR}/results/pvacseq2
else
    mkdir -p ${BASE_DIR}/results/pvacseq2
fi

# set variables
pvac_sif="${BASE_DIR}/tools/sifs/pVACtools_4.1.1.sif"
tumour_dir=$1
sampleid=$(basename $tumour_dir)
hlafile="${BASE_DIR}/results/optitype/${sampleid}_Germline_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_FFPE_T1_result.tsv"
[[ -f "$hlafile" ]] || hlafile="${BASE_DIR}/results/optitype/${sampleid}_Cysectomy_T1_result.tsv"
hlas=$(sed -n '2p' "$hlafile" | cut -d$'\t' -f2-7 | sed -E 's/[[:space:]]+/,/g; s/(^|,)/\1HLA-/g')
vcf="${tumour_dir}/*.vcf.gz"
vcfsampleid=$(zgrep "##tumor_sample=" $vcf | sed -e "s/^##tumor_sample=//")

# run pvacseq
singularity exec --bind $BASE_DIR::$BASE_DIR $pvac_sif \
pvacseq run \
$vcf \
$vcfsampleid \
$hlas \
NetMHCpan NetMHCpanEL NetMHCIIpan NetMHCIIpanEL DeepImmuno \
${BASE_DIR}/results/pvacseq2/${sampleid}/ \
--iedb-install-directory ${BASE_DIR}/tools/iedb_binding_prediction_tools/ 