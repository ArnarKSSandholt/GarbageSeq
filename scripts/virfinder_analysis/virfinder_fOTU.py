# Parses the output of the VirFinder results parser and sums results up for fOTUs

import pandas as pd
import sys

file_input_path = sys.argv[1]
file_output_path = sys.argv[2]

virfinder_bin_class = pd.read_csv(file_input_path)
virfinder_bin_class = virfinder_bin_class.sort_values("fOTU_name")
virfinder_bin_class = virfinder_bin_class.reset_index(drop = True)
fOTU_virfinder_list = []

fOTU_old = ""
i = 0
ilen = len(virfinder_bin_class)
while i < ilen:
    fOTU = virfinder_bin_class["fOTU_name"][i]
    if fOTU != fOTU_old:
        bin_length = [int(virfinder_bin_class["length"][i])]
        bin_contig_num = [int(virfinder_bin_class["number_of_contigs"][i])]
        bin_viral_contigs = [float(virfinder_bin_class["percentage_of_viral_contigs"][i])]
        bin_viral_nucl = [float(virfinder_bin_class["percentage_of_viral_nucleotides"][i])]
        bin_avg_p_val = [float(virfinder_bin_class["average_bin_p_value"][i])]
        bin_hit_p_val = [float(virfinder_bin_class["average_hit_p_value"][i])]
        i += 1
        if i == ilen or fOTU != virfinder_bin_class["fOTU_name"][i]:
            if bin_viral_nucl[0] < 0.25:
                fOTU_viral_cont = "Low"
            elif bin_viral_nucl[0] < 0.5:
                fOTU_viral_cont = "Medium"
            elif bin_viral_nucl[0] < 0.75:
                fOTU_viral_cont = "High"
            else:
                fOTU_viral_cont = "Very_high"
            fOTU_virfinder_list.append([fOTU, bin_length[0], bin_contig_num[0], fOTU_viral_cont, bin_viral_contigs[0], bin_viral_nucl[0], bin_avg_p_val[0], bin_hit_p_val[0]])
    else:
        bin_length.append(int(virfinder_bin_class["length"][i]))
        bin_contig_num.append(int(virfinder_bin_class["number_of_contigs"][i]))
        bin_viral_contigs.append(float(virfinder_bin_class["percentage_of_viral_contigs"][i]))
        bin_viral_nucl.append(float(virfinder_bin_class["percentage_of_viral_nucleotides"][i]))
        bin_avg_p_val.append(float(virfinder_bin_class["average_bin_p_value"][i]))
        bin_hit_p_val.append(float(virfinder_bin_class["average_hit_p_value"][i]))
        i += 1
        if i == ilen or fOTU != virfinder_bin_class["fOTU_name"][i]:
            viral_contig_sum = 0
            viral_nucl_sum = 0
            avg_p_val_sum = 0
            hit_p_val_sum = 0
            j = 0
            jlen = len(bin_length)
            while j < jlen:
                viral_contig_sum += bin_viral_contigs[j] * bin_contig_num[j]
                viral_nucl_sum += bin_length[j] * bin_viral_nucl[j]
                avg_p_val_sum += bin_avg_p_val[j] * bin_contig_num[j]
                hit_p_val_sum += bin_viral_contigs[j] * bin_contig_num[j] * bin_hit_p_val[j]
                j += 1
            fOTU_length = sum(bin_length)
            fOTU_contig_num = sum(bin_contig_num)
            fOTU_viral_contigs = viral_contig_sum/fOTU_contig_num
            fOTU_viral_nucl = viral_nucl_sum/fOTU_length
            fOTU_avg_p_val = avg_p_val_sum/fOTU_contig_num
            if hit_p_val_sum > 0:
                fOTU_hit_p_val = hit_p_val_sum/viral_contig_sum
            else:
                fOTU_hit_p_val = 0
            if fOTU_viral_nucl < 0.25:
                fOTU_viral_cont = "Low"
            elif fOTU_viral_nucl < 0.5:
                fOTU_viral_cont = "Medium"
            elif fOTU_viral_nucl < 0.75:
                fOTU_viral_cont = "High"
            else:
                fOTU_viral_cont = "Very_high"
            fOTU_virfinder_list.append([fOTU, fOTU_length, fOTU_contig_num, fOTU_viral_cont, fOTU_viral_contigs, fOTU_viral_nucl, fOTU_avg_p_val, fOTU_hit_p_val])
    fOTU_old = fOTU

header_list = ["fOTU_name", "length", "number_of_contigs", "viral_content", "percentage_of_viral_contigs", "percentage_of_viral_nucleotides", "average_bin_p_value", "average_hit_p_value"]
df = pd.DataFrame(fOTU_virfinder_list, columns = header_list)
df.to_csv(file_output_path, sep = ",", index = False)