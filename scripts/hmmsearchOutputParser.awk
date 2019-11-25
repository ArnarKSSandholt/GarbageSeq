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
        # Print the name of the hmm variant as first column
        printf "%s%c%s%c", hmm_variant,delimiter,inclusion,delimiter
        # Handle the actual printing
        for (i = 1; i < last_col; ++i){
            printf "%s%c", $i,delimiter
        }
        # Append the built last field before printing \n
        printf "%s\n", last_field
        # Move to next line
        getline
    }
}