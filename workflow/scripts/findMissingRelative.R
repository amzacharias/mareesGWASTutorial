#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Finding the relative with the highest missingness rate
# Author: Amanda Zacharias
# Date: 2023-12-17
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
# module load StdEnv/2020 r/4.2.1
# R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
# 
#
# Options -----------------------------------------


# Packages -----------------------------------------
library(dplyr) # 1.1.0

# Pathways -----------------------------------------
# Input ===========
baseDir <- file.path("results", "1_qcGWAS", "6_rel")
imissPath <- file.path(baseDir, "plink.imiss")
relPihatFiltPath <- file.path(baseDir, "HapMap_rmNonFounders_pihat0.2.genome")

# Output ===========


# Load data -----------------------------------------
imiss <- read.table(imissPath, header = TRUE, stringsAsFactors = FALSE)
relPihat <- read.table(relPihatFiltPath, header = TRUE, stringsAsFactors = FALSE)

# Wrangle -----------------------------------------
rel1 <- relPihat$IID1
rel2 <- relPihat$IID2

relImiss <- imiss %>% subset(IID == rel1 | IID == rel2)

# Remove relative with more missiness
rmRelative <- relImiss %>% 
  slice(which.max(F_MISS)) %>% 
  dplyr::select(c(FID, IID))

# Save -----------------------------------------
write.table(rmRelative, file.path(baseDir, "rmMissingRel.txt"), 
           row.names = FALSE, quote = FALSE)


