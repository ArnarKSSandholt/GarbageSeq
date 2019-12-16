# Do a PCA analysis and plot for the COG analysis result
library(ggbiplot)

cog_freq_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_table.csv"
cog_freq_viral_table <- "/home/arnar/Documents/team_garbageSeq/data/cog_cat_viral_table.csv"

# Read the COG result tables and eliminate zero columns as well as the S column
df_cog <- read.csv(cog_freq_table, row.names = 1)
df_cog[c(18,19,22,24)] <- list(NULL)
df_cog_viral <- read.csv(cog_freq_viral_table, row.names = 1)
df_cog_viral[c(18,19,22,24)] <- list(NULL)
# Eliminate zero rows
i <- 1
while (i<dim(df_cog)[1]) {
  if (sum(df_cog[i,]) == 0){
    df_cog <- df_cog[-i,]
    df_cog_viral <- df_cog_viral[-i,]
  } else {
    i = i + 1
  }
}

# Run the PCA
pca_cog = prcomp(t(apply(sqrt(df_cog),1,function(x) x/sum(x))), center = TRUE)
summary(pca_cog)
ggbiplot(pca_cog, choices = 1:2, groups = df_cog_viral$viral_content)
    