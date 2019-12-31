#!/usr/bin/awk -f
BEGIN{
    # We want tab delimited output
    OFS = "\t"
}
{
    # force the record to be rebuilt so the record itself will be changed
    $1 = $1
    # and finally, print the processed data into STDOUT
    print $0
}