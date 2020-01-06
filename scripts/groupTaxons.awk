#!/usr/bin/awk -f
BEGIN{
    # Field number is necessary so that this script can be used for several
    # purposes
    if (length(field) == 0){
        exit(1)
    }
    # Header is used so that they will be not included in the output text
    if (length(header) == 0){
        exit(1)
    }
    # Set a default filtering - log_10 e-value above which everything will be
    # accepted
    if (length(e_val) == 0){
        e_val = 0
    }
}
{
    names_field = $field;
    
    # Filter away the tsv file headers
    if (names_field != header){
        # Filter by e-value 
        if ($2 >= e_val){
            # Exchange "," -> " "
            gsub(",", " ", names_field)
            # Print in one line everything
            printf " %s", names_field
        }
    }
}