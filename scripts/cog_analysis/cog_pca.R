# Do a PCA analysis and plot for the COG analysis result
library(ggbiplot)
library(stringr)

cog_freq_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_table.csv"
cog_freq_viral_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_viral_table.csv"
cog_freq_plas_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_plas_table.csv"
HMM_cluster_files <- list.files("/home/arnar/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_bins")
HMM_cluster_names_path <- "/home/arnar/Documents/team_garbageSeq/data/HMM_clusters/HMM_data_clusters-human_readable.csv"

# Read the COG result tables and eliminate zero columns as well as the S column
df_cog <- read.csv(cog_freq_table, row.names = 1)
df_cog[c(18,19,22,24)] <- list(NULL)
df_cog_viral <- read.csv(cog_freq_viral_table, row.names = 1)
df_cog_viral[c(18,19,22,24)] <- list(NULL)
df_cog_plas <- read.csv(cog_freq_plas_table, row.names = 1)
df_cog_plas[c(18,19,22,24)] <- list(NULL)
# Eliminate zero rows
i <- 1
while (i<dim(df_cog)[1]) {
  if (sum(df_cog[i,]) == 0){
    df_cog <- df_cog[-i,]
    df_cog_viral <- df_cog_viral[-i,]
    df_cog_plas <- df_cog_plas[-i,]
  } else {
    i = i + 1
  }
}

# Run the PCA
pca_cog_vir = prcomp(t(apply(sqrt(df_cog_viral[0:20]),1,function(x) x/sum(x))), center = TRUE)
pca_cog_plas = prcomp(t(apply(sqrt(df_cog_plas[0:20]),1,function(x) x/sum(x))), center = TRUE)
summary(pca_cog_vir)
summary(pca_cog_plas)

# Plot the whole data in a biplot.  Only the first two principal components are used
plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", "COG_PCA_plot.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_cog_vir, choices = 1:2) + ggtitle("COG PCA plot") +
  theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14)) + 
  xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var.")
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", "COG_PCA_VirFinder_plot.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_cog_vir, choices = 1:2, groups = df_cog_viral$viral_content) + ggtitle("COG PCA plot with VirFinder") +
  theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14), legend.text=element_text(size=10)) + 
  xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var.") + 
  guides(colour = guide_legend(title="Viral content \nfraction")) + 
  scale_color_hue(labels = c("High", "Low", "Medium", "Very high"))
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", "COG_PCA_PlasFlow_plot.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_cog_plas, choices = 1:2, groups = df_cog_plas$bin_composition) + ggtitle("COG PCA plot with PlasFlow") +
  theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14), legend.text=element_text(size=10)) + 
  xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var.") + 
  guides(colour = guide_legend(title="Plasflow content \ncategories")) + 
  scale_color_hue(labels = c("Bacterial \nchromosome", "Mixed", "Plasmid", "Unclassified"))
dev.off()

HMM_cluster_names <- read.csv(HMM_cluster_names_path, row.names = 1, stringsAsFactors = FALSE)
for (cluster_file in HMM_cluster_files) {
  # Plot filtered versions of the PCA plot, containing only the bins present
  # in the HMM clusters.  Also include colored versions with information from
  # PlasFlow and VirFinder
  cluster_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_bins/", cluster_file), collapse = "")
  cluster <- read.csv(cluster_path)
  viral_cont <- c()
  plas_comp <- c()
  row_numbers <- c()
  
  for (row_name in row.names(pca_cog_vir$x)) {
    # This loop finds all bins from the COG analysis that are
    # also present in each HMM cluster and the corresponding result
    # from VirFinder and Plasflow for coloring
    if (row_name %in% cluster$bin_name) {
      row_numbers <- c(row_numbers,which(row.names(pca_cog_vir$x) == row_name))
      if (df_cog_viral[row_name,"viral_content"] == "High") {
        viral_cont <- c(viral_cont, "High")
      } else if (df_cog_viral[row_name,"viral_content"] == "Low") {
        viral_cont <- c(viral_cont, "Low")
      } else if (df_cog_viral[row_name,"viral_content"] == "Medium") {
        viral_cont <- c(viral_cont, "Medium")
      } else if (df_cog_viral[row_name,"viral_content"] == "Very_high") {
        viral_cont <- c(viral_cont, "Very_high")
      }
      if (df_cog_plas[row_name,"bin_composition"] == "bacterial_chromosome") {
        plas_comp <- c(plas_comp, "Bacterial_chromosome")
      } else if (df_cog_plas[row_name,"bin_composition"] == "mixed") {
        plas_comp <- c(plas_comp, "Mixed")
      } else if (df_cog_plas[row_name,"bin_composition"] == "plasmid") {
        plas_comp <- c(plas_comp, "Plasmid")
      } else if (df_cog_plas[row_name,"bin_composition"] == "unclassified") {
        plas_comp <- c(plas_comp, "Unclassified")
      }
    }
  }
  
  pca_cog_vir_filt <- pca_cog_vir
  pca_cog_vir_filt$x <- pca_cog_vir$x[row_numbers,]
  PCA_content_frame <- data.frame(Viral=as.factor(viral_cont),Plas=as.factor(plas_comp))
  
  if (str_sub(cluster_file, 1, -10) %in% row.names(HMM_cluster_names)) {
    cluster_name <- HMM_cluster_names[str_sub(cluster_file, 1, -10),]
  } else {
    cluster_name <- str_sub(cluster_file, 1, -10)
  }
  
  if (length(viral_cont) >= 2) { # This condition ensures that the plot has some data
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", str_sub(cluster_file, 1, -10), "_plain.png"), collapse = "")
    png(filename = plot_path, width = 660, height = 689)
    print(ggbiplot(pca_cog_vir_filt, choices = 1:2) + ggtitle(paste(c("HMM cluster ", cluster_name, " COG PCA"), collapse = "")) +
      theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14)) + 
      xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var."))
    dev.off()
    
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", str_sub(cluster_file, 1, -10), "_VirFinder.png"), collapse = "")
    png(filename = plot_path, width = 660, height = 689)
    print(ggbiplot(pca_cog_vir_filt, choices = 1:2, groups = PCA_content_frame$Viral) + ggtitle(paste(c("HMM cluster ", cluster_name, " COG PCA\nwith VirFinder"), collapse = "")) +
      theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14), legend.text=element_text(size=10)) + 
      xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var.") + 
      guides(colour = guide_legend(title="Viral content \nfraction")) + 
      scale_color_hue(labels = c("High", "Low", "Medium", "Very high")))
    dev.off()
    
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_pca_plots/", str_sub(cluster_file, 1, -10), "_PlasFlow.png"), collapse = "")
    png(filename = plot_path, width = 660, height = 689)
    print(ggbiplot(pca_cog_vir_filt, choices = 1:2, groups = PCA_content_frame$Plas) + ggtitle(paste(c("HMM cluster ", cluster_name, " COG PCA\nwith PlasFlow"), collapse = "")) +
      theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title=element_text(size=14), legend.text=element_text(size=10)) + 
      xlim(-2.4,2) + ylim(-3.2,2.1) + xlab("PC1 (31.0% explained var.") + ylab(" PC2 (15.8% explained var.") + 
      guides(colour = guide_legend(title="Plasflow content \ncategories")) + 
      scale_color_hue(labels = c("Bacterial \nchromosome", "Mixed", "Plasmid", "Unclassified")))
    dev.off()
  }
}
