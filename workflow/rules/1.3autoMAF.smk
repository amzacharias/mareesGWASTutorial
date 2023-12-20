# Title: Check sex QC rules
# Author: Amanda Zacharias
# Date: 2023-06-01
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
# module load StdEnv/2020 python/3.11.2

# Load packages
import os
from os.path import join

rule filterAutosomal: 
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "2_checkSex", "HapMap_impSex.{end}"), 
          end = ["bed", "bim", "fam"])
    output: 
        outFiles = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto.{end}"), 
          end = ["bed", "bim", "fam"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "2_checkSex", "HapMap_impSex"), 
        outPrefix = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto")
    log: 
        out = join("logs", "1_qcGWAS", "3_autosomal.out"), 
        err = join("logs", "1_qcGWAS", "3_autosomal.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/filterAutosomal.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """         

rule checkMAF: 
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto.{end}"), 
          end = ["bed", "bim", "fam"])
    output: 
        outFile = join("results", "1_qcGWAS", "3_autoMAF", "checkMAF.frq")
    params: 
        bfilePath = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto"),
        outPrefix = join("results", "1_qcGWAS", "3_autoMAF", "checkMAF")
    log: 
        out = join("logs", "1_qcGWAS", "3_checkMAF.out"), 
        err = join("logs", "1_qcGWAS", "3_checkMAF.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/checkMAF.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """  

rule checkMAFPlot: 
    input: 
        checkMAFFile = join("results", "1_qcGWAS", "3_autoMAF", "checkMAF.frq")
    output: 
        outFile = join("results", "1_qcGWAS", "3_autoMAF", "checkMAFPlot.pdf")
    log: 
        out = join("logs", "1_qcGWAS", "3_checkMAFPlot.out"), 
        err = join("logs", "1_qcGWAS", "3_checkMAFPlot.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
         module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/checkMAFPlot.R 1> {log.out} 2> {log.err}
        """  
        
rule filterMAF: 
    input: 
        MAFPlot = join("results", "1_qcGWAS", "3_autoMAF", "checkMAFPlot.pdf"), 
        inPlink = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto.{end}"), 
          end = ["bed", "bim", "fam"])
    output: 
        outFile = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF.{end}"), 
          end = ["bed", "bim", "fam"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_auto"),
        outPrefix = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF")
    log: 
        out = join("logs", "1_qcGWAS", "3_filterMAF.out"), 
        err = join("logs", "1_qcGWAS", "3_filterMAF.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/filterMAF.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """  