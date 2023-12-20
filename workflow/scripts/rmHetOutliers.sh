#!/bin/bash
#SBATCH --job-name=rmHetOutliers
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=rmHetOutliers.out
#SBTACH --error=rmHetOutliers.err

# Title: Remove individuals with outlier heterozygosity rates
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
        i) RMPATH=${OPTARG};;
        o) OUTPATH=${OPTARG};;
    esac
done

# Rm individuals in the $RMPATH file
plink --bfile $BFILEPATH --remove $RMPATH --make-bed --out $OUTPATH

echo Job ended at $(date +'%T')
