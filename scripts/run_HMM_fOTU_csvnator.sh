#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -t 24:00:00
#SBATCH -p core -n 2
#SBATCH -o HMM_fOTU_csvnator-%j.out
#SBATCH -J HMM-fOTU-csv-creating
#SBATCH --mail-type=ALL
#SBATCH --mail-user ""

module load bioinfo-tools
module load R/3.6.1

DATA="../analyses/HMMsearch/hmmsearch_out_parsed/"
HMM_fOTU_OUTPUT_DIR="../analyses/HMMsearch/"

Rscript HMM_fOTU_csvnator.R     \
        --pathToParsed="$DATA" \
        --pathToOutput="$HMM_fOTU_OUTPUT_DIR" 
