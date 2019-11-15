# Directory contents

This directory contains output from running HMMer with profile HMMs built from eggnogg mapper annotated viral proteins against all the proteins in each fOTU.

The command used for producing the results was:

```bash
hmmsearch --cpu 4 -o "$HMMer_OUTPUT_DIR""out/""$fOTU""_""$VIR_CATEGORY"".out" -A "$HMMer_OUTPUT_DIR""alns/""$fOTU""$VIR_CATEGORY"".aln.out" --tblout "$HMMer_OUTPUT_DIR""tblout/""$fOTU""$VIR_CATEGORY"".tbl.out" --domtblout "$HMMer_OUTPUT_DIR""domtblout/""$fOTU""$VIR_CATEGORY"".domtbl.out" --pfamtblout "$HMMer_OUTPUT_DIR""pfamtblout/""$fOTU""$VIR_CATEGORY"".pfamtbl.out" "$VIRUS_HMMs_DIR""$VIR_HMM_FILE" "$fOTUproteoms_DIR""$fOTU_FILE"
```