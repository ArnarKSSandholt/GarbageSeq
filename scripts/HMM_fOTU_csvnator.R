#!/usr/bin/env Rscript

# Load libraries
library(tidyverse)
library(optparse)

print(sessionInfo())

# When creating data.frames don't assume strings as factors
options(stringsAsFactors=F)

## set list of cmd line arguments
option_list <- list(
  make_option("--pathToParsed", type="character", default="../analyses/HMMsearch/hmmsearch_out_parsed/",
              help="The path in which parsed HMMsearch output is stored [default='../analyses/HMMsearch/hmmsearch_out_parsed/']"),
  make_option("--pathToOutput", type="character", default="../analyses/HMMsearch/",
              help="The path where the whole csv file shall be stored [default='../analyses/HMMsearch/']")
)

## list of options
parser <- OptionParser(usage="%prog [options]", option_list=option_list)
args <- parse_args(parser, positional_arguments = 0)
opt <- args$options
print(opt)


# Initilise variables
fOTUsHMM <- tibble()
#path_to_data <- "../analyses/HMM_scan_using_eggNOG_HMMs/hmmsearch_out_parsed/"
path_to_data <- opt$pathToParsed

files <- list.files(path = path_to_data, 
                    pattern = "*.tsv", recursive=FALSE)

# Read in some data
tsv_names <- c("fOTU_name",
               "hmm_profile_id",
               "inside_inclusion_threshold",
               "Target_Bin_id",
               "Target_Seq_id",
               "full_sequence_e_value",
               "full_sequence_score",
               "full_sequence_bias",
               "best_one_domain_e-value",
               "best_one_domain_score",
               "best_one_domain_bias",
               "exp",
               "N",
               "description")

# Read data and create a tibble out of them
# Go through each tsv parsed results file
for(fOTU_file in files) {
  # Create the file path
  path_file <- paste(path_to_data,fOTU_file, sep = "")
  
  # Create a tibble from a tsv file
  fOTU <- read_tsv(file = path_file, 
                   col_types = "cclcfdddddddic", 
                   col_names = tsv_names) %>%
    # Take only interesting columns
    select(.,c("fOTU_name",
               "hmm_profile_id",
               "full_sequence_e_value")) %>%
    # Create a new col with -log_10 e-values
    mutate(log_eval = -1*log10(full_sequence_e_value)) %>%
    # Drop the old e-value column
    select(.,-full_sequence_e_value) 
  
  # Check if there were empty bins
  fOTU_first_term <- fOTU %>%
    pull(fOTU_name) # This returns a vector of fOTU names
  # Pick just first element because that 
  # would be where my "dummy" text would reside
  fOTU_first_term <- fOTU_first_term[1]
  
  # Check if the results had no hits
  if(fOTU_first_term == "dummy"){
    # For now just jump over those fOTUs with zero hits
    #fOTUsHMM <- bind_rows(fOTUsHMM,tibble())
    next
  }else{
    # If there were matches spread the -log_10 evalues for each
    # fOTU in one row
    fOTU <- fOTU %>%
      # Group all same HMMs together
      group_by(hmm_profile_id) %>%
      # Choose average of all e-values for each unique HMM
      #summarise(avg_log_eval = mean(log_eval)) %>%
      #add_column(fOTU_name = fOTU_first_term) %>%
      
      # Choose the largest value among the unique HMMs
      summarise(max = max(log_eval)) %>%
      add_column(fOTU_name = fOTU_first_term) %>%
    
    # pivot_wider should work for tidyr v. 1.0.0 
    # but I use 0.8.3, therefore I use spread() instead
    # pivot_wider(names_from = hmm_profile_id, 
    #            values_from = log_eval)
    
    # Finally, spread the e-vals on one row
    spread(hmm_profile_id, max)
  }
  # Append the current fOTU data to one big tibble
  fOTUsHMM <- bind_rows(fOTUsHMM,fOTU)
}

# Create the output file path
path_file <- paste(opt$pathToOutput,"fOTUsHMM.csv", sep = "")

# Write the final tibble to a csv
write_csv(x = fOTUsHMM, 
          path=path_file, 
          na = "NA", 
          append = FALSE, 
          col_names = TRUE,
          quote_escape = "double")
