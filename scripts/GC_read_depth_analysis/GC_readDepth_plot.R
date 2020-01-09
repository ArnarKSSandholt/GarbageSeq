# Plot dot plots showing average read depth versus GC percentage

library(ggplot2)

data_file_1 <- "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins_with_cov.csv"
data_file_2 <- "/home/arnar/Documents/team_garbageSeq/data/fOTU_stats.csv"
data_file_3 <- "/home/arnar/Documents/team_garbageSeq/data/all_fOTU_results.csv"

df1 <- read.csv(data_file_1)
df2 <- read.csv(data_file_2)
df3 <- read.csv(data_file_3)

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/GC_read_depth_plots/", "read_depth_vs_GC_plain.png"), collapse = "")
png(filename = plot_path, width = 1075, height = 589)
ggplot(df2[df2$length>10000,], aes(x=GC, y=total_avg_depth, size=length, label = fOTU_name)) + 
  geom_point() + scale_y_log10() + scale_x_log10() + theme_minimal() + ggtitle("Total average read depth vs GC percentage \n of fOTUs") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 16), axis.title.y = element_text(size = 16)) + 
  labs(x = "GC percentage", y = "Total average read depth") + 
  guides(size = guide_legend(title="fOTU size"))
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/GC_read_depth_plots/", "read_depth_vs_GC_VirFinder.png"), collapse = "")
png(filename = plot_path, width = 1075, height = 589)
ggplot(df3[df3$length>10000,], aes(x=GC, y=total_avg_depth, size=length, label = fOTU_name, col = viral_content)) + 
  geom_point() + scale_y_log10() + scale_x_log10() + theme_minimal() + ggtitle("Total average read depth vs GC percentage \n of fOTUs with VirFinder") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 16), axis.title.y = element_text(size = 16)) + 
  labs(x = "GC percentage", y = "Total average read depth") + 
  guides(size = guide_legend(title="fOTU size"), colour = guide_legend(title="Viral content \nfraction")) + 
  scale_color_hue(labels = c("High", "Low", "Medium", "Very high"))
dev.off()

plot_path <- paste(c("/home/arnar/Documents/team_garbageSeq/data/plots/GC_read_depth_plots/", "read_depth_vs_GC_PlasFlow.png"), collapse = "")
png(filename = plot_path, width = 1075, height = 589)
ggplot(df3[df3$length>10000,], aes(x=GC, y=total_avg_depth, size=length, label = fOTU_name, col = fOTU_composition)) + 
  geom_point() + scale_y_log10() + scale_x_log10() + theme_minimal() + ggtitle("Total average read depth vs GC percentage \n of fOTUs with PlasFlow") + 
  theme(plot.title = element_text(hjust = 0.5, size = 24), axis.title.x = element_text(size = 16), axis.title.y = element_text(size = 16)) + 
  labs(x = "GC percentage", y = "Total average read depth") + 
  guides(size = guide_legend(title="fOTU size"), colour = guide_legend(title="Plasflow content \ncategories")) + 
  scale_color_hue(labels = c("Bacterial \nchromosome", "Mixed", "Plasmid", "Unclassified"))
dev.off()
