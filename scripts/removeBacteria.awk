#!/usr/bin/awk -f

function deNAer(field){
    sub("^NA,", "", field)
    return field
}

BEGIN{
    # We want tab delimited output
    OFS = "\t"
}
{
    # The different fields
    HMM = $1
    sci_names = $2
    superkingdoms = $3
    orders = $4
    families = $5
    subfamilies = $6
    genuses = $7
    species = $8
    no_ranks = $9
    phylums = $10
    classes = $11
    unclassified = $12
    lineages = $13
    
    if(match(sci_names,"^Bacteria")){
        # Remove first values from each field except HMM
        sub("^Bacteria;", "", sci_names)
        superkingdoms = deNAer(superkingdoms)
        orders = deNAer(orders)
        families = deNAer(families)
        subfamilies = deNAer(subfamilies)
        genuses = deNAer(genuses)
        sub("^NA;", "", species)
        sub("^cellular organisms,", "", no_ranks)
        phylums = deNAer(phylums)
        classes = deNAer(classes)
        unclassified = deNAer(unclassified)
        sub("^cellular organisms,", "", lineages)
    }
    
    # Reassign correct variables to the fields 
    $2 = sci_names
    $3 = superkingdoms
    $4 = orders
    $5 = families
    $6 = subfamilies
    $7 = genuses
    $8 = species
    $9 = no_ranks
    $10 = phylums
    $11 = classes
    $12 = unclassified
    $13 = lineages

    # force the record to be rebuilt
    $1 = $1
    # and finally, print the processed data into STDOUT
    print $0
    
}