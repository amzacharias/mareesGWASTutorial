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

rule checkHWE: 
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF.{end}"), 
          end = ["bed", "bim", "fam"])
    output: 
        outHWE = join("results", "1_qcGWAS", "4_HWE", "plink.hwe"),
        outZoomHWE = join("results", "1_qcGWAS", "4_HWE", "plinkZoom.hwe")
    params: 
        bfilePath = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF"), 
        outPrefix = join("results", "1_qcGWAS", "4_HWE", "plink")
    log: 
        out = join("logs", "1_qcGWAS", "4_checkHWE.out"), 
        err = join("logs", "1_qcGWAS", "4_checkHWE.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/checkHWE.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """       

rule checkHWEPlot: 
    input: 
        checkHWE = join("results", "1_qcGWAS", "4_HWE", "plink.hwe"),
        checkZoomHWE = join("results", "1_qcGWAS", "4_HWE", "plinkZoom.hwe")
    output: 
        outFile = join("results", "1_qcGWAS", "4_HWE", "checkHWEPlot.pdf")
    log: 
        out = join("logs", "1_qcGWAS", "4_checkHWEPlot.out"), 
        err = join("logs", "1_qcGWAS", "4_checkHWEPlot.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
         module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/checkHWEPlot.R 1> {log.out} 2> {log.err}
        """   
        
rule filterHWE: 
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF.{end}"), 
          end = ["bed", "bim", "fam"]), 
        checkPlot = join("results", "1_qcGWAS", "4_HWE", "checkHWEPlot.pdf")
    output: 
        filtControl = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEctrl.{end}"), 
          end = ["bed", "bim", "fam"]), 
        filtCase = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase.{end}"), 
          end = ["bed", "bim", "fam"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "3_autoMAF", "HapMap_MAF"), 
        outPrefix = join("results", "1_qcGWAS", "4_HWE", "HapMap_HWE")
    log: 
        out = join("logs", "1_qcGWAS", "4_filterHWE.out"), 
        err = join("logs", "1_qcGWAS", "4_filterHWE.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/filterHWE.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """       