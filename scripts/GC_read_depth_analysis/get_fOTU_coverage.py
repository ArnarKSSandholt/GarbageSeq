# Calculate average coverage and GC percentage for a set of fOTUs.  Calculates the same information
# as get_bin_coverage.py but for whole fOTUs and using the results from that script

import pandas as pd
import re

bin_stat_with_cov_path = "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins_with_cov.csv"
fOTU_stat_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_stats.csv"

bin_table = pd.read_csv(bin_stat_with_cov_path)
bin_table = bin_table.sort_values("fOTU_name")
bin_table = bin_table.reset_index(drop = True)
output_table = []
fOTU_name_old = ""
i = 0

while i < len(bin_table):
    fOTU_name = str(bin_table["fOTU_name"][i])
    if fOTU_name != fOTU_name_old:
        bin_length = int(bin_table["length"][i])
        bin_contigs = int(bin_table["nb_contigs"][i])
        bin_proteins = int(bin_table["nb_proteins"][i])
        bin_coverage = [float(bin_table["length"][i]) * float(bin_table["total_avg_depth"][i])]
        bin_GC = [float(bin_table["length"][i]) * float(bin_table["GC"][i])]
        i += 1
        if i == len(bin_table) or fOTU_name != str(bin_table["fOTU_name"][i]):
            average_coverage = sum(bin_coverage)/bin_length
            fOTU_GC_perc = sum(bin_GC)/bin_length
            line = [fOTU_name, bin_length, bin_contigs, bin_proteins, average_coverage, fOTU_GC_perc]
            output_table.append(line)
    else:
        bin_length += int(bin_table["length"][i])
        bin_contigs += int(bin_table["nb_contigs"][i])
        bin_proteins += int(bin_table["nb_proteins"][i])
        bin_coverage.append(float(bin_table["length"][i]) * float(bin_table["total_avg_depth"][i]))
        bin_GC.append(float(bin_table["length"][i]) * float(bin_table["GC"][i]))
        i += 1
        if i == len(bin_table) or fOTU_name != str(bin_table["fOTU_name"][i]):
            average_coverage = sum(bin_coverage)/bin_length
            fOTU_GC_perc = sum(bin_GC)/bin_length
            line = [fOTU_name, bin_length, bin_contigs, bin_proteins, average_coverage, fOTU_GC_perc]
            output_table.append(line)
    fOTU_name_old = fOTU_name

df = pd.DataFrame(output_table, columns = ["fOTU_name", "length", "nb_contigs", "nb_proteins", "total_avg_depth", "GC"])
df.to_csv(fOTU_stat_path, sep = ",", index = False)