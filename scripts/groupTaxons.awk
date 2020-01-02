#!/usr/bin/awk -f
BEGIN{
    if (length(field) == 0){
        exit(1)
    }
    if (length(header) == 0){
        exit(1)
    }
}
{
    names_field = $field;
    
    if (names_field != header){
        # Exchange "," -> " "
        gsub(",", " ", names_field)
        # Print in one line everything
        printf " %s", names_field
    }
}