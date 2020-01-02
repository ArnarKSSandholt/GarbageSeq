#!/usr/bin/awk -f
{
    names_field = $7;
    
    if (names_field != "description"){
        # Exchange " " -> "_"
        gsub(" ", "_", names_field);
        # Print in one line everything
        printf " %s", names_field;
    }
}