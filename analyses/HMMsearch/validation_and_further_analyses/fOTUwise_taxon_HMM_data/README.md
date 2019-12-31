# Directory contents

This directory contains one file per each fOTU with at least one HMMer's hmmsearch hit (with viral eggNOG HMMs as the queries). Each file contains on each line tab delimeted columns (from left to right): 
1. eggNOG HMM identifier
2. Maximum full sequence e-value (i.e. not the best 1 domain) with which the hmmsearch matched a protein belonging to the current fOTU
3. NCBI Taxid of the group from which the viral HMMs had protein contributions to their MSAs (and subsequent profiles)
4. eggNOG category assigned to the HMM (acquired directly from eggNOG database)
5. a comma separated list of NCBI taxids and pfam protein ids separated by a `.` (acquired directly from eggNOG database)
6. a unique list of NCBI taxids of each taxon contributing with proteins to the HMM (acquired directly from eggNOG database)
7. a general description of the HMM (acquired directly from eggNOG database)
8. a `;` separated list of Scientific names of the taxons which have contributed to HMM (acquired from NCBI's taxonomy database via a entrez wrapper in Biopython v. 1.75)
9. a comma separated list of superkingdoms of the taxons having contributed to the HMM
10. a comma separated list of orders of the taxons having contributed to the HMM
11. a comma separated list of families of the taxons having contributed to the HMM
12. a comma separated list of subfamilies of the taxons having contributed to the HMM
13. a comma separated list of genuses of the taxons having contributed to the HMM
14. a `;` separated list of species of the taxons having contributed to the HMM
15. no rank a comma separated list of species of the taxons having contributed to the HMM
16. a comma separated list of phylums of the taxons having contributed to the HMM
17. a comma separated list of classes of the taxons having contributed to the HMM
18. a comma separated list of unclassified taxons, i.e. taxons that weren't any of the above from 9.-17.
19. a comma separated list of lineages of the taxons having contributed to the HMM; each taxonomic level in each entry is separeted by `;`