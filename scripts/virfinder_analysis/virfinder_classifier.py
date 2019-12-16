# Script for classifying VirFinder output and computing different statistics for it.  

import pandas as pd
from os import listdir
import sys

file_input_path = sys.argv[1]
bin_fOTU_list_path = sys.argv[2]
file_output_path = sys.argv[3]

virfinder_file_names = listdir(file_input_path)
virfinder_file_names.sort()
bin_fOTU_list = pd.read_csv(bin_fOTU_list_path)
bin_fOTU_list = bin_fOTU_list.sort_values("name")
num_virfinder_files = len(virfinder_file_names)
virfinder_result_list = [None] * num_virfinder_files
p_val_threshold = 0.05
k = 0

for virfinder_file_name in virfinder_file_names:
    # Iterates through each VirFinder result file and computes the size of the bin, the number of
    # contigs, the average p-values of both hits and all contigs present and the viral fraction
    # of the bin with respect to both contigs and overall size
    virfinder_file = pd.read_csv(file_input_path+"/"+virfinder_file_name)
    i = 0
    num_contigs = len(virfinder_file)
    viral_contig_list = [False] * num_contigs
    p_val_list = [0] * num_contigs
    p_val_hit_list = []
    viral_nuc_num = 0
    nuc_num = 0
    while i < num_contigs:
        if float(virfinder_file.iloc[i,3]) < p_val_threshold:
            viral_contig_list[i] = True
            viral_nuc_num += int(virfinder_file.iloc[i,1])
            p_val_hit_list.append(float(virfinder_file.iloc[i,3]))
        p_val_list[i] = float(virfinder_file.iloc[i,3])
        nuc_num += int(virfinder_file.iloc[i,1])
        i += 1
    viral_perc = sum(viral_contig_list)/num_contigs
    viral_nuc_perc = viral_nuc_num/nuc_num
    avg_bin_p_val = sum(p_val_list)/num_contigs
    if len(p_val_hit_list)>0:
        avg_hit_p_val = sum(p_val_hit_list)/len(p_val_hit_list)
    else:
        avg_hit_p_val = 0
    if viral_nuc_perc < 0.25:
        viral_cont = "Low"
    elif viral_nuc_perc < 0.5:
        viral_cont = "Medium"
    elif viral_nuc_perc < 0.75:
        viral_cont = "High"
    else:
        viral_cont = "Very_high"
    result_line = [virfinder_file_name[0:-14], nuc_num, num_contigs, viral_cont, viral_perc, viral_nuc_perc, avg_bin_p_val, avg_hit_p_val, str(bin_fOTU_list.iloc[k,1])]
    virfinder_result_list[k] = result_line
    k += 1

header_list = ["bin_name", "length", "number_of_contigs", "viral_content", "percentage_of_viral_contigs", "percentage_of_viral_nucleotides", "average_bin_p_value", "average_hit_p_value", "fOTU_name"]
df = pd.DataFrame(virfinder_result_list, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)