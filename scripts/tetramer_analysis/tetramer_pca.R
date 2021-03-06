# Do a PCA analysis of the tetramer frequency table and plot the results

library(ggbiplot)

sum_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/summed_tetramer_freq_table.csv"
norm_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/normalized_tetramer_freq_table.csv"
norm_fOTU_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/tetramer_freq_fOTU_norm.csv"
norm_fOTU_tetramer_freq_viral <- "/home/arnar/Documents/team_garbageSeq/data/fOTU_tetramer_with_viral.csv"
norm_fOTU_tetramer_freq_all <- "/home/arnar/Documents/team_garbageSeq/data/all_fOTU_results.csv"

# Load the data
df_sum <- read.csv(sum_tetramer_freq, row.names = 1)
df_norm <- read.csv(norm_tetramer_freq, row.names = 1)
df_fOTU_norm <- read.csv(norm_fOTU_tetramer_freq, row.names = 1)
df_fOTU_norm_viral <- read.csv(norm_fOTU_tetramer_freq_viral, row.names = 1)
df_fOTU_norm_all <- read.csv(norm_fOTU_tetramer_freq_all, row.names = 1)

# Run a pca on all of them, though only the normalized fOTU version is plotted
pca_sum = prcomp(df_sum, center = TRUE, scale. = TRUE)
pca_norm = prcomp(df_norm, center = TRUE, scale. = TRUE)
pca_fOTU_norm = prcomp(df_fOTU_norm, center = TRUE, scale. = TRUE)

summary(pca_sum)
summary(pca_norm)
summary(pca_fOTU_norm)

ggbiplot(pca_sum)
ggbiplot(pca_norm)

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/tetramer_plots/", "tetramer_PCA.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_fOTU_norm) + ggtitle("PCA of tetramer counts") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 14), axis.title.y = element_text(size = 14)) +
  xlab("PC1 (41.3% explained var.") + ylab(" PC2 (8.1% explained var.")
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/tetramer_plots/", "tetramer_PCA_VirFinder.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_fOTU_norm, groups = df_fOTU_norm_viral$viral_content, var.axes = FALSE) + ggtitle("PCA of tetramer counts with VirFinder") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 14), axis.title.y = element_text(size = 14)) +
  xlab("PC1 (41.3% explained var.") + ylab(" PC2 (8.1% explained var.") + 
  guides(colour = guide_legend(title="Viral content \nfraction")) + 
  scale_color_hue(labels = c("High", "Low", "Medium", "Very high"))
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/tetramer_plots/", "tetramer_PCA_PlasFlow.png"), collapse = "")
png(filename = plot_path, width = 660, height = 689)
ggbiplot(pca_fOTU_norm, groups = df_fOTU_norm_all$fOTU_composition, var.axes = FALSE) + ggtitle("PCA of tetramer counts with PlasFlow") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 14), axis.title.y = element_text(size = 14)) +
  xlab("PC1 (41.3% explained var.") + ylab(" PC2 (8.1% explained var.") + 
  guides(colour = guide_legend(title="Plasflow content \ncategories")) + 
  scale_color_hue(labels = c("Bacterial \nchromosome", "Mixed", "Plasmid", "Unclassified"))
dev.off()
