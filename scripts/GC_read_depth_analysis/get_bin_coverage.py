# Calculate average read depth and GC percentage for a set of bins

import pandas as pd
import re

contig_cov_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_contig_coverage.csv"
bin_stat_path = "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins.csv"
bin_cov_path = "/home/arnar/Documents/team_garbageSeq/data/fOTU_bin_coverage.csv"
bin_stat_with_cov_path = "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins_with_cov.csv"

contig_cov_table = pd.read_csv(contig_cov_path)
bin_stat_table = pd.read_csv(bin_stat_path)
bin_stat_table = bin_stat_table.sort_values("name")
bin_stat_table = bin_stat_table.reset_index(drop = True)
cov_list = [None] * len(bin_stat_table)
output_table = [None] * len(bin_stat_table)
bin_name_old = ""
i = 0
j = 0

while i < len(contig_cov_table):
    # Iterates through the three tables, taking advantage of them all being ordered by bin name
    # Extracts GC percentage and coverage data from the respective tables and sums for each bin
    bin_name = re.split(r"[:]", str(contig_cov_table.iloc[i,0]))[0] # Get the current bin name
    if bin_name != bin_name_old:
        # Compare the names of the current and last bin.  If there is a mismatch,
        # create a new list for each value being extracted
        bin_length = int(contig_cov_table.iloc[i,1])
        bin_coverage = [float(contig_cov_table.iloc[i,1]) * float(contig_cov_table.iloc[i,2])]
        i += 1
        if i == len(contig_cov_table) or bin_name != re.split(r"[:]", str(contig_cov_table.iloc[i,0]))[0]:
            # If the name of the next bin does not match the current one, calculate the relevant
            # information for the bin and save it.  For a single contig bin
            average_coverage = sum(bin_coverage)/bin_length
            line = [bin_name, bin_length, average_coverage]
            output_table[j] = line
            cov_list[j] = average_coverage
            j += 1
    else:
        # If there is a match between the current and last bin names, add the information to
        # the current lists
        bin_length += int(contig_cov_table.iloc[i,1])
        bin_coverage.append(float(contig_cov_table.iloc[i,1]) * float(contig_cov_table.iloc[i,2]))
        i += 1
        if i == len(contig_cov_table) or bin_name != re.split(r"[:]", str(contig_cov_table.iloc[i,0]))[0]:
            # If the name of the next bin does not match the current one, calculate the relevant
            # information for the bin and save it.  For a multi contig bin
            average_coverage = sum(bin_coverage)/bin_length
            line = [bin_name, bin_length, average_coverage]
            output_table.append(line)
            output_table[j] = line
            cov_list[j] = average_coverage
            j += 1
    bin_name_old = bin_name

cov_series = pd.Series(cov_list, name = "total_avg_depth")
bin_stat_table = pd.concat([bin_stat_table, cov_series], axis=1)
bin_stat_table.to_csv(bin_stat_with_cov_path, sep = ",", index = False)

df = pd.DataFrame(output_table, columns = ["bin_name", "bin_length", "total_avg_depth"])
df.to_csv(bin_cov_path, sep = ",", index = False)