#!/usr/bin/awk -f
BEGIN{
    # Check if there is proteoms directory given, if not exit
    if (length(proteom_dir) == 0){
        exit(1)
    }
    # Check if there is output proteoms directory given, if not exit
    if (length(fOTUproteoms) == 0){
        exit(2)
    }
}
{
    fOTUname = $1
    # Create an array from all bin names belonging to the current fOTU
    numBins = split($2, fOTUbins, ";")

    # Loop through each bin id and append bin contents to fOTU multifasta file
    for (i = 1; i <= numBins; ++i){
        split(fOTUbins[i],binIDs, ":")
        binID = binIDs[2]
        system("cat "proteom_dir""binID".faa >> "fOTUproteoms""fOTUname".faa")
    }
}