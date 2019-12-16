#!/bin/bash


for f in $(ls ~/fOTU_bin_fasta | sed 's/.fna//')
do
Rscript --vanilla tetramer_freq_bash.R /home/akss94/fOTU_bin_fasta/${f}.fna /home/akss94/tetramer_freq_tables/${f}_tetramer_freq.csv
done