#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH -J PlasFlow_run_tail
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

module load conda

# Your commands
source conda_init.sh
source activate plasflow

for f in $(ls ~/fOTU_bin_fasta | tail -n 14615 | sed 's/.fna//')
do
PlasFlow.py --input /home/akss94/fOTU_bin_fasta/${f}.fna --output /home/moritz/proj_folder/uppstore2018116/GarbageSeq/analyses/plasflow_results/${f}plasflow_predictions.tsv --threshold 0.7
done