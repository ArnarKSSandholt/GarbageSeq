#!/usr/bin/awk -f
BEGIN{
    # Set a default filtering - log_10 e-value above which everything will be
    # accepted
    if (length(e_val) == 0){
        e_val = 0
    }
}
{
    names_field = $7;
    
    if (names_field != "description"){
        if ($2 >= e_val){
            # Exchange " " -> "_"
            gsub(" ", "_", names_field);
            # Print in one line everything
            printf " %s", names_field;
        }
    }
}