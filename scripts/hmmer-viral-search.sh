#!/bin/bash -l

#SBATCH -A snic2019-3-22
#SBATCH -t 70:00:00
#SBATCH -p core -n 10
#SBATCH -o hmmer-%j.out
#SBATCH -J hmmer-viral-search
#SBATCH --mail-type=ALL
#SBATCH --mail-user ""

module load bioinfo-tools
module load hmmer/3.2.1

DATA="../analyses/HMM_scan_using_eggNOG_HMMs/eggNOG_data/HMMs/"
fOTUproteoms_DIR="../analyses/fOTU_proteomes/"
HMMer_OUTPUT_DIR="../analyses/HMM_scan_using_eggNOG_HMMs/hmmsearch_out_viruses/"


read -r -a fOTUproteoms <<< $( find $fOTUproteoms_DIR -name "*.faa" -and -type f -print0 | xargs -0 echo )
# Take time of this run
#SECONDS=0
for TAXID in $DATA*/ ; do
  TAXID_NO=$(echo "$TAXID" | awk -F "/" '{print $(NF-1)}')
  read -r -a HMMs <<< $( find $TAXID -name "*.hmm" -and -type f -print0 | xargs -0 echo )
  for HMM in "${HMMs[@]}"; do
    HMM_FILE=$(echo $(basename "$HMM"))
    HMM_VARIANT=$(echo $(basename "$HMM") | awk -F "." '{print $1}')
    for fOTUproteom in "${fOTUproteoms[@]}"; do
      fOTU_FILE=$(echo $(basename "$fOTUproteom"))
      fOTU=$(echo $(basename "$fOTUproteom") | awk -F "." '{print $1}')
      hmmsearch --cpu 10 --noali --notextw -E 0.1 --domE 0.1 --incE 0.01 --incdomE 0.01 "$HMM" "$fOTUproteom" >> "$HMMer_OUTPUT_DIR""$TAXID_NO""-with-""$fOTU"".out"
    done
  done
done
#duration=$SECONDS
#echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
