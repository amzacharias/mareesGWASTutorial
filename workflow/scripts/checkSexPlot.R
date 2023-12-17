#!/usr/bin/env Rscript
#-------------------------------------------------
# Title: Plot sex check results
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
baseDir <- file.path("results", "1_qcGWAS", "2_checkSex")
sexcheckPath <- file.path(baseDir, "plink.sexcheck")

# Output ===========


# Load data -----------------------------------------
sexcheck <- read.table(sexcheckPath, header = TRUE)

# Plot imiss -----------------------------------------
sexcheckPlot <- ggplot(sexcheck, aes(x = F, fill=STATUS)) + 
  geom_histogram() + 
  ggtitle("Sex check") + 
  xlab("Inbreeding coefficient") + 
  ylab("Frequency") + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 20))

# Save -----------------------------------------
ggsave(plot = sexcheckPlot, filename = "checkSexPlot.pdf", path = baseDir, 
       width = 185, height = 185, units = "mm")

