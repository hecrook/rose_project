#!/bin/bash
#SBATCH --job-name=vep-annotate
#SBATCH --partition=master-worker
#SBATCH --ntasks=1
#SBATCH --time=50:00:00
#SBATCH --mem-per-cpu=4021
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname `pwd`)

srun nextflow run nf-core/sarek --input ${BASE_DIR}/docs/sarek_annotate/samplesheet.csv \
--outdir ${BASE_DIR}/results/vep_annotate/ \
--genome GATK.GRCh38 \
--step annotate \
--tools vep \
--vep_custom_args "--vcf --everything --filter_common --per_gene --total_length --offline --format vcf --pick --symbol --terms SO --tsl --biotype --hgvs --plugin Frameshift --plugin Wildtype" \
-profile singularity \
-c ${BASE_DIR}/docs/sarek_annotate/ICR.config \
-r 3.4.0