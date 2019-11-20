#!/usr/bin/awk -f
{
    # Check if the url root is given, if not exit
    if (length(url) == 0){
        exit(1)
    }
    # Check if output directory root for the downloads is given, if not exit
    if (length(output) == 0){
        exit(2)
    }
    # Give meaningful names to the fields
    taxon = $1
    taxid = $2

    # Substitute white spaces in 1st field with underscores
    gsub(" ","_",taxon)
    
    # Run the downloading of the data with wget command
    system("wget -c -O "output""taxon"_"taxid"_annotations.tsv.gz "url""taxid"/"taxid"_annotations.tsv.gz")
    system("wget -c -O "output""taxon"_"taxid"_hmms.tar "url""taxid"/"taxid"_hmms.tar")
    
    # Some testing here
    #system("echo "output""taxon"_"taxid"_annotations.tsv.gz "url""taxid"/"taxid"_annotations.tsv.gz")
    #system("echo "output""taxon"_"taxid"_hmms.tar "url""taxid"/"taxid"_hmms.tar")
    #print(taxon)
    #print(url)
    #print(output)
}