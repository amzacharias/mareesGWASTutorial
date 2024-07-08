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
library(dplyr) # 1.1.0

# Pathways -----------------------------------------
# Input ===========
baseDir <- file.path("results", "1_qcGWAS", "5_het")
hetPath <- file.path(baseDir, "HapMap_rmInv.het")

# Output ===========


# Load data -----------------------------------------
het <- read.table(hetPath, header = TRUE)
# F coefficient estimates = 
# observed homozygosity count - expected counts / total observations - expected counts

# Plot -----------------------------------------
hetPlot <- ggplot(het, aes(x = F)) + 
  geom_histogram() + 
  ggtitle("Heterozygosity distribution") + 
  xlab("F coefficient estimates") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Save plot -----------------------------------------
ggsave(plot = hetPlot, filename = "checkHetDistribPlot.pdf", path = baseDir, 
       width = 185, height = 185, units = "mm")

# Heterozygosity outliers -----------------------------------------
# Identify identividuals whose heterozygosity rate is more than 3 standard deviations 
# from the mean het. rate.
# Purpose is to exclude sample contamination and inbreeding.
het <- het %>% 
  # N.NM. = Number of (nonmissing, non-monomorphic) autosomal genotype observations
  # O.HOM. = Observed number of homozygotes
  # E.HOM = Expected number of homozygotes
  # F = (observed - expected) / (total observations - expected)
  mutate(HET.RATE = (O.HOM. - E.HOM.) / (N.NM. - E.HOM.))

# HET.RATE should == F calculated by plink 

hetStats <- het %>% 
  summarize(
    "mean" = mean(HET.RATE), 
    "sd" = sd(HET.RATE)
  ) %>% 
  mutate("sd3" = 3 * sd) %>% 
  mutate("meanMinusSd3" = mean - sd3, 
         "meanPlusSd3" = mean + sd3) 

hetOutliers <- het %>% 
  # Identify individuals whose het. rate is an outlier
  subset(HET.RATE < hetStats$meanMinusSd3 | HET.RATE > hetStats$meanPlusSd3) %>% 
  # Calculate standard deviation from the mean
  # My interpretation of this variable's meaning is based on the authors' interpretation
  mutate("HET.DST" = (HET.RATE - hetStats$mean) / hetStats$sd)

# Save outliers -----------------------------------------
# Save stats =======
write.table(hetOutliers, file.path(baseDir, "hetOutlierStats.txt"), 
            row.names = FALSE, quote = FALSE)

# File for plink ======
forPlink <- hetOutliers %>% 
  dplyr::select(c("FID", "IID"))

write.table(forPlink, file.path(baseDir, "hetOutliers.txt"), 
            row.names = FALSE, quote = FALSE)

