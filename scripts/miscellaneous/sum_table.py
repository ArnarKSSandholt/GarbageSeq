# Takes a csv table as input and sums all numerical entries based on a user specified column
# Usage: python sum_table.py /Path/to/input/file.csv group_by_column_name /Path/to/output/file.csv

import pandas as pd
import numpy as np
import sys

file_path_1 = sys.argv[1]
group_by = sys.argv[2]
file_path_2 = sys.argv[3]

table_1 = pd.read_csv(file_path_1)
table_1_grouped = table_1.groupby(group_by)
table_1_summed = table_1_grouped.aggregate(np.sum)

table_1_summed.to_csv(file_path_2, sep = ",", index = True)