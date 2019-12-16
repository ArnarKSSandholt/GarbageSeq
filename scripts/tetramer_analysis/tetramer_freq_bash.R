# Computes the tetramer frequencies of all contigs in a user specified FASTA file

library(Biostrings)

args = commandArgs(trailingOnly=TRUE)
dna_path <- args[1]
dna <- readDNAStringSet(dna_path)
tetramer_freq <- oligonucleotideFrequency(dna, width = 4)
write.csv(tetramer_freq, args[2])
