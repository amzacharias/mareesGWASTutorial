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

rule checkSex: 
    input: 
        inPlink =  expand(join("results", "1_qcGWAS", "1_missing", "HapMap_{lvl}0.02.{end}"), 
          lvl = ["snp", "ind"], end = ["bed", "bim", "fam"])
    output: 
        outFile = join("results", "1_qcGWAS", "2_checkSex", "plink.sexcheck")
    params:
        bfilePath = join("results", "1_qcGWAS", "1_missing", "HapMap_ind0.02"), 
        outPrefix = join("results", "1_qcGWAS", "2_checkSex", "plink")
    log: 
        out = join("logs", "1_qcGWAS", "2_checkSex.out"), 
        err = join("logs", "1_qcGWAS", "2_checkSex.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/checkSex.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """
        
rule checkSexPlot: 
    input: 
        sexcheckFile = join("results", "1_qcGWAS", "2_checkSex", "plink.sexcheck")
    output: 
        outFile = join("results", "1_qcGWAS", "2_checkSex", "checkSexPlot.pdf")
    log: 
        out = join("logs", "1_qcGWAS", "2_checkSexPlot.out"), 
        err = join("logs", "1_qcGWAS", "2_checkSexPlot.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
         module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/checkSexPlot.R 1> {log.out} 2> {log.err}
        """       
        
rule imputeSex: 
    input: 
        inPlink =  expand(join("results", "1_qcGWAS", "1_missing", "HapMap_{lvl}0.02.{end}"), 
          lvl = ["snp", "ind"], end = ["bed", "bim", "fam"]), 
        sexHist = join("results", "1_qcGWAS", "2_checkSex", "checkSexPlot.pdf")
    output: 
        outFiles = expand(join("results", "1_qcGWAS", "2_checkSex", "HapMap_impSex.{end}"), 
          end = ["bed", "bim", "fam"])
    params:
        bfilePath = join("results", "1_qcGWAS", "1_missing", "HapMap_ind0.02"), 
        outPrefix = join("results", "1_qcGWAS", "2_checkSex", "HapMap_impSex")
    log: 
        out = join("logs", "1_qcGWAS", "2_imputeSex.out"), 
        err = join("logs", "1_qcGWAS", "2_imputeSex.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/imputeSex.sh -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """        
        