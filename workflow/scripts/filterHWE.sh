#!/bin/bash
#SBATCH --job-name=filterHWE
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=filterHWE.out
#SBTACH --error=filterHWE.err

# Title: Filter SNPs that aren't in Hardy-Weinberg equilibrium
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

# Filter controls with stringent p-value cutoff
plink --bfile $BFILEPATH --hwe 1e-6 --make-bed --out "${OUTPATH}ctrl"

# Filter cases with liberal p-value cutoff
plink --bfile "${OUTPATH}ctrl" --hwe include-nonctrl 1e-10 --make-bed --out "${OUTPATH}case"

echo Job ended at $(date +'%T')
