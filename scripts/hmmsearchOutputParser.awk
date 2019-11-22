#!/usr/bin/awk -f
# This script parses HMMer 3.2.1 hmmsearch output files match scores for complete sequences
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
    last_field = ""
}
# Match query row first in order to grap the hmm_variant name
/Query:       /{
    split($2,term,"\.")
    hmm_variant = term[1]
    # Move 5 rows ahead
    getline; getline; getline; getline; getline; 
    # Check if the row is not empty, start parsing
    while ($0!=""){
        # Gather upp the last column (Description) into one variable
        for (i = last_col; i <= NF; ++i){
            # Don't need to add space before the first word
            if (i == last_col){
                last_field = $i
            }else{
                # Separate all other words with spaces
                last_field = last_field" "$i
            }
        }
        printf "%s%c", hmm_variant,delimiter
        # Handle the actual printing
        for (i = 1; i < last_col; ++i){
            printf "%s%c", $i,delimiter
        }
        # Append the built last field before printing \n
        printf "%s\n", last_field
        # Move to next line
        getline;
    }
}