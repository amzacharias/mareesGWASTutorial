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

rule checkRelatedness:
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "5_het", "HapMap_rmHet.{end}"), 
          end = ["bed", "bim", "fam"]),
        pruneIn = join("results", "1_qcGWAS", "5_het", "HapMap_findInv.prune.in")
    output: 
        outGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_pihat0.2.genome"), 
        outZoomGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_pihat0.2Zoom.genome")
    params: 
        bfilePath = join("results", "1_qcGWAS", "5_het", "HapMap_rmHet"), 
        outPrefix = join("results", "1_qcGWAS", "6_rel", "HapMap_pihat0.2")
    log: 
        out = join("logs", "1_qcGWAS", "6_checkRelatedness.out"), 
        err = join("logs", "1_qcGWAS", "6_checkRelatedness.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/checkRelatedness.sh \
            -b {params.bfilePath} -i {input.pruneIn} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """ 
        
rule checkRelatednessPlot:
    input: 
        outGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_pihat0.2.genome"), 
        outZoomGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_pihat0.2Zoom.genome")
    output: 
        relPlotPath = join("results", "1_qcGWAS", "6_rel", "relPlot.pdf"), 
        relZzPlotPath = join("results", "1_qcGWAS", "6_rel", "zzPlot.pdf")
    log: 
        out = join("logs", "1_qcGWAS", "6_checkRelatednessPlot.out"), 
        err = join("logs", "1_qcGWAS", "6_checkRelatednessPlot.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/checkRelatednessPlot.R 1> {log.out} 2> {log.err}
        """ 

rule rmNonFounders:
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "5_het", "HapMap_rmHet.{end}"), 
          end = ["bed", "bim", "fam"]),
        relPlotPath = join("results", "1_qcGWAS", "6_rel", "relPlot.pdf"), 
        relZzPlotPath = join("results", "1_qcGWAS", "6_rel", "zzPlot.pdf")
    output: 
        outPlink = expand(join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders.{end}"), 
          end = ["bed", "bim", "fam"]),
    params: 
        bfilePath = join("results", "1_qcGWAS", "5_het", "HapMap_rmHet"), 
        outPrefix = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders")
    log: 
        out = join("logs", "1_qcGWAS", "6_rmNonFounders.out"), 
        err = join("logs", "1_qcGWAS", "6_rmNonFounders.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/rmNonFounders.sh \
            -b {params.bfilePath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """        
        
rule checkFounderRelatedness:
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders.{end}"), 
          end = ["bed", "bim", "fam"]),
        pruneIn = join("results", "1_qcGWAS", "5_het", "HapMap_findInv.prune.in")
    output: 
        outGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2.genome"), 
        outZoomGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2Zoom.genome")
    params: 
        bfilePath = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders"), 
        outPrefix = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2")
    log: 
        out = join("logs", "1_qcGWAS", "6_checkFounderRelatedness.out"), 
        err = join("logs", "1_qcGWAS", "6_checkFounderRelatedness.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/checkRelatedness.sh \
            -b {params.bfilePath} -i {input.pruneIn} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """        

rule checkFounderMissStats:
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders.{end}"), 
          end = ["bed", "bim", "fam"]),
        outGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2.genome"), 
        outZoomGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2Zoom.genome")
    output: 
        plinkStats = expand(join("results", "1_qcGWAS", "6_rel", "plink.{metric}"), 
          metric = ["imiss", "lmiss"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders"), 
        outDir = join("results", "1_qcGWAS", "6_rel")
    log: 
        out = join("logs", "1_qcGWAS", "6_checkFounderMissStats.out"), 
        err = join("logs", "1_qcGWAS", "6_checkFounderMissStats.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/missingStats.sh \
            -b {params.bfilePath} -o {params.outDir} \
            1> {log.out} 2> {log.err}
        """          
        
rule findMissingRelative:
    input: 
        imissPath = join("results", "1_qcGWAS", "6_rel", "plink.imiss"),
        lmissPath = join("results", "1_qcGWAS", "6_rel", "plink.lmiss"), 
        outGenome = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders_pihat0.2.genome")
    output: 
        rmMissingPath = join("results", "1_qcGWAS", "6_rel", "rmMissingRel.txt")
    log: 
        out = join("logs", "1_qcGWAS", "6_findMissingRelative.out"), 
        err = join("logs", "1_qcGWAS", "6_findMissingRelative.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020 r/4.2.1
        R_LIBS_USER="~/R/x86_64-redhat-linux-gnu-library/4.2.1"
        Rscript scripts/findMissingRelative.R 1> {log.out} 2> {log.err}
        """  
        
rule rmMissingRelative:
    input: 
        inPlink = expand(join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders.{end}"), 
          end = ["bed", "bim", "fam"]),
        rmMissingPath = join("results", "1_qcGWAS", "6_rel", "rmMissingRel.txt")
    output: 
        outPlink = expand(join("results", "1_qcGWAS", "6_rel", "HapMap_rmMissRel.{end}"), 
          end = ["bed", "bim", "fam"])
    params: 
        bfilePath = join("results", "1_qcGWAS", "6_rel", "HapMap_rmNonFounders"), 
        outPrefix = join("results", "1_qcGWAS", "6_rel", "HapMap_rmMissRel")
    log: 
        out = join("logs", "1_qcGWAS", "6_rmMissingRelative.out"), 
        err = join("logs", "1_qcGWAS", "6_rmMissingRelative.err")
    resources: 
        mem_mb = 30000, 
        runtime = 100, 
        cpus_per_task = 1, 
        slurm_extra = "--qos=privileged --mail-type=END,FAIL --mail-user=16amz1@queensu.ca"
    shell: 
        """
        module load StdEnv/2020
        module load plink/1.9b_6.21-x86_64
        sh scripts/rmMissingRelative.sh \
            -b {params.bfilePath} -i {input.rmMissingPath} -o {params.outPrefix} \
            1> {log.out} 2> {log.err}
        """        