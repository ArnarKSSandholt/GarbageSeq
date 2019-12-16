# Merge two csv tables on a user specified column in each
# Usage: /Path/to/input/file_1.csv merge_on_column_name_1 /Path/to/input/file_2.csv merge_on_column_name_2 /Path/to/output/file.csv

import pandas as pd
import sys

file_path_1 = sys.argv[1]
merge_left = sys.argv[2]
file_path_2 = sys.argv[3]
merge_right = sys.argv[4]
file_path_3 = sys.argv[5]

table_1 = pd.read_csv(file_path_1)
table_2 = pd.read_csv(file_path_2)

concat_table = pd.merge(table_1, table_2, left_on = merge_left, right_on = merge_right)

concat_table.to_csv(file_path_3, sep = ",", index = False)