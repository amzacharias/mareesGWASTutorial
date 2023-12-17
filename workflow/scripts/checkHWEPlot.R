#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Plot HWE check results
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
library(cowplot) # 1.1.2

# Pathways -----------------------------------------
# Input ===========
baseDir <- file.path("results", "1_qcGWAS", "4_HWE")
hwePath <- file.path(baseDir, "plink.hwe")
hweZoomPath <- file.path(baseDir, "plinkZoom.hwe")

# Output ===========


# Load data -----------------------------------------
hwe <- read.table(hwePath, header = TRUE)
hweZoom <- read.table(hweZoomPath, header = FALSE)
colnames(hweZoom) <- colnames(hwe)

# Plot -----------------------------------------
hwePlot <- ggplot(hwe, aes(x = P)) + 
  geom_histogram() + 
  ggtitle("HWE p-value distribution") + 
  xlab("P-values") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))
hweZoomPlot <- ggplot(hweZoom, aes(x = P)) + 
  geom_histogram() + 
  ggtitle("P-values < 0.00001") + 
  xlab("P-values") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

hwePlots <- plot_grid(hwePlot, hweZoomPlot)

# Save -----------------------------------------
ggsave(plot = hwePlots, filename = "checkHWEPlot.pdf", path = baseDir, 
       width = 370, height = 185, units = "mm")

