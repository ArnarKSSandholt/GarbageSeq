# Concatenate the results of PlasFlow and VirFinder and the general metadata available
# into one table.  Also drops any non-unique columns.

import pandas as pd
import sys

virfinder_results_path = sys.argv[1]
plasflow_results_path = sys.argv[2]
meta_file_path = sys.argv[3]
output_file_path = sys.argv[4]

virfinder_results_table = pd.read_csv(virfinder_results_path)
plasflow_results_table = pd.read_csv(plasflow_results_path)
meta_table = pd.read_csv(meta_file_path)

temp_table = pd.merge(meta_table, virfinder_results_table, on = "fOTU_name")
concat_table = pd.merge(temp_table, plasflow_results_table, on = "fOTU_name")

concat_table.drop(columns = ["length_y", "length", "number_of_contigs_x", "number_of_contigs_y"], inplace = True) # Dropping non-unique columns
concat_table.rename(columns = {'length_x':'length'}, inplace = True) 

concat_table.to_csv(output_file_path, sep = ",", index = False)