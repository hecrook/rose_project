#!/bin/bash
#SBATCH --job-name=ROSE-1_filter_VCF
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-user=hannah.crook@icr.ac.uk
#SBATCH --mail-type=ALL

################################################################
######                   STEP 1.                        ########
######  run tumour VCFs through filter_mutect2_HC.py    ########
################################################################

# script to run all desired tumour VCFS (after filtermutect2calls) through the filter_mutect2_HC.py script which filters each variant based on quality and depth. 
# see the script in /bin for more details.  
# submit straight to slurm by wrapping script in sbatch 

# change into results directory 
cd /data/scratch/DMP/UCEC/EVOLIMMU/hcrook/rose_project/

tumour_dirs=$( find data/raw/ -mindepth 1 -maxdepth 1 -type d )
echo "running analysis on " $tumour_dirs

# for loop to run all tumour files through python script
for dir in $tumour_dirs ; do
        file="$dir/*.adrlar.mutect2.filtered.vcf"
        name=$(echo $file | xargs basename | grep -P '^[^.]*' -o)
	output="/data/scratch/DMP/UCEC/EVOLIMMU/hcrook/rose_project/results/filter_vcf/$name.hcfiltered.adrlar.mutect2.filtered.vcf"
        echo "Running sample " $name ", VCF file (" $file ") through python script to filter VCF. Output will be published in " $output
        python3 bin/filter_mutect2_HC2.py $file $output
done
