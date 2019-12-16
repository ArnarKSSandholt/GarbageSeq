# Run VirFinder on every file in the directory path_list_1

library(VirFinder)
source("/home/akss94/parVF.pred.R") # This file allows for running VirFinder with multiple cores in parallel

path_list_1 <- list.files("/home/akss94/fOTU_bin_fasta")
out_path <- "/home/akss94/virfinder_results/"

for (dna_file in path_list_1) {
  dna_file_path <- paste(c("/home/akss94/fOTU_bin_fasta/", dna_file), collapse = "")
  vir.pred <- parVF.pred(dna_file_path, cores=8)
  out_file <- gsub(".fna", "_virfinder.csv", dna_file)
  full_out_path <- paste(c(out_path, out_file), collapse = "")
  write.csv(vir.pred, full_out_path, row.names = FALSE)
}