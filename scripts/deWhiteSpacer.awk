#!/usr/bin/awk -f
BEGIN{
    # We want tab delimited output
    OFS = "\t"
}
{
    # Assign human readable names to the fields
    HMM = $1
    all_lineages = $2

    # Let's get rid of leading white space from lineages
    gsub("; ", ";",all_lineages)

    # and finally, print the processed data into STDOUT
    print(HMM,all_lineages)
}