#!/usr/bin/awk -f
{
    # Check if there is proteoms directory given, if not exit
    if (length(proteom_dir) == 0){
        exit(1)
    }
    # Check if there is proteom index directory given, if not exit
    if (length(proteom_index_dir) == 0){
        exit(2)
    }


    # Get access to the parts of the first field
    split($1, filedata, ":")
    # Find the file name
    split(filedata[1],filenameData,".")
    split(filenameData[3],fileName,"/")
    protFileName = fileName[4]
    # Find the protein id
    #split(filedata[2],proteinIdData,"_")
    proteinId = filedata[2]
    
    # Use exonerate fasta utilities to fetch the protein seqs in a robust way
    # Check if index file doesn't exist, if it doesn't create one
    if(system("[ ! -f "proteom_index_dir""protFileName".idx ]") == 0){
        system("fastaindex --fasta "proteom_dir""protFileName".faa --index "proteom_index_dir""protFileName".idx")
    } 
    system("fastafetch --fasta "proteom_dir""protFileName".faa --index "proteom_index_dir""protFileName".idx --query "proteinId)
}