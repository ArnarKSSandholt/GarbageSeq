#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 48:00:00
#SBATCH -J roary_run
#SBATCH --mail-type=ALL
#SBATCH --mail-user arnarkari.sigurearsonsandholt.9531@student.uu.se

module load bioinfo-tools
module load Roary/3.12.0

for f in $(ls /home/akss94/gff_files)
do
roary -e -i 80 -p 8 -f /home/akss94/roary_results/${f} /home/akss94/gff_files/${f}/*.gff
done
