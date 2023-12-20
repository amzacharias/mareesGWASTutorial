#!/bin/bash
#SBATCH --job-name=findInvertedSNPs
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=findInvertedSNPs.out
#SBTACH --error=findInvertedSNPs.err

# Title: Filter SNPs that occur in regions with high inversion rates
# Author: Amanda Zacharias
# Date: 2023-12-16
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------

echo Job started at $(date +'%T')

# Code
while getopts b:i:o: flag
do
    case "${flag}" in
        b) BFILEPATH=${OPTARG};;
        i) INVERTPATH=${OPTARG};;
        o) OUTPATH=${OPTARG};;
    esac
done

# Find SNPs in inversion regions
# 50 = Slide window size (# of SNPs) 
# 5 = Step size for window in SNPs
# 0.2 = multiple correlation coefficient for a SNP being regressed on all other SNPs simultaneously.
plink --bfile $BFILEPATH --exclude range $INVERTPATH --indep-pairwise 50 5 0.2 --out ${OUTPATH}

echo Job ended at $(date +'%T')
