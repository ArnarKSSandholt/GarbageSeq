# Parses the results for the PlasFlow parser and adds up the results for each fOTU

import pandas as pd
import sys

file_input_path = sys.argv[1]
file_output_path = sys.argv[2]

plasflow_bin_class = pd.read_csv(file_input_path)
plasflow_bin_class = plasflow_bin_class.sort_values("fOTU_name")
plasflow_bin_class = plasflow_bin_class.reset_index(drop = True)
fOTU_plasflow_list = []
fOTU_old = ""
i = 0
ilen = len(plasflow_bin_class)

while i < ilen:
    fOTU = plasflow_bin_class["fOTU_name"][i]
    if fOTU != fOTU_old:
        bin_length = [int(plasflow_bin_class["length"][i])]
        bin_contig_num = [int(plasflow_bin_class["number_of_contigs"][i])]
        bin_plas_perc = [float(plasflow_bin_class["plasmid_nucleotide_percentage"][i])]
        bin_chrom_perc = [float(plasflow_bin_class["chromosome_nucleotide_percentage"][i])]
        bin_unclass_perc = [float(plasflow_bin_class["unclassified_nucleotide_percentage"][i])]
        bin_plas_contig_perc = [float(plasflow_bin_class["plasmid_contig_percentage"][i])]
        bin_chrom_contig_perc = [float(plasflow_bin_class["chromosome_contig_percentage"][i])]
        bin_unclass_contig_perc = [float(plasflow_bin_class["unclassified_contig_percentage"][i])]
        i += 1
        if i == ilen or fOTU != plasflow_bin_class["fOTU_name"][i]:
            if bin_plas_perc[0] >= 0.5:
                bin_comp = "plasmid"
            elif bin_chrom_perc[0] >= 0.5:
                bin_comp = "bacterial_chromosome"
            elif bin_unclass_perc[0] >= 0.5:
                bin_comp = "unclassified"
            else:
                bin_comp = "mixed"
            fOTU_plasflow_list.append([fOTU, bin_comp, bin_length[0], bin_plas_perc[0], bin_chrom_perc[0], bin_unclass_perc[0], bin_contig_num[0], bin_plas_contig_perc, bin_chrom_contig_perc, bin_unclass_contig_perc])
    else:
        bin_length.append(int(plasflow_bin_class["length"][i]))
        bin_contig_num.append(int(plasflow_bin_class["number_of_contigs"][i]))
        bin_plas_perc.append(float(plasflow_bin_class["plasmid_nucleotide_percentage"][i]))
        bin_chrom_perc.append(float(plasflow_bin_class["chromosome_nucleotide_percentage"][i]))
        bin_plas_contig_perc.append(float(plasflow_bin_class["plasmid_contig_percentage"][i]))
        bin_chrom_contig_perc.append(float(plasflow_bin_class["chromosome_contig_percentage"][i]))
        i += 1
        if i == ilen or fOTU != plasflow_bin_class["fOTU_name"][i]:
            plas_contig_sum = 0
            plas_sum = 0
            chrom_contig_sum = 0
            chrom_sum = 0
            j = 0
            jlen = len(bin_length)
            while j < jlen:
                plas_contig_sum += bin_plas_contig_perc[j] * bin_contig_num[j]
                plas_sum += bin_length[j] * bin_plas_perc[j]
                chrom_contig_sum += bin_chrom_contig_perc[j] * bin_contig_num[j]
                chrom_sum += bin_length[j] * bin_chrom_perc[j]
                j += 1
            fOTU_length = sum(bin_length)
            fOTU_contig_num = sum(bin_contig_num)
            fOTU_plas_contigs = plas_contig_sum/fOTU_contig_num
            fOTU_plas_perc = plas_sum/fOTU_length
            fOTU_chrom_contigs = chrom_contig_sum/fOTU_contig_num
            fOTU_chrom_perc = chrom_sum/fOTU_length
            fOTU_unclass_contigs = 1 - (fOTU_plas_contigs + fOTU_chrom_contigs)
            fOTU_unclass_perc = 1 - (fOTU_plas_perc + fOTU_chrom_perc)
            if fOTU_plas_perc >= 0.5:
                bin_comp = "plasmid"
            elif fOTU_chrom_perc >= 0.5:
                bin_comp = "bacterial_chromosome"
            elif fOTU_unclass_perc >= 0.5:
                bin_comp = "unclassified"
            else:
                bin_comp = "mixed"
            fOTU_plasflow_list.append([fOTU, bin_comp, fOTU_length, fOTU_plas_perc, fOTU_chrom_perc, \
                fOTU_unclass_perc, fOTU_contig_num, fOTU_plas_contigs, fOTU_chrom_contigs, fOTU_unclass_contigs])
    fOTU_old = fOTU

header_list = ["fOTU_name", "fOTU_composition", "length", "plasmid_nucleotide_percentage",\
    "chromosome_nucleotide_percentage", "unclassified_nucleotide_percentage", "number_of_contigs",\
    "plasmid_contig_percentage", "chromosome_contig_percentage", "unclassified_contig_percentage"]
df = pd.DataFrame(fOTU_plasflow_list, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)