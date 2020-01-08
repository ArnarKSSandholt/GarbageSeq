#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH -J plasflow_parse
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

module load python/3.7.2

# Your commands
python3 plasflow_parse.py /home/moritz/proj_folder/uppstore2018116/GarbageSeq/analyses/plasflow_results /home/akss94/bin_fOTU_list.csv /home/akss94/plasflow_class_bin.csv