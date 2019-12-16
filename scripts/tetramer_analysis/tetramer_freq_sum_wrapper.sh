#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH -J tetramer_freq_sum
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

module load python/3.7.2

# Your commands
python3 tetramer_freq_sum.py /home/akss94/tetramer_freq_tables /home/akss94/tetramer_freq_tables/summed_tetramer_freq_table.csv