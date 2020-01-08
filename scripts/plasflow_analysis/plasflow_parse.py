# This script parses the results of PlasFlow located in a user specified directory and outputs a 
# csv file containing summary statistics on each bin
# Usage: python plasflow_parse.py /Path/to/PlasFlow/results/directory /Path/to/list/of/bins/in/fOTUs.csv /Path/to/output/file.csv

import pandas as pd
from os import listdir
import sys
import re

file_input_path = sys.argv[1]
bin_fOTU_list_path = sys.argv[2]
file_output_path = sys.argv[3]

plasflow_file_names = listdir(file_input_path)
plasflow_file_names.sort()
bin_fOTU_list = pd.read_csv(bin_fOTU_list_path)
bin_fOTU_list = bin_fOTU_list.sort_values("bin_name")
bin_fOTU_list = bin_fOTU_list.reset_index(drop = True)
plasflow_result_list = []
k = 0

for plasflow_file_name in plasflow_file_names:
    # Iterates through each plasflow result file and computes the size of the bin, the number of
    # contigs present and the fraction of contigs and nucleotides marked as plasmid, chromosome or unclassified
    if re.search("plasflow", plasflow_file_name) and not re.search("chromosome", plasflow_file_name) and not re.search("plasmid", plasflow_file_name) and not re.search("unclassified", plasflow_file_name):
        plasflow_file = pd.read_csv(file_input_path+"/"+plasflow_file_name, sep='\t')
        bin_length = 0
        plas_length = 0
        chrom_length = 0
        num_contigs = len(plasflow_file)
        contig_plas = [False] * len(plasflow_file)
        contig_chrom = [False] * len(plasflow_file)
        i = 0
        while i < num_contigs:
            bin_length += int(plasflow_file.iloc[i,3])
            label = re.split(r"\.", plasflow_file.iloc[i,5])
            if label[0] == "chromosome":
                chrom_length += int(plasflow_file.iloc[i,3])
                contig_chrom[i] = True
            elif label[0] == "plasmid":
                plas_length += int(plasflow_file.iloc[i,3])
                contig_plas[i] = True
            i += 1
        plas_perc = plas_length/bin_length
        chrom_perc = chrom_length/bin_length
        unclass_perc = 1 - (plas_perc + chrom_perc)
        plas_contig_perc = sum(contig_plas)/num_contigs
        chrom_contig_perc = sum(contig_chrom)/num_contigs
        unclass_contig_perc = 1 - (plas_contig_perc + chrom_contig_perc)
        if plas_perc >= 0.5:
            bin_comp = "plasmid"
        elif chrom_perc >= 0.5:
            bin_comp = "bacterial_chromosome"
        elif unclass_perc >= 0.5:
            bin_comp = "unclassified"
        else:
            bin_comp = "mixed"
        result_line = [plasflow_file_name[0:-25], bin_comp, bin_length, plas_perc, chrom_perc, unclass_perc,\
            num_contigs, plas_contig_perc, chrom_contig_perc, unclass_contig_perc, str(bin_fOTU_list.iloc[k,1])]
        plasflow_result_list.append(result_line)
        k += 1

header_list = ["bin_name", "bin_composition", "length", "plasmid_nucleotide_percentage",\
    "chromosome_nucleotide_percentage", "unclassified_nucleotide_percentage", "number_of_contigs",\
    "plasmid_contig_percentage", "chromosome_contig_percentage", "unclassified_contig_percentage",\
    "fOTU_name"]
df = pd.DataFrame(plasflow_result_list, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)


