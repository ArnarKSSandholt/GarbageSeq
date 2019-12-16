# Extracts the read depth and contig length data from map_table_subset.tsv only for the 
# bins present in fOTU_bin_name_list.csv

import pandas as pd
import re

name_list_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_bin_name_list.csv"
info_table_path = "/home/arnar/Documents/team_garbageSeq/data/map_table_subset.tsv"
output_table_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_contig_coverage.csv"

name_list = pd.read_csv(name_list_path)
info_table = pd.read_csv(info_table_path, sep="\t")
output_table = []
i = 0
j = 0

while i < len(name_list):
    # Iterates through both tables and extracts mapping data when a match is found
    while True:
        if re.search(name_list.iloc[i,0], info_table.iloc[j,0]):
            # Use regex to match since there might not be an exact match
            column = []
            for val in info_table.iloc[j]:
                column.append(val)
            output_table.append(column)
            j += 1
            if not re.search(name_list.iloc[i,0], info_table.iloc[j,0]):
                break
        else:
            j += 1
    i += 1

df = pd.DataFrame(output_table, columns = ["contig_name", "contig_length", "total_avg_depth"])
df.to_csv(output_table_path, sep = ",", index = False)