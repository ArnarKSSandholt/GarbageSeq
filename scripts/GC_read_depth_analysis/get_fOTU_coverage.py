# Calculate average coverage and GC percentage for a set of fOTUs.  Calculates the same information
# as get_bin_coverage.py but for whole fOTUs and using the results from that script

import pandas as pd
import re

bin_stat_with_cov_path = "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins_with_cov.csv"
fOTU_stat_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_stats.csv"

bin_table = pd.read_csv(bin_stat_with_cov_path)
bin_table = bin_table.sort_values("fOTU")
output_table = []
fOTU_name_old = ""
i = 0

while i < len(bin_table):
    fOTU_name = str(bin_table.iloc[i,7])
    if fOTU_name != fOTU_name_old:
        bin_length = int(bin_table.iloc[i,1])
        bin_coverage = [float(bin_table.iloc[i,1]) * float(bin_table.iloc[i,8])]
        bin_GC = [float(bin_table.iloc[i,1]) * float(bin_table.iloc[i,5])]
        i += 1
        if i == len(bin_table) or fOTU_name != str(bin_table.iloc[i,7]):
            average_coverage = sum(bin_coverage)/bin_length
            fOTU_GC_perc = sum(bin_GC)/bin_length
            line = [fOTU_name, bin_length, average_coverage, fOTU_GC_perc]
            output_table.append(line)
    else:
        bin_length += int(bin_table.iloc[i,1])
        bin_coverage.append(float(bin_table.iloc[i,1]) * float(bin_table.iloc[i,8]))
        bin_GC.append(float(bin_table.iloc[i,1]) * float(bin_table.iloc[i,5]))
        i += 1
        if i == len(bin_table) or fOTU_name != str(bin_table.iloc[i,7]):
            average_coverage = sum(bin_coverage)/bin_length
            fOTU_GC_perc = sum(bin_GC)/bin_length
            line = [fOTU_name, bin_length, average_coverage, fOTU_GC_perc]
            output_table.append(line)
    fOTU_name_old = fOTU_name

df = pd.DataFrame(output_table, columns = ["fOTU_name", "length", "total_avg_depth", "GC"])
df.to_csv(fOTU_stat_path, sep = ",", index = False)