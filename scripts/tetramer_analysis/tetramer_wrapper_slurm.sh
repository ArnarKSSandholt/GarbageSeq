#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 3:00:00
#SBATCH -J tetramer_count
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

# Your commands
bash tetramer_wrapper.sh