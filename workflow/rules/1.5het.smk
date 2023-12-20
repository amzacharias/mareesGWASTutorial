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

rule findInvertedSNPs: 
    input: 
        hweControl = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEctrl.{end}"), 
          end = ["bed", "bim", "fam"]), 
        hweCase = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase.{end}"), 
          end = ["bed", "bim", "fam"]),
        inversionPath = join("data", "inversion.txt")
    output: 
        pruneIn = expand(join("results", "1_qcGWAS", "5_het", "HapMap_findInv.{end}"), 
          end = ["prune.in", "prune.out"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase"), 
        outPrefix = join("results", "1_qcGWAS", "5_het", "HapMap_findInv")
    log: 
        out = join("logs", "1_qcGWAS", "5_findInvertedSNPs.out"), 
        err = join("logs", "1_qcGWAS", "5_findInvertedSNPs.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/findInvertedSNPs.sh \
            -b {params.bfilePath} -i {input.inversionPath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """       

rule rmInverted: 
    input: 
        hweControl = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEctrl.{end}"), 
          end = ["bed", "bim", "fam"]), 
        hweCase = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase.{end}"), 
          end = ["bed", "bim", "fam"]),
        pruneIn = join("results", "1_qcGWAS", "5_het", "HapMap_findInv.prune.in")
    output: 
        outs = join("results", "1_qcGWAS", "5_het", "HapMap_rmInv.het")
    params: 
        bfilePath = join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase"), 
        outPrefix = join("results", "1_qcGWAS", "5_het", "HapMap_rmInv")
    log: 
        out = join("logs", "1_qcGWAS", "5_rmInverted.out"), 
        err = join("logs", "1_qcGWAS", "5_rmInverted.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/rmInverted.sh \
            -b {params.bfilePath} -i {input.pruneIn} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """ 
        
rule checkHetDistrib: 
    input: 
        hetFile = join("results", "1_qcGWAS", "5_het", "HapMap_rmInv.het")
    output: 
        outPlot = join("results", "1_qcGWAS", "5_het", "checkHetDistribPlot.pdf"), 
        outStats = join("results", "1_qcGWAS", "5_het", "hetOutlierStats.txt"), 
        outOutliers = join("results", "1_qcGWAS", "5_het", "hetOutliers.txt")
    log: 
        out = join("logs", "1_qcGWAS", "5_checkHetDistrib.out"), 
        err = join("logs", "1_qcGWAS", "5_checkHetDistrib.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/checkHetDistrib.R 1> {log.out} 2> {log.err}
        """   

rule rmHetOutliers:
    input: 
        hweCase = expand(join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase.{end}"), 
          end = ["bed", "bim", "fam"]),
        inPlot = join("results", "1_qcGWAS", "5_het", "checkHetDistribPlot.pdf"), 
        inStats = join("results", "1_qcGWAS", "5_het", "hetOutlierStats.txt"), 
        outliers = join("results", "1_qcGWAS", "5_het", "hetOutliers.txt")
    output: 
        outPlink = expand(join("results", "1_qcGWAS", "5_het", "HapMap_rmHet.{end}"), 
          end = ["bed", "bim", "fam"]),
    params: 
        bfilePath = join("results", "1_qcGWAS", "4_HWE", "HapMap_HWEcase"), 
        outPrefix = join("results", "1_qcGWAS", "5_het", "HapMap_rmHet")
    log: 
        out = join("logs", "1_qcGWAS", "5_rmHetOutliers.out"), 
        err = join("logs", "1_qcGWAS", "5_rmHetOutliers.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/rmHetOutliers.sh \
            -b {params.bfilePath} -i {input.outliers} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """ 