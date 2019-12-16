# Normalize the tetramer frequencies across each sample in summed_tetramer_freq.csv, giving fractions rather than counts

import pandas as pd
import sys

tetra_file_path = sys.argv[1]
norm_file_path = sys.argv[2]

tetra_table = pd.read_csv(tetra_file_path)
ilen = len(tetra_table)
norm_list = [None] * ilen
i = 0

while i < ilen:
    j = 1
    jlen = len(tetra_table.iloc[i])
    sum = None
    while j < jlen:
        if not sum:
            sum = int(tetra_table.iloc[i,j])
        else:
            sum += int(tetra_table.iloc[i,j])
        j += 1
    bin_tetra_freq = [str(tetra_table.iloc[i,0])] + [None] * (len(tetra_table.iloc[i])-1)
    k = 1
    while k < jlen:
        bin_tetra_freq[k] = int(tetra_table.iloc[i,k])/sum
        k += 1
    norm_list[i] = bin_tetra_freq
    i += 1

df = pd.DataFrame(norm_list, columns = list(tetra_table.columns))
df.to_csv(norm_file_path, sep = ",", index = False)
