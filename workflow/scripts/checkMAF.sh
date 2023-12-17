#!/bin/bash
#SBATCH --job-name=checkMAF
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=checkMAF.out
#SBTACH --error=checkMAF.err

# Title: Check minor allele frequencies
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

# Minor allele frequency report
plink --bfile $BFILEPATH --freq --out $OUTPATH

echo Job ended at $(date +'%T')
