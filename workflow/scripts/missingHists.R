#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Plot imiss and lmiss files as histograms
# Author: Amanda Zacharias
# Date: 2023-12-16
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
# module load StdEnv/2020 r/4.2.1
#
#
#
# Options -----------------------------------------


# Packages -----------------------------------------
library(ggplot2) # 3.4.4


# Pathways -----------------------------------------
# Input ===========
missDir <- file.path("results", "1_qcGWAS", "1_missing")
imissPath <- file.path(missDir, "plink.imiss")
lmissPath <- file.path(missDir, "plink.lmiss")

# Output ===========


# Load data -----------------------------------------
imiss <- read.table(imissPath, header = TRUE)
lmiss <- read.table(lmissPath, header = TRUE)

# Plot imiss -----------------------------------------
imissPlot <- ggplot(imiss, aes(x = F_MISS)) + 
  geom_histogram() + 
  ggtitle("Individual missingness") + 
  xlab("Missing call rate") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Plot lmiss -----------------------------------------
lmissPlot <- ggplot(imiss, aes(x = F_MISS)) + 
  geom_histogram() + 
  ggtitle("SNP missingness") + 
  xlab("Missing call rate") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Save -----------------------------------------
ggsave(plot = imissPlot, filename = "imissHistPlot.pdf", path = missDir, 
       width = 185, height = 185, units = "mm")
ggsave(plot = lmissPlot, filename = "lmissHistPlot.pdf", path = missDir, 
       width = 185, height = 185, units = "mm")
