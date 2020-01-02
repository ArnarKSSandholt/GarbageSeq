#!/usr/bin/awk -f
BEGIN{
    # Define the long names of COG categories
    #_CELLULAR_PROCESSES_AND_SIGNALING
    cogFunCats["D"] = "Cell_cycle_control_cell_division_chromosome_partitioning";
    cogFunCats["M"] = "Cell_wall/membrane/envelope_biogenesis";
    cogFunCats["N"] = "Cell_motility";
    cogFunCats["O"] = "Post-translational_modification_protein_turnover_and_chaperones";
    cogFunCats["T"] = "Signal_transduction_mechanisms";
    cogFunCats["U"] = "Intracellular_trafficking_secretion_and_vesicular_transport";
    cogFunCats["V"] = "Defense_mechanisms";
    cogFunCats["W"] = "Extracellular_structures";
    cogFunCats["Y"] = "Nuclear_structure";
    cogFunCats["Z"] = "Cytoskeleton";
    #_INFORMATION_STORAGE_AND_PROCESSING
    cogFunCats["A"] = "RNA_processing_and_modification";
    cogFunCats["B"] = "Chromatin_structure_and_dynamics";
    cogFunCats["J"] = "Translation_ribosomal_structure_and_biogenesis";
    cogFunCats["K"] = "Transcription";
    cogFunCats["L"] = "Replication_recombination_and_repair";
    #_METABOLISM
    cogFunCats["C"] = "Energy_production_and_conversion";
    cogFunCats["E"] = "Amino_acid_transport_and_metabolism";
    cogFunCats["F"] = "Nucleotide_transport_and_metabolism";
    cogFunCats["G"] = "Carbohydrate_transport_and_metabolism";
    cogFunCats["H"] = "Coenzyme_transport_and_metabolism";
    cogFunCats["I"] = "Lipid_transport_and_metabolism";
    cogFunCats["P"] = "Inorganic_ion_transport_and_metabolism";
    cogFunCats["Q"] = "Secondary_metabolites_biosynthesis_transport_and_catabolism";
    #_POORLY_CHARACTERIZED
    cogFunCats["R"] = "General_function_prediction_only";
    cogFunCats["S"] = "Function_unknown";
}
{
    cogCat = cogFunCats[$4];
    if ($4 != "eggNOG_cat"){
       printf " %s", cogCat
    }
}