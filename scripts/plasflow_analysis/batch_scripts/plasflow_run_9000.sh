#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH -J PlasFlow_run_9000
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

module load conda

# Your commands
source conda_init.sh
source activate plasflow

for f in $(head -n 9000 /home/akss94/fOTU_bin_file_list.csv | tail -n 1800 | sed 's/.fna//')
do
PlasFlow.py --input /home/akss94/fOTU_bin_fasta/${f}.fna --output /home/moritz/proj_folder/uppstore2018116/GarbageSeq/analyses/plasflow_results/${f}_plasflow_predictions.tsv --threshold 0.7
done