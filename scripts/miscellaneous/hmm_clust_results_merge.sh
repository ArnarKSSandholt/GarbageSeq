#!/bin/bash

for f in $(ls ~/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_fOTUs | sed 's/.txt//')
do
python table_merge.py ~/Documents/team_garbageSeq/data/all_fOTU_results.csv fOTU_name ~/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_fOTUs/${f}.txt fOTU_name ~/Documents/team_garbageSeq/data/HMM_clusters/cluster_stats/${f}_all_results.csv
done