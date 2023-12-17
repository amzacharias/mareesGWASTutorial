#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Plot MAF check results
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
library(ggplot2) # 3.4.4


# Pathways -----------------------------------------
# Input ===========
baseDir <- file.path("results", "1_qcGWAS", "3_filtSNPs")
freqPath <- file.path(baseDir, "checkMAF.frq")

# Output ===========


# Load data -----------------------------------------
freq <- read.table(freqPath, header = TRUE)

# Plot -----------------------------------------
freqPlot <- ggplot(freq, aes(x = MAF)) + 
  geom_histogram() + 
  ggtitle("MAF Distribution") + 
  xlab("Allele 1 (minor) frequency") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Save -----------------------------------------
ggsave(plot = freqPlot, filename = "checkMAFPlot.pdf", path = baseDir, 
       width = 185, height = 185, units = "mm")

