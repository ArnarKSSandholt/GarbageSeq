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

# Where is the parsed input data located?
DATA="../analyses/HMMsearch/hmmsearch_out_parsed/"
# Define where my R libraries are located
R_LIBS_USER="/home/lame5423/R/x86_64-redhat-linux-gnu-library/3.6/"
# Are we taking the average or the maximum -log e-value?
MODE="max"
# The libraries location must be exported so it's visible for the R script
export R_LIBS_USER

HMM_fOTU_OUTPUT_DIR="../analyses/HMMsearch/"

Rscript HMM_fOTU_csvnator.R     \
        --pathToParsed="$DATA" \
        --pathToOutput="$HMM_fOTU_OUTPUT_DIR" \
        --maxOrAvg="$MODE"