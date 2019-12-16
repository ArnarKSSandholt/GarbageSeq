# Script for summing together the tetramer frequencies of a large set of bins and putting them in a single file
# When running, the first argument should tell the script where to find the tetramer frequency files and the second
# should tell it where to output the results

import pandas as pd
from os import listdir
import sys

file_input_path = sys.argv[1]
file_output_path = sys.argv[2]

tetra_file_names = listdir(file_input_path)
num_tetra_files = len(tetra_file_names)
tetramer_table_list = [None] * num_tetra_files
header_found = False
k = 0

for tetra_file_name in tetra_file_names:
    # Iterates through each tetramer frequency file and saves it into a list
    tetra_file = pd.read_csv(file_input_path+"/"+tetra_file_name)
    if not header_found:
        header_list = ["name"] + list(tetra_file.columns[1:])
        header_found = True
    tetra_freq_list = [tetra_file_name[0:-18]] + [None] * 4**4
    i = 0
    ilen = len(tetra_file)
    while i < ilen:
        j = 1
        jlen = len(tetra_file.iloc[i])
        while j < jlen:
            if not tetra_freq_list[j]:
                tetra_freq_list[j] = int(tetra_file.iloc[i,j])
            else:
                tetra_freq_list[j] += int(tetra_file.iloc[i,j])
            j += 1
        i += 1
    tetramer_table_list[k] = tetra_freq_list
    k += 1

df = pd.DataFrame(tetramer_table_list, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)


