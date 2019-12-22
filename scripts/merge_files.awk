#!/usr/bin/awk -f

# This script creates an array from the first file and prints the 
# rows with same HMMs in another together with the first files data 
BEGIN{
    # We want tsv files in the end...
    OFS = "\t"
    # We know that we have tab delimited files as input...
    FS = "\t"
    # Print tsv header
    print "taxid" FS "HMM" FS "eggNOG_cat" FS "mem_taxid.pfam_id" FS "mem_taxid" FS "description"
}
# Build an (associative) array from the first file
NR==FNR{
        A[$2]=$0;
        next
    }
{
    # We want some more granularity in printing the first file because
    # it'd be nice to print eventual description last in the row/record
    split(A[$2],file1,"\t") # "\t" here is not necessary but let's be explicit here
    if (length(file1[4]) == 0 ){
        print file1[1] FS file1[2] FS file1[3] FS $5 FS $6 FS "NA"
    }else{
        print file1[1] FS file1[2] FS file1[3] FS $5 FS $6 FS file1[4]
    }  
}
