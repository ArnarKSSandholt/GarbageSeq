#!/usr/bin/awk -f
{
    fOTU = $1;
    system("ln -s ../fOTUwise_taxon_HMM_data/"fOTU".tsv ./"fOTU".ln.tsv");
}