#!usr/bin/env Rscript

library(tidyverse)
library(dplyr)
library(matrixStats)
library(readr)
library(tibble)

gene_exp = read.table("/Users/cmdb/qb25-answers/week7/data/read_matrix.tsv", header=TRUE, row.names = 1)
gene_exp = as.matrix(gene_exp)
summary(gene_exp)

sd <- rowSds(gene_exp)
sd %>% select_if(is.numeric) %>% drop_na() %>% cor
sd
gene_exp_sd <- cbind(gene_exp, sd)
#now I have to sort the matrix
sorted_gene_exp_sd <- gene_exp_sd[order(gene_exp_sd[, "sd"], decreasing = TRUE),]
unswitched_sorted_gene_exp_sd <- sorted_gene_exp_sd
unswitched_sorted_gene_exp_sd[12, ] <- sorted_gene_exp_sd[13, ]
unswitched_sorted_gene_exp_sd[13, ] <- sorted_gene_exp_sd[12, ]
sorted_gene_exp_sd_500 <- head(sorted_gene_exp_sd, n = 500)

#run the PCA analysis on the 500 most variant genes
transposed_sorted_gene_exp_sd_500 <- t(sorted_gene_exp_sd_500)
PCA <- prcomp(x = transposed_sorted_gene_exp_sd_500)

#making dataframe with PCA results (its easier to look at for me)
PC_Coordinates <- as.data.frame(PCA[["x"]]) 
PC_Coordinates <- rownames_to_column(PC_Coordinates, var = "Sample")
PC_Coordinates <- tidyr::separate(data = PC_Coordinates, col = "Sample", into = c("Tissue", "Replicate"), sep = "_")

#creating tibble so I can plot first 2 PC
pca_data = tibble(Tissue=PC_Coordinates[,1], Replicate=PC_Coordinates[,2], PC1=PC_Coordinates[,3], PC2=PC_Coordinates[,4])

#ploting first two PCs
plot1.3_attempt1 <- pca_data %>% ggplot(aes(PC1, PC2, color = Tissue, shape = Replicate)) +
  geom_point() +
  labs(
    x = "PC1",   
    y = "PC2",   
    title = "PCA of Gene Expression Data") +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("/Users/cmdb/qb25-answers/week7/plot1.3_attempt1.png", plot = plot1.3_attempt1, width = 8)

#Examine the PCA plot. Does everything look okay?
##NO! All the data points are along the same axis of PC1 and only vary along the axis of PC2. That might mean that PC1 is explaining variance in something experimental that is not relevant for us (maybe batch effect?).

#Scree plot to see value of each PC
pca_summary = tibble(PC=seq(1,ncol(sorted_gene_exp_sd_500),1), sd = PCA$sdev) %>%
  mutate(var=sd^2) %>%
  mutate(norm_var=var/sum(var))

pca_summary %>% ggplot(aes(PC, norm_var)) +
  geom_line() +
  geom_point()

#Scree plot shows that nearly ALL (over 80%) of the variance is explained by PC1. Lets see what PC1 is being influenced by...
PCA$x
heatmap(PCA$x, Rowv = NA, Colv = NA, col = cm.colors(256))

#What does the PCA plot suggest to you about the data? Why?
##Looks like the sd column is throwing everything off!!

#run the PCA analysis on the 500 most variant genes - this time dropping the sd row
nosd_transposed_sorted_gene_exp_sd_500 <- transposed_sorted_gene_exp_sd_500[rownames(transposed_sorted_gene_exp_sd_500) != "sd", ]
#also need to "un-switch" LFC.Fe_rep3 and Fe_rep1
unswitched_nosd_transposed_sorted_gene_exp_sd_500 <- nosd_transposed_sorted_gene_exp_sd_500
unswitched_nosd_transposed_sorted_gene_exp_sd_500[12, ] <- nosd_transposed_sorted_gene_exp_sd_500[13, ]
unswitched_nosd_transposed_sorted_gene_exp_sd_500[13, ] <- nosd_transposed_sorted_gene_exp_sd_500[12, ]
PCA2 <- prcomp(x = unswitched_nosd_transposed_sorted_gene_exp_sd_500)

#making dataframe with PCA2 results (its easier to look at for me)
PC_Coordinates2 <- as.data.frame(PCA2[["x"]]) 
PC_Coordinates2 <- rownames_to_column(PC_Coordinates2, var = "Sample")
PC_Coordinates2 <- tidyr::separate(data = PC_Coordinates2, col = "Sample", into = c("Tissue", "Replicate"), sep = "_")

#creating tibble so I can plot first 2 PCs from PCA2
pca_data2 = tibble(Tissue=PC_Coordinates2[,1], Replicate=PC_Coordinates2[,2], PC1=PC_Coordinates2[,3], PC2=PC_Coordinates2[,4])

#ploting first two PCs from PCA2
plot1.3_attempt2 <- pca_data2 %>% ggplot(aes(PC1, PC2, color = Tissue, shape = Replicate)) +
  geom_point() +
  labs(
    x = "PC1",   
    y = "PC2",   
    title = "PCA of Gene Expression Data (excluding sd column)") +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("/Users/cmdb/qb25-answers/week7/plot1.3_attempt2.png", plot = plot1.3_attempt2, width = 8)

#Now the plot looks more as I would expect, but I still do not see excellent separation based on either Tissue or Replicate. 
#Sometimes, replicates aren't even clustering close to each other (that seems abnormal). 

#Scree plot to see value of each PC in PCA2
pca_summary2 = tibble(PC=seq(1,ncol(sorted_gene_exp_sd_500)-1,1), sd = PCA2$sdev) %>%
  mutate(var=sd^2) %>%
  mutate(norm_var=var/sum(var))

pca_summary2 %>% ggplot(aes(PC, norm_var)) +
  geom_line() +
  geom_point()

#Scree plot now shows that about 32% of the variance is explained by PC1. 
#Lets see what PC1 is being influenced by now...
PCA2$x
heatmap(PCA2$x, Rowv = NA, Colv = NA, col = cm.colors(256))

#What feature explains the first principal component (simply saying “tissue” is not sufficient)?
##PC1 seems to be influenced by a negative correlation of Tissues A1 and A2.3 and a positive correlation of Tissues Fe and P1. 

#Scree plot as a bar chart
scree_as_bar <- pca_summary2 %>% ggplot(aes(PC, norm_var)) +
  geom_col() +
  labs(
    x = "PC",   
    y = "Proportion of Data's Variance Explained",   
    title = "Proportion of Variance Explained by Each PC") +
    theme(plot.title = element_text(hjust = 0.5))
ggsave("/Users/cmdb/qb25-answers/week7/scree_as_bar.png", plot = scree_as_bar, width = 8)

#Kmeans clustering
#2.1 Avging
#unswitched_sorted_gene_exp_nosd <- unswitched_sorted_gene_exp_sd[, colnames(sorted_gene_exp_sd) != "sd"]
combined = unswitched_sorted_gene_exp_sd[,seq(1, 21, 3)]
combined = combined + unswitched_sorted_gene_exp_sd[,seq(2, 21, 3)]
combined = combined + unswitched_sorted_gene_exp_sd[,seq(3, 21, 3)]
combined = combined / 3
sd <- rowSds(combined)
print(sd)

#filtering
#sd %>% select_if(is.numeric) %>% drop_na() %>% cor
sd2 <- sd > 1
combined <- combined[sd2, ]

rowSds(combined)
set.seed(42)

#unswitched_sorted_gene_exp_nosd <- unswitched_sorted_gene_exp_sd[, colnames(sorted_gene_exp_sd) != "sd"]
kmeans_results = kmeans(as.matrix(combined), centers = 12, nstart=100)
cluster_labels <- kmeans_results$cluster
ordering = order(cluster_labels)

#generate heat map and save it as a PNG
png(file="/Users/cmdb/qb25-answers/week7/heatmap_clusters.png")

heatmap(as.matrix(as.matrix(combined)[ordering,]), Rowv=NA, Colv=NA,
        RowSideColors=RColorBrewer::brewer.pal(12, name="Paired")[kmeans_results$cluster[ordering]], scale='none')

dev.off()
#Select two clusters to investigate.
##1 and 8

#For each, get the gene names using rownames , 
#filtering for only genes within the cluster you have selected.
cluster1 <- rownames(sorted_gene_exp_nosd)[cluster_labels == 1]
writeLines(cluster1, "/Users/cmdb/qb25-answers/week7/cluster1.txt")

cluster8 <- rownames(sorted_gene_exp_nosd)[cluster_labels == 8]
writeLines(cluster8, "/Users/cmdb/qb25-answers/week7/cluster8.txt")
