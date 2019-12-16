# Plot dot plots showing average read depth versus GC percentage

library(ggplot2)

data_file_1 <- "/home/arnar/Documents/team_garbageSeq/data/stats_on_all_fOTUed_bins_with_cov.csv"
data_file_2 <- "/home/arnar/Documents/team_garbageSeq/data/fOTU_stats.csv"
data_file_3 <- "/home/arnar/Documents/team_garbageSeq/data/fOTU_stats_with_virus.csv"
df1 <- read.csv(data_file_1)
df2 <- read.csv(data_file_2)
df3 <- read.csv(data_file_3)
p1 <- ggplot(df1[df1$length>10000,], aes(x=GC, y=total_avg_depth, size=length, label = name))+geom_point()+scale_y_log10()+scale_x_log10()+theme_minimal()
p1
p2 <- ggplot(df2[df2$length>1000000,], aes(x=GC, y=total_avg_depth, size=length, label = fOTU_name))+geom_point()+scale_y_log10()+scale_x_log10()+theme_minimal()
p2
p3 <- ggplot(df3[df3$length_x>10000,], aes(x=GC, y=total_avg_depth, size=length_x, label = fOTU_name, col = viral_content))+geom_point()+scale_y_log10()+scale_x_log10()+theme_minimal()
p3
