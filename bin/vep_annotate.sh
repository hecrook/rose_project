#!/bin/bash
#SBATCH --job-name=vep-annotate
#SBATCH --partition=master-worker
#SBATCH --ntasks=1
#SBATCH --time=50:00:00
#SBATCH --mem-per-cpu=4021
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

BASE_DIR=$(dirname $(pwd))
SCRATCH="/data/scratch/DMP/UCEC/EVOLIMMU/hcrook/"
vep_sif="$SCRATCH/tools/singularity_images/vep/vep.sif"
input_file=$(echo $1 | cut -d'/' -f8-)
sampleid=$(basename $1 | grep -oP '^[^.]+')
output_file=$(basename $input_file .vcf)_VEP.ann.vcf.gz

# Make output directory
mkdir -p $SCRATCH/rose_project/results/vep_annotate2/$sampleid/

# trying local download of vep singulairty image instead
singularity exec --bind $SCRATCH:$SCRATCH $vep_sif \
    vep --offline --cache \
    --dir $SCRATCH/tools/singularity_images/vep/vep_data \
    --dir_cache $SCRATCH/tools/singularity_images/vep/vep_data \
    --dir_plugins $SCRATCH/tools/singularity_images/vep/plugins/VEP_plugins \
    --force_overwrite \
    --format vcf \
    --vcf \
    --compress_output gzip\
    --symbol \
    --terms SO \
    --tsl \
    --biotype \
    --hgvs \
    --fasta /data/scratch/DMP/UCEC/EVOLIMMU/hcrook/tools/singularity_images/vep/vep_data/homo_sapiens/113_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz \
    --cache \
    --plugin Frameshift \
    --plugin Wildtype \
    --input_file $SCRATCH/$input_file \
    --output_file $SCRATCH/rose_project/results/vep_annotate2/$sampleid/$output_file \
    --pick \
    --safe