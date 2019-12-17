#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -t 96:00:00
#SBATCH -p core -n 5
#SBATCH -o hmmer-%j.out
#SBATCH -J hmmer-viral-search
#SBATCH --mail-type=ALL
#SBATCH --mail-user ""

module load bioinfo-tools
module load hmmer/3.2.1

DATA="../analyses/HMMsearch/eggNOG_data/HMMs/10239/"
fOTUproteoms_DIR="../analyses/fOTU_proteomes1/"
HMMer_OUTPUT_DIR="../analyses/HMMsearch/hmmsearch_out_viruses/"
TAXID_NO="10239"

read -r -a fOTUproteoms <<< $( find $fOTUproteoms_DIR -name "*.faa" -and -type f -print0 | xargs -0 echo )
read -r -a HMMs <<< $( find $DATA -name "*.hmm" -and -type f -print0 | xargs -0 echo )

for fOTUproteom in "${fOTUproteoms[@]}"; do
  #fOTU_FILE=$(echo $(basename "$fOTUproteom"))
  fOTU=$(echo $(basename "$fOTUproteom") | awk -F "." '{print $1}')
  for HMM in "${HMMs[@]}"; do
    #HMM_FILE=$(echo $(basename "$HMM"))
    HMM_VARIANT=$(echo $(basename "$HMM") | awk -F "." '{print $1}')
    hmmsearch --cpu 5 --noali --notextw -E 0.1 --domE 0.1 --incE 0.01 --incdomE 0.01 "$HMM" "$fOTUproteom" >> "$HMMer_OUTPUT_DIR""$TAXID_NO""-with-""$fOTU"".out"
  done
done
