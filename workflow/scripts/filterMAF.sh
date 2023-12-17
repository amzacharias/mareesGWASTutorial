#!/bin/bash
#SBATCH --job-name=filterMAF
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=filterMAF.out
#SBTACH --error=filterMAF.err

# Title: Filter rare MAFs
# Author: Amanda Zacharias
# Date: 2023-12-16
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------

echo Job started at $(date +'%T')

# Code
while getopts b:o: flag
do
    case "${flag}" in
        b) BFILEPATH=${OPTARG};;
        o) OUTPATH=${OPTARG};;
    esac
done

# Remove SNPs with a MAF < 0.05
plink --bfile $BFILEPATH --maf 0.05 --make-bed --out $OUTPATH

echo Job ended at $(date +'%T')
