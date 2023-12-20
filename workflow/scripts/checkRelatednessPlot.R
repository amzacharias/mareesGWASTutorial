#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Plot check relatedness results
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
baseDir <- file.path("results", "1_qcGWAS", "6_rel")
relPath <- file.path(baseDir, "HapMap_pihat0.2.genome")
relZoomPath <- file.path(baseDir, "HapMap_pihat0.2Zoom.genome")

# Output ===========


# Load data -----------------------------------------
# RT = inferred relationship type
# EZ = identity-by-descent (IDB) sharing expected value, based on .fam
# Z0 = no relatedness probability
# Z1 = partial relatedness probability
# Z2 = full relatedness probability; FS = full siblings, HS = half sibs, PO = parent-offspring, OT = other
# PI_HAT = proportion IBD
# PHE = pairwise phenotype; 1 = case-case, 0 = case-control, -1 = control-control 
# DST = IBD distance
# PPC = IBS binomial test
# RATIO = identity-by-state non-missing variants SNP ratio
rel <- read.table(relPath, header = TRUE)
relZoom <- read.table(relZoomPath, header = TRUE)

# Plot -----------------------------------------
# Z0 vs Z1 =========
zzPlot <- ggplot(rel, aes(x = Z0, y = Z1, color = RT)) + 
  geom_point(size = 4) + 
  ggtitle("Inferred relationship type") + 
  xlab("No relatedness probability (Z0)") + 
  ylab("Partial relatedness probability(Z1)") + 
  scale_color_discrete(name = "Relationship type", labels = c("parent-offspring", "unrelated")) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 15))
zzZoomPlot <- ggplot(relZoom, aes(x = Z0, y = Z1, color = RT)) + 
  geom_point(size = 4) + 
  ggtitle("Inferred relationship type") + 
  xlab("No relatedness probability (Z0)") + 
  ylab("Partial relatedness probability(Z1)") + 
  scale_color_discrete(name = "Relationship type", labels = c("parent-offspring", "unrelated")) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 15))

mergeZzPlot <- plot_grid(zzPlot, zzZoomPlot)

# Relatedness ========
relPlot <- ggplot(rel, aes(x = PI_HAT)) + 
  geom_histogram() + 
  ggtitle("Relatedness distribution") + 
  xlab("Pihat") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Save plot -----------------------------------------
ggsave(plot = mergeZzPlot, filename = "zzPlot.pdf", path = baseDir, 
       width = 365, height = 185, units = "mm")
ggsave(plot = relPlot, filename = "relPlot.pdf", path = baseDir, 
       width = 185, height = 185, units = "mm")

