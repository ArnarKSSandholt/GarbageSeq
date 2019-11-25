#!/usr/bin/awk -f
BEGIN{
    # Check if output field separator is given, if not it'll be ","
    if (length(delimiter) == 0){
        delimiter = ","
    }
}
{
    fOTUname = $1
    # Create an array from all bin names belonging to the current fOTU
    numBins = split($2, fOTUbins, ";")
    printf "%s%c%s\n", fOTUname,delimiter,numBins
}