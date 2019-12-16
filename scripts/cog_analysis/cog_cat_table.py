# Parse a set of eggNOGmapper annotation files and output a table showing the COG categories present in each
# Run command:  python cog_cat_table.py /Path/to/input/file.csv /Path/to/output/file.csv

import pandas as pd
from os import listdir
import sys
import re

file_input_path = sys.argv[1]
file_output_path = sys.argv[2]

# List the different COG categories for comparison and use as header for the output table
cog_cat_file_names = listdir(file_input_path)
cog_cat_bin_list = []
cog_cat_list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "Y", "Z"]

for cog_cat_file_path in cog_cat_file_names:
    # Read each annotation file and extract COG categories
    if re.search("annotations", cog_cat_file_path): # Make sure it only reads annotation files
        cog_table = pd.read_csv(file_input_path + "/" + cog_cat_file_path, header = None, sep='\t', skiprows = 4, \
            names = ["query_name","seed_eggNOG_ortholog","seed_ortholog_evalue", "seed_ortholog_score",\
            "best_tax_level","Preferred_name","GOs","EC","KEGG__ko","KEGG_Pathway","KEGG_Module",\
            "KEGG_Reaction","KEGG_rclass","BRITE","KEGG_TC","CAZy","BiGG_Reaction","tax_scope",\
            "eggNOG_OGs","bestOG","COG_Functional_Category","eggNOG_free_text_description"])
        cog_cat_presence = [0]*len(cog_cat_list)
        i = 0
        cog_num = len(cog_table) - 3  # The last 3 lines in the annotation files contain metadata
        while i < cog_num:
            # Go through each entry, find every COG category it's in and extract it
            # If there is no category entry, it defaults to S: Unknown function
            j = 0
            k = False
            while j < len(cog_cat_list):
                for cat in str(cog_table.iloc[i,-2]):
                    if cat == cog_cat_list[j]:
                        cog_cat_presence[j] += 1
                        k = True
                j += 1
                if j == len(cog_cat_list) and not k:
                    cog_cat_presence[18] += 1
            i += 1
        bin_cog_cats = [cog_cat_file_path[0:-20]] + cog_cat_presence + [cog_num]
        cog_cat_bin_list.append(bin_cog_cats)

header = ["bin_name"] + cog_cat_list + ["number_of_cogs_in_bin"]
df = pd.DataFrame(cog_cat_bin_list, columns = header)
df.to_csv(file_output_path, sep = ",", index = False)


