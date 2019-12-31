#!/usr/bin/awk -f
BEGIN{
    # We want tab delimited output
    OFS = "\t"
}
{
    # Assign lineages field to a variable
    lineages = $13 
    # Let's get rid of leading white space from lineages
    gsub("; ", ";", lineages)
    # Reassign the deWhitespaced lineages back to its original field
    $13 = lineages
    # force the record to be rebuilt
    $1 = $1
    # and finally, print the processed data into STDOUT
    print $0
}