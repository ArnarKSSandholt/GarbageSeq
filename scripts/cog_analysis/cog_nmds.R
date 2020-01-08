# Do an NMDS analysis and plot for the COG analysis result
library(vegan)
library(stringr)

cog_freq_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_table.csv"
cog_freq_viral_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_viral_table.csv"
cog_freq_plas_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_plas_table.csv"
HMM_cluster_files <- list.files("/home/arnar/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_bins")

# Read the COG result tables and eliminate zero columns as well as the S column
df_cog <- read.csv(cog_freq_table, row.names = 1)
df_cog[c(18,19,22,24)] <- list(NULL)
df_cog_viral <- read.csv(cog_freq_viral_table, row.names = 1)
df_cog_viral[c(18,19,22,24)] <- list(NULL)
df_cog_plas <- read.csv(cog_freq_plas_table, row.names = 1)
df_cog_plas[c(18,19,22,24)] <- list(NULL)
thresh <- 3 # Minimum rowsum threshold

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

# Run the NMDS analysis
nmds_cog <- metaMDS(df_cog[rowSums(df_cog)>thresh,])

# Plot everything
plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", "COG_NMDS_plot.png"), collapse = "")
png(filename = plot_path, width = 1280, height = 720)
plot(nmds_cog, main = "COG NMDS plot", cex.main = 2, cex.lab = 1.3)
text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
dev.off()

cols <- c("#00cc44","#0000ff", "#ff0000", "#ff9900")

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", "COG_NMDS_VirFinder_plot.png"), collapse = "")
png(filename = plot_path, width = 1280, height = 720)
plot(nmds_cog[["points"]][,1], nmds_cog[["points"]][,2], main = "COG NMDS plot with VirFinder results", xlab="NMDS1", ylab="NMDS2", cex.main = 2, cex.lab = 1.3, xlim=c(-2.982,1.952), ylim = c(-1.25,1.36), cex=0.7, col=cols[df_cog_viral$viral_content])
legend("topleft", legend=levels(df_cog_viral$viral_content), pch=16, col=cols)
points(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], col="red", pch=3, cex=0.5)
text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", "COG_NMDS_PlasFlow_plot.png"), collapse = "")
png(filename = plot_path, width = 1280, height = 720)
plot(nmds_cog[["points"]][,1], nmds_cog[["points"]][,2], main = "COG NMDS plot with PlasFlow results", xlab="NMDS1", ylab="NMDS2", cex.main = 2, cex.lab = 1.3, xlim=c(-3,2), ylim = c(-1.25,1.36), cex=0.7, col=cols[df_cog_plas$bin_composition])
legend("topleft", legend=levels(df_cog_plas$bin_composition), pch=16, col=cols)
points(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], col="red", pch=3, cex=0.5)
text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
dev.off()

for (cluster_file in HMM_cluster_files) {
  # Plot filtered versions of the NMDS plot, containing only the bins present
  # in the HMM clusters.  Also include colored versions with information from
  # PlasFlow and VirFinder
  cluster_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/HMM_clusters/list_of_clustered_bins/", cluster_file), collapse = "")
  cluster <- read.csv(cluster_path)
  filtered_nmds_MDS1 <- c()
  filtered_nmds_MDS2 <- c()
  viral_cont <- c()
  plas_comp <- c()
  for (row_name in row.names(nmds_cog[["points"]])) {
    if (row_name %in% cluster$bin_name) {
      filtered_nmds_MDS1 <- c(filtered_nmds_MDS1,nmds_cog[["points"]][row_name,][1])
      filtered_nmds_MDS2 <- c(filtered_nmds_MDS2,nmds_cog[["points"]][row_name,][2])
      viral_cont <- c(viral_cont, df_cog_viral[row_name,"viral_content"])
      plas_comp <- c(plas_comp, df_cog_plas[row_name,"bin_composition"])
    }
  }
  if (!(is.null(filtered_nmds_MDS1))) {
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", str_sub(cluster_file, 1, -10), "_plain.png"), collapse = "")
    png(filename = plot_path, width = 1280, height = 720)
    plot(filtered_nmds_MDS1, filtered_nmds_MDS2, main = str_sub(cluster_file, 1, -10), xlab="NMDS1", ylab="NMDS2", cex.main = 2, cex.lab = 1.3, xlim=c(-3,2), ylim = c(-1.25,1.36), cex=0.7)
    points(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], col="red", pch=3, cex=0.5)
    text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
    dev.off()
    
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", str_sub(cluster_file, 1, -10), "_VirFinder.png"), collapse = "")
    png(filename = plot_path, width = 1280, height = 720)
    plot(filtered_nmds_MDS1, filtered_nmds_MDS2, main = str_sub(cluster_file, 1, -10), xlab="NMDS1", ylab="NMDS2", cex.main = 2, cex.lab = 1.3, xlim=c(-3,2), ylim = c(-1.25,1.36), cex=0.7, col = cols[viral_cont])
    legend("topleft", legend=levels(df_cog_viral$viral_content), pch=16, col=cols)
    points(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], col="red", pch=3, cex=0.5)
    text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
    dev.off()
    
    plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/HMM_COG_NMDS_plots/", str_sub(cluster_file, 1, -10), "_PlasFlow.png"), collapse = "")
    png(filename = plot_path, width = 1280, height = 720)
    plot(filtered_nmds_MDS1, filtered_nmds_MDS2, main = str_sub(cluster_file, 1, -10), xlab="NMDS1", ylab="NMDS2", cex.main = 2, cex.lab = 1.3, xlim=c(-3,2), ylim = c(-1.25,1.36), cex=0.7, col = cols[plas_comp])
    legend("topleft", legend=levels(df_cog_plas$bin_composition), pch=16, col=cols)
    points(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], col="red", pch=3, cex=0.5)
    text(nmds_cog[["species"]][,1], nmds_cog[["species"]][,2], labels = row.names(nmds_cog[["species"]]), cex= 0.7, pos=3)
    dev.off()
  }
}
