#!/usr/bin/awk -f
{
    # Check if there is output proteoms directory given, if not exit
    if (length(url) == 0){
        exit(1)
    }
    # Check if there is output proteoms directory given, if not exit
    if (length(output) == 0){
        exit(2)
    }

    taxon = $1
    taxid = $2

    # Let's substitute the white spaces with underscore in the first fields
    gsub(" ","_",taxon)
    
    system("wget -c -O "output""taxon"_"taxid"_annotations.tsv.gz "url""taxid"/"taxid"_annotations.tsv.gz")
    system("wget -c -O "output""taxon"_"taxid"_hmms.tar "url""taxid"/"taxid"_hmms.tar")

    #system("echo "output""taxon"_"taxid"_annotations.tsv.gz "url""taxid"/"taxid"_annotations.tsv.gz")
    #system("echo "output""taxon"_"taxid"_hmms.tar "url""taxid"/"taxid"_hmms.tar")
    #print(taxon)
    #print(url)
    #print(output)
}