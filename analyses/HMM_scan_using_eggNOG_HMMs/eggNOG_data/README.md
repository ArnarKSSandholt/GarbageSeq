# Directory contents

This directory contains HMMs and annotation files of all viral data available in EggNOG database v. 5.0.0. The data was downloaded with following bash commands:

```bash
INPUT="../analyses/HMM_scan_using_eggNOG_HMMs/virus_taxids.csv"
URL_ROOT="http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/"
OUTPUT_DIR="../analyses/HMM_scan_using_eggNOG_HMMs/eggnog_data/"
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read taxon_name taxid; do
  # Skip the header row with taxonomic name as the first item
  if [ $taxon_name != "taxonomic name" ]; then
    #echo "Others"
    TAXON=$(echo $taxon_name | sed -e "s/[[:space:]]/_/g")
    # Download annotations files
    wget -c -O "$OUTPUT_DIR""$TAXON""_""$taxid""_annotations.tsv.gz" "$URL_ROOT""$taxid""/""$taxid""_annotations.tsv.gz"
    # Download hmms
    wget -c -O "$OUTPUT_DIR""$TAXON""_""$taxid""_hmms.tar" "$URL_ROOT""$taxid""/""$taxid""_hmms.tar"
  fi
done < $INPUT
IFS=$OLDIFS
```