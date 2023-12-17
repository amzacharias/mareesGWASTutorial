#!/bin/bash
#SBATCH --job-name=missingFilter
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=missingFilter.out
#SBTACH --error=missingFilter.err

# Title: Missingness
# Author: Amanda Zacharias
# Date: 2023-12-16
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------

echo Job started at $(date +'%T')

# Code
while getopts b:t:o: flag
do
    case "${flag}" in
        b) BFILEPATH=${OPTARG};;
        t) FILTTHRESH=${OPTARG};;
        o) OUTPATH=${OPTARG};;
    esac
done

# Filter based on SNP missingness
plink --bfile $BFILEPATH --geno $FILTTHRESH --make-bed --out ${OUTPATH}_snp${FILTTHRESH}

# Filter based on individual missingness
plink --bfile $BFILEPATH --mind $FILTTHRESH --make-bed --out ${OUTPATH}_ind${FILTTHRESH}

echo Job ended at $(date +'%T')
