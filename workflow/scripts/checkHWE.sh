#!/bin/bash
#SBATCH --job-name=checkHWE
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=16amz1@queensu.ca
#SBATCH --qos=privileged # or SBATCH --partition=standard
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB  # Job memory request
#SBATCH --time=0-5:00:00  # Day-Hours-Minutes-Seconds
#SBATCH --output=checkHWE.out
#SBTACH --error=checkHWE.err

# Title: Check Hardy-Weinberg equilibrium exact test statistics
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

# HWE stats
plink --bfile $BFILEPATH --hardy --out $OUTPATH
# Zoom in on strongly deviating SNPs by p-value < 0.00001
awk '{ if ($9 <0.00001) print $0 }' ${OUTPATH}.hwe > ${OUTPATH}Zoom.hwe

echo Job ended at $(date +'%T')
