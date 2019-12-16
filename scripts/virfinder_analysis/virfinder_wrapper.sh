#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH -J virfinder_run
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

# Your commands
Rscript --vanilla virfinder_script.R
