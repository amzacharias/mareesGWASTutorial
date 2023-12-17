# Title: Missingness QC rules
# Author: Amanda Zacharias
# Date: 2023-06-01
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
# module load StdEnv/2020 python/3.11.2

# Load packages
import os
from os.path import join

rule checkMissingStats:
  input: 
      rawPlink = expand(join("data", "HapMap_3_r3_1.{end}"), end = ["bed", "bim", "fam"])
  output: 
      plinkStats = expand(join("results", "1_qcGWAS", "1_missing", "plink.{metric}"), 
          metric = ["imiss", "lmiss"])
  params:
      bfilePath = join("data", "HapMap_3_r3_1"), 
      outDir = join("results", "1_qcGWAS", "1_missing")
  log: 
      out = join("logs", "1_qcGWAS", "1_missing.out"), 
      err = join("logs", "1_qcGWAS", "1_missing.err")
  resources: 
      mem_mb = 30000, 
      runtime = 100, 
      cpus_per_task = 1, 
      slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
  shell: 
      """
      module load StdEnv/2020
      module load plink/1.9b_6.21-x86_64
      sh scripts/missingStats.sh -b {params.bfilePath} -o {params.outDir} 1> {log.out} 2> {log.err}
      """
  
rule makeMissingHists:
    input:
        plinkStats = expand(join("results", "1_qcGWAS", "1_missing", "plink.{metric}"), 
          metric = ["imiss", "lmiss"])
    output: 
        pdfs = expand(join("results", "1_qcGWAS", "1_missing", "{metric}HistPlot.pdf"), 
          metric = ["imiss", "lmiss"])
    params:
        outDir = join("results", "1_qcGWAS", "1_missing")
    log: 
        out = join("logs", "1_qcGWAS", "1_missingHist.out"), 
        err = join("logs", "1_qcGWAS", "1_missingHist.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/missingHists.R 1> {log.out} 2> {log.err}
        """
  
rule liberalMissingFilter: 
    input: 
        rawPlink = expand(join("data", "HapMap_3_r3_1.{end}"), end = ["bed", "bim", "fam"]), 
        pdfs = expand(join("results", "1_qcGWAS", "1_missing", "{metric}HistPlot.pdf"), 
          metric = ["imiss", "lmiss"])
    output: 
        outs = expand(join("results", "1_qcGWAS", "1_missing", "HapMap_{lvl}0.2.{end}"), 
                      lvl = ["snp", "ind"], end = ["bed", "bim", "fam"])
    params:
        bfilePath = join("data", "HapMap_3_r3_1"), 
        outPrefix = join("results", "1_qcGWAS", "1_missing", "HapMap"), 
        filtThresh = 0.2
    log: 
        out = join("logs", "1_qcGWAS", "1_missing02filt.out"), 
        err = join("logs", "1_qcGWAS", "1_missing02filt.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/missingFilter.sh -b {params.bfilePath} -t {params.filtThresh} -o {params.outPrefix} \
        1> {log.out} 2> {log.err}
        """

rule stringentMissingFilter: 
    input: 
        rawPlink = expand(join("data", "HapMap_3_r3_1.{end}"), end = ["bed", "bim", "fam"]),
        liberalPlink = expand(join("results", "1_qcGWAS", "1_missing", "HapMap_{lvl}0.2.{end}"), 
                      lvl = ["snp", "ind"], end = ["bed", "bim", "fam"]), 
        pdfs = expand(join("results", "1_qcGWAS", "1_missing", "{metric}HistPlot.pdf"), 
          metric = ["imiss", "lmiss"])
    output: 
        outs = expand(join("results", "1_qcGWAS", "1_missing", "HapMap_{lvl}0.02.{end}"), 
          lvl = ["snp", "ind"], end = ["bed", "bim", "fam"])
    params:
        bfilePath = join("data", "HapMap_3_r3_1"), 
        outPrefix = join("results", "1_qcGWAS", "1_missing", "HapMap"), 
        filtThresh = 0.02
    log: 
        out = join("logs", "1_qcGWAS", "1_missing002filt.out"), 
        err = join("logs", "1_qcGWAS", "1_missing002filt.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/missingFilter.sh -b {params.bfilePath} -t {params.filtThresh} -o {params.outPrefix} \
        1> {log.out} 2> {log.err}
        """
