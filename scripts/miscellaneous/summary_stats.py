# Compute summary statistics on each of the HMM clusters

import pandas as pd
import numpy as np
from os import listdir
import sys

file_input_path = sys.argv[1]
file_output_path = sys.argv[2]

stat_file_names = listdir(file_input_path)
stat_file_names.sort()
cluster_stats = []

for stat_file_name in stat_file_names:
    # Compute summary statistics for each file
    stat_file = pd.read_csv(file_input_path+"/"+stat_file_name)

    cluster_size = len(stat_file)
    length_sum = np.sum(stat_file["length"])
    length_quant = np.quantile(stat_file["length"], [0.25,0.5,0.75])
    length_mean = np.mean(stat_file["length"])
    contig_sum = np.sum(stat_file["nb_contigs"])
    contig_quant = np.quantile(stat_file["nb_contigs"], [0.25,0.5,0.75])
    contig_mean = np.mean(stat_file["nb_contigs"])

    GC_perc = np.sum(np.multiply(stat_file["length"],stat_file["GC"]))/length_sum
    avg_read_depth = np.sum(np.multiply(stat_file["length"],stat_file["total_avg_depth"]))/length_sum

    viral_perc = np.sum(np.multiply(stat_file["length"],stat_file["percentage_of_viral_nucleotides"]))/length_sum
    viral_contig_perc = np.sum(np.multiply(stat_file["nb_contigs"],stat_file["percentage_of_viral_contigs"]))/contig_sum
    
    plas_perc = np.sum(np.multiply(stat_file["length"],stat_file["plasmid_nucleotide_percentage"]))/length_sum
    chrom_perc = np.sum(np.multiply(stat_file["length"],stat_file["chromosome_nucleotide_percentage"]))/length_sum
    unclass_perc = np.sum(np.multiply(stat_file["length"],stat_file["unclassified_nucleotide_percentage"]))/length_sum
    plas_contig_perc = np.sum(np.multiply(stat_file["nb_contigs"],stat_file["plasmid_contig_percentage"]))/contig_sum
    chrom_contig_perc = np.sum(np.multiply(stat_file["nb_contigs"],stat_file["chromosome_contig_percentage"]))/contig_sum
    unclass_contig_perc = np.sum(np.multiply(stat_file["nb_contigs"],stat_file["unclassified_contig_percentage"]))/contig_sum
    
    if viral_perc < 0.25:
        cluster_viral_cont = "Low"
    elif viral_perc < 0.5:
        cluster_viral_cont = "Medium"
    elif viral_perc < 0.75:
        cluster_viral_cont = "High"
    else:
        cluster_viral_cont = "Very_high"
    
    if plas_perc >= 0.5:
        bin_comp = "plasmid"
    elif chrom_perc >= 0.5:
        bin_comp = "bacterial_chromosome"
    elif unclass_perc >= 0.5:
        bin_comp = "unclassified"
    else:
        bin_comp = "mixed"
    
    cluster_stats.append([stat_file_name[0:-16], cluster_size, length_sum, contig_sum, cluster_viral_cont, bin_comp,\
        GC_perc, avg_read_depth, length_mean, length_quant[0], length_quant[1], length_quant[2], contig_mean, contig_quant[0],\
        contig_quant[1], contig_quant[2], viral_perc, viral_contig_perc, plas_perc, chrom_perc, unclass_perc,\
        plas_contig_perc, chrom_contig_perc, unclass_contig_perc])

header_list = ["Cluster_name", "Number_of_fOTUs", "Total_length", "Total_number_of_contigs", "VirFinder_viral_content",\
    "PlasFlow_plasmid_content", "GC_percentage", "Total_average_read_depth", "Mean_fOTU_length", "fOTU_length_1st_quartile",\
    "fOTU_length_2nd_quartile", "fOTU_length_3rd_quartile", "Mean_fOTU_contig_number", "fOTU_contig_number_1st_quartile",\
    "fOTU_contig_number_2nd_quartile", "fOTU_contig_number_3rd_quartile", "Percentage_of_VirFinder_viral_nucleotides",\
    "Percentage_of_VirFinder_viral_contigs", "Percentage_of_PlasFlow_plasmid_nucleotides", "Percentage_of_PlasFlow_chromosomal_nucleotides",\
    "Percentage_of_PlasFlow_unclassified_nucleotides", "Percentage_of_PlasFlow_plasmid_contigs", "Percentage_of_PlasFlow_chromosomal_contigs",\
    "Percentage_of_PlasFlow_unclassified_contigs"]

df = pd.DataFrame(cluster_stats, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)
    



