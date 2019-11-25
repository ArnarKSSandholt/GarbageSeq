#!/usr/bin/awk -f

# This script assumes that the last field in each record is a "difficult one", 
# i.e. has several words that might tend to normally be parsed as separate fields
BEGIN{
    # Check if output field separator is given, if not it'll be ","
    if (length(delimiter) == 0){
        OFS = "," # This is required for print($0)
        delimiter = ","
    }else{
        OFS = delimiter
    }
    # Check if last column position is given, if not use NF
    # last_col determines which field is the "difficult to parse"-one
    if (length(last_col) == 0){
        last_col = NF
    }
    # If no file name is given, exit
    if (length(filename) == 0){
        exit(1)
    }

    last_field = ""
    # Parse out fOTU name from e.g. 10239-with-cogOTU_1165.out
    split(filename,nameData,"-with-")
    split(nameData[2],fOTUnameData,".")
    fOTU = fOTUnameData[1]
}
/Query:       /{
    # Reset variable keeping track of if the hit is inside the inclusion threshold
    # inclusion = 1 --- is inside
    # inclusion = 2 --- is NOT inside
    inclusion = 1
    split($2,term,"\.")
    hmm_variant = term[1]
    #print hmm_variant
    # Move 5 rows ahead
    getline; getline; getline; getline; getline; 
    # Check if the row is not empty, start parsing
    while ($0!=""){
        # Skip inclusion threshold lines
        if ($0=="  ------ inclusion threshold ------"){
            getline
            inclusion = 2
        }
        # Gather the last field into one variable
        for (i = last_col; i <= NF; ++i){
            # Don't need to add space before the first word
            if (i == last_col){
                last_field = $i
            }else{
                # Separate all other words with spaces
                last_field = last_field" "$i
            }
        }
        # Split bin name and the sequence identifier, 
        # e.g. Loc090721-8m_megahit_metabat_bin-060_00849 -> "Loc090721-8m_megahit_metabat_bin-060" and "00849"
        # and print them separately
        binInfoSeqID = $9 
        numElements = split(binInfoSeqID,binInfoSeqIDArray,"_")
        # The last element is always the sequence identifier in the bin file
        seqID = binInfoSeqIDArray[numElements]
        # The rest is the bin identifier and the sequence identifier can be
        # replaced by empty string (removed)
        sub("_"seqID,"",binInfoSeqID)
        binInfo = binInfoSeqID
        # Print first: fOTU name, hmm variant, if the match was included according to hmmer, bin ID and sequence ID
        printf "%s%c%s%c%s%c%s%c%s%c", fOTU,delimiter,hmm_variant,delimiter,inclusion,delimiter,binInfo,delimiter,seqID,delimiter
        # Handle the actual printing apart from the last two fields/columns
        for (i = 1; i < last_col-1; ++i){
            printf "%s%c", $i,delimiter
        }
        # Append the built last field before printing \n
        printf "%s\n", last_field
        # Move to next line
        getline
    }
}