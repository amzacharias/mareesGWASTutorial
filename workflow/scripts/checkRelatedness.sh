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

# Title: Check relatedness between individuals using the fam file
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
        i) PRUNEPATH=${OPTARG};;
        o) OUTPATH=${OPTARG};;
    esac
done

# Calculate relatedness between individuals with a pihat > 0.2
# Threshold serves to minimize output filesize
plink --bfile $BFILEPATH --extract $PRUNEPATH --genome --min 0.2 --out $OUTPATH

# Zoom in on parent-offsprings relationships using probability half-related (Z1) > 0.9.
awk '{ if ($8 >0.9) print $0 }' ${OUTPATH}.genome > ${OUTPATH}Zoom.genome

echo Job ended at $(date +'%T')
