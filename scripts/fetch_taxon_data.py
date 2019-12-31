#!/usr/bin/python3

# This script reads from STDIN a comma separated list of HMM and 
# taxids of viruses containing the proteins contributing to the particular HMM
# It outputs into STDOUT the current eggNOG v. 5.0 HMM id and the taxonomic

import sys
from Bio import Entrez

# This function takes in a list with taxonomic data and returns 
# a tuple with predefined order
def find_taxons(taxonomic_list):
    # Define default values
    superkingdom = "NA"
    order = "NA"
    family = "NA"
    subfamily = "NA"
    genus = "NA"
    species = "NA"
    no_rank = "NA"
    tclass = "NA"
    phylum = "NA"
    unclassified = "NA"
    # Loop through the list of taxonomic levels returned from NCBI 
    # and find out which sort of list item each of them are
    for taxonomic_level in taxonomic_list:
        if (taxonomic_level["Rank"] == "superkingdom"):
            superkingdom = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "order"):
            order = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "family"):
            family = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "subfamily"):
            subfamily = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "genus"):
            genus = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "species"):
            species = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "no rank"):
            no_rank = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "class"):
            tclass = taxonomic_level["ScientificName"]
        elif (taxonomic_level["Rank"] == "phylum"):
            phylum = taxonomic_level["ScientificName"]
        else:
            # If nothing else matched add unclassified instead
            unclassified = "unclassified"
    # Finally return a tuple in a nice order
    return (superkingdom,order,family,subfamily,genus,species,no_rank,tclass,phylum,unclassified)



Entrez.email = "lauri.mesilaakso.5423@student.uu.se"
Entrez.tool = "Local_script_for_determining_which_viruses_are_contributing_to_HMMs_used"
for line in sys.stdin:
    # Strip the new line characters from the end of each line and create a list out of them
    line = line.rstrip().split(",")
    HMM = line[0]
    taxids = line[1:]
    # Send list of taxids to NCBI and retrieve webenv and query key
    search_results = Entrez.read(Entrez.epost("taxonomy", id=",".join(taxids)))
    webenv = search_results["WebEnv"]
    q_key = search_results["QueryKey"]
    # Use the retrieved webenv and query key for fetching the data
    handle = Entrez.efetch(db="taxonomy", id=line, rettype="null", retmode="xml", WebEnv=webenv, query_key=q_key)
    # Parse the retrieved xml data
    ret_data = Entrez.read(handle)
    #print(ret_data)
    
    # Initialise/Reset the list for each new input line
    lineages = list()
    # Tuple for holding taxonomic data
    LineageEx_tuple = ()
    # Scientific names of each virus 
    sci_names = list()

    # Detailed taxonomic data initialised
    superkingdoms = list()
    orders = list()
    families = list()
    subfamilies = list()
    genuses = list()
    species = list()
    no_ranks = list()
    classes = list()
    phylums = list()
    unclassified = list()

    # Iterate over the list of taxons
    for taxon in ret_data:
        # Gather up a list of lineages of each taxon
        lineages.append(taxon["Lineage"])
        # Retrieve the taxonomic data into a tuple
        if "LineageEx" in taxon:
            LineageEx_tuple = find_taxons(taxon["LineageEx"])
        else:
            LineageEx_tuple = ("NA","NA","NA","NA","NA","NA","NA","NA","NA","NA")
        #print(LineageEx_tuple)
        # Append 
        superkingdoms.append(LineageEx_tuple[0])
        orders.append(LineageEx_tuple[1])
        families.append(LineageEx_tuple[2])
        subfamilies.append(LineageEx_tuple[3])
        genuses.append(LineageEx_tuple[4])
        species.append(LineageEx_tuple[5])
        no_ranks.append(LineageEx_tuple[6])
        phylums.append(LineageEx_tuple[7])
        classes.append(LineageEx_tuple[8])
        unclassified.append(LineageEx_tuple[9])
        # Scientific names
        sci_names.append(taxon["ScientificName"])

    # Create one continuos string out of the lists
    lineages_str = ",".join(lineages)
    sci_names_str = ";".join(sci_names)
    superkingdoms_str = ",".join(superkingdoms)
    orders_str = ",".join(orders)
    families_str = ",".join(families)
    subfamilies_str = ",".join(subfamilies)
    genuses_str = ",".join(genuses)
    species_str = ";".join(species)
    no_ranks_str = ",".join(no_ranks)
    phylums_str = ",".join(phylums)
    classes_str = ",".join(classes)
    unclassified_str = ",".join(unclassified)

    print(HMM + "@" + sci_names_str + "@" + superkingdoms_str + "@" + orders_str + "@" + families_str + "@" + subfamilies_str + "@" + genuses_str + "@" + species_str + "@" + no_ranks_str + "@" + phylums_str + "@" + classes_str + "@" + unclassified_str + "@" + lineages_str)
