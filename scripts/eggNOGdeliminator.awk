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
}
{
    # Define last field as empty string for starters...
    last_field = ""
    if (NF <= last_col){
        # There is no last column or the last column is only one word
        $1=$1 # https://www.gnu.org/software/gawk/manual/gawk.html#Changing-Fields
        print($0)
    }else if (NF > last_col ){
        # There are several words in the last column
        for (i = last_col; i <= NF; ++i){
            # Don't need to add space before the first word
            if (i == last_col){
                last_field = $i
            }else{
                # Separate all other words with spaces
                last_field = last_field" "$i
            }
        }
        # Handle the actual printing
        for (i = 1; i < last_col; ++i){
            printf "%s%c", $i,delimiter
        }
        # Append the built last field before printing \n
        printf "%s\n", last_field
    }else{
        print("Something is off here... exiting.")
        exit(2)
    }
}