library(ggbiplot)

sum_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/summed_tetramer_freq_table.csv"
norm_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/normalized_tetramer_freq_table.csv"
norm_fOTU_tetramer_freq <- "/home/arnar/Documents/team_garbageSeq/data/tetramer_freq_fOTU_norm.csv"
norm_fOTU_tetramer_freq_viral <- "/home/arnar/Documents/team_garbageSeq/data/fOTU_tetramer_with_viral.csv"

df_sum <- read.csv(sum_tetramer_freq, row.names = 1)
df_norm <- read.csv(norm_tetramer_freq, row.names = 1)
df_fOTU_norm <- read.csv(norm_fOTU_tetramer_freq, row.names = 1)
df_fOTU_norm_viral <- read.csv(norm_fOTU_tetramer_freq_viral, row.names = 1)

pca_sum = prcomp(df_sum, center = TRUE, scale. = TRUE)
pca_norm = prcomp(df_norm, center = TRUE, scale. = TRUE)
pca_fOTU_norm = prcomp(df_fOTU_norm, center = TRUE, scale. = TRUE)

summary(pca_sum)
summary(pca_norm)
summary(pca_fOTU_norm)

ggbiplot(pca_sum)
ggbiplot(pca_norm)
ggbiplot(pca_fOTU_norm)
ggbiplot(pca_fOTU_norm, groups = df_fOTU_norm_viral$viral_content, var.axes = FALSE)
