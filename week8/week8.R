#!usr/bin/env Rscript

# Exercise 1
# Step 1.1: Loading data and importing libraries

library(tidyverse)
library(broom)
library(DESeq2)
library(ggplot2)

# load counts
counts_df <- read_delim("/Users/cmdb/qb25-answers/week8/data/gtex_whole_blood_counts_downsample.txt", delim = ",") %>%
  as_tibble()
counts_df[1:5,]
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")
counts_df[1:5,]

# load metadata
metadata_df <- read_delim("/Users/cmdb/qb25-answers/week8/data/gtex_metadata_downsample.txt") %>%
as_tibble()
metadata_df[1:5,]
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")
metadata_df[1:5,]

# Step 1.2: Create a DESeq2 object

# double check that rows and columns match
colnames(counts_df) == rownames(metadata_df)

# load DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = counts_df, 
                              colData = metadata_df, 
                              design = ~ SEX + DTHHRDY + AGE)
# Step 1.3: Normalization and PCA
vsd <- vst(dds)

p1 <- plotPCA(vsd, intgroup = "AGE") +
  labs(
    title = "PCA Analysis of Expression by Age",
    color = "Age"
  )

p2 <- plotPCA(vsd, intgroup = "SEX") +
  labs(
    title = "PCA Analysis of Expression by Sex",
    color = "Sex"
  )

p3 <- plotPCA(vsd, intgroup = "DTHHRDY") +
  labs(
    title = "PCA Analysis of Expression by Ventilator Status",
    color = "Ventilator Status"
  ) 

print(p1)
ggsave("/Users/cmdb/qb25-answers/week8/PCA_Age.png", p1)
print(p2)
ggsave("/Users/cmdb/qb25-answers/week8/PCA_Sex.png", p2)
print(p3)
ggsave("/Users/cmdb/qb25-answers/week8/PCA_DTHHRDY.png", p3)

## What proportion of variance in the gene expression data is explained by each of the first two principal components?
# PC1 explains 48% of variance while PC2 explains 7%. 

## Which principal components appear to be associated with which subject-level variables? 
# While age and sex do not seem to be explaining either PC1 or 2, DTHHRDY does seem to be clustering along PC1. 
# This suggests that PC1 may be associated with this subject-level variable (type of death)

# Exercise 2: Perform differential expression analysis

# Step 2.1: Perform a “homemade” test for differential expression between the sexes

# create metadata and vsd data frame 
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata_df, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()

## Does WASH7P show significant evidence of sex-differential expression (and if so, in which direction)? 
## Explain your answer.
# None of the predictors (DTHHRDY, AGE, SEX) have p-values < 0.05; SEXmale has a P value of 0.28 and an estimate of 0.11876976, this suggests that males have a slightly higher expression of WASH7P but it is no where close to significant. 

# Now repeat your analysis for the gene SLC25A47. 

m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()

## Does this gene show evidence of sex-differential expression (and if so, in which direction)? Explain your answer.
# SEXmale has a P value of 0.0257 (significant) and an estimate of 0.51832893, indicating that males have a modest but significantly higher expression of SLC25A47.

# Step 2.2: Perform differential expression analysis “the right way” with DESeq2
dds <- DESeq(dds)

# Step 2.3: Extract and interpret the results for sex differential expression

# Extract the differential expression results for the variable SEX.
res <- results(dds, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")

## How many genes exhibit significant differential expression between males and females at a 10% FDR?
res_10FDR <- res %>%
  filter(padj < 0.1)
length(res_10FDR$padj)
# 262

# load mappings
mappings_df <- read_delim("/Users/cmdb/qb25-answers/week8/data/gene_locations.txt") %>%
  as_tibble()

res_map <- left_join(res, mappings_df, by = "GENE_NAME") %>%
  arrange(padj)

## Examine your top hits. 
unique(filter(res_map, padj < 0.1)$CHROM)
nrow(filter(res_map, padj < 0.1 & CHROM == "chrY"))
nrow(filter(res_map, padj < 0.1 & CHROM == "chrX"))

## Which chromosomes encode the genes that are most strongly upregulated in males versus females, respectively? 
arrange(filter(res_map, log2FoldChange > 0 & padj < 0.1), desc(log2FoldChange))
# when log2fold is positive, these genes are upregulated in males. Of the top 10 genes upregulated in males (padj < 0.1) all come from the Y chromosome.
arrange(filter(res_map, log2FoldChange > 0 & padj < 0.1), desc(log2FoldChange))
# when log2fold is negative, these genes are upregulated in females. Of the top 10 genes upregulated in females (padj < 0.1) the top 4 come from the X chromosome.

## Are there more male-upregulated genes or female-upregulated genes near the top of the list?
nrow(filter(res_map, padj < 2.727147e-07 & CHROM == "chrY"))
nrow(filter(res_map, padj < 2.727147e-07 & CHROM == "chrX"))
# Male-upregulated genes (positive log2fold change and padj << 0.1) make up about 67% of the top 30 genes while female-upregulated genes make up only about 23%.
## Interpret these results in your own words.
# It makes sense that male-upregulated genes dominate the most statistically significant DE genes, as the Y chromosome is completely absent from females. 
# Female-upregulated genes present on the X chromosome are also present in males, but some genes may escape X-inactivation and show higher expression in females (who have 2 copies of the X chromosome) than males (only 1 copy).

## Examine the results for the two genes (WASH7P and SLC25A47) that you had previously tested with the basic linear regression model in step 2.1. 

# results from homemade linear regression on WASH7P
print(m1)
# results from proper regression on WASH7P
print(filter(res_map, GENE_NAME == "WASH7P"))

# |    Model   | Estimate | P-value |
# |------------|----------|---------|
# | home_made  | 0.119    | 0.279   |
# | proper     | 0.0893   | 0.899   |

# results from homemade linear regression on SLC25A47
print(m2)
# results from proper regression on SLC25A47
print(filter(res_map, GENE_NAME == "SLC25A47"))

# |    Model   | Estimate | P-value     |
# |------------|----------|-------------|
# | home_made  | 0.518    | 0.026       |
# | proper     | 3.06     | 0.0000008   |

## Are the results broadly consistent?
# For WAS7P, both methods estimate a very small positive effect that is not statistically significant.
# For SLC25A47, both methods estimate a positive effect that is statistically significant, but DEseq estimates a much stronger and more statistically significant effect.

## Short reflection on the trade-off between false-positives and false-negatives when changing FDR stringency
# If we use a very strict FDR cut-off, we can help reduce false-positives but at the expense of having more false negatives (more genes that might actually be DE are missed).
# If we use a lenient FDR cut-off, we detect more true positives (fewer false negatives), but we also increase the number of false positives we detect.
# Larger sample sizes and effects that are greater (larger effect sizes) increase the power of our analyses such that we have fewer false negatives and false positives at various FDR cut-offs.

# Step 2.4: Extract and interpret the results for differential expression by death classification

# Extract the differential expression results for the variable DTHHRDY.
res_vent <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")

## How many genes exhibit significant differential expression between males and females at a 10% FDR?
res_10FDR_vent <- res_vent %>%
  filter(padj < 0.1)
length(res_10FDR_vent$padj)
# 16069

# Step 2.5: Estimating a false positive rate under the null hypothesis

# Shuffling SEX column
set.seed(100)   
metadata_shuffle <- metadata_df
metadata_shuffle$SEX <- sample(metadata_shuffle$SEX) 

# load DESeq2 object
dds2 <- DESeqDataSetFromMatrix(countData = counts_df, 
                              colData = metadata_shuffle, 
                              design = ~ SEX + DTHHRDY + AGE)

dds2 <- DESeq(dds2)

# Extract the differential expression results for the variable SEX.
res_shuffle <- results(dds2, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")

## How many genes appear “significant” in this permuted analysis at a 10 % FDR?
res_10FDR_shuffle <- res_shuffle %>%
  filter(padj < 0.1)
length(res_10FDR_shuffle$padj)
# 22

# Compare this number to the count from your real (non-permuted) analysis. 

## Before shuffling: 262
## After shuffling: 22

# What does this suggest about how well the FDR threshold controls the expected rate of false discoveries in large-scale RNA-seq experiments?

# stringent
res_10FDR_shuffle <- res_shuffle %>%
  filter(padj < 0.01)
length(res_10FDR_shuffle$padj)
# 0

# relaxed
res_10FDR_shuffle <- res_shuffle %>%
  filter(padj < 0.2)
length(res_10FDR_shuffle$padj)
# 35

## When FDR is set to 10% we saw 22 false positives. 
## Given that the true data shows 262 DE genes, this indicates that the 10% threshold is generally controlling well for false positives 
## (about 90% of our positives can be expected to be true positives - as expected).

# Exercise 3: Visualization

plot_res <- res %>%
  filter(!is.na(padj)) %>%
  mutate(highlight = padj < 0.1 & abs(log2FoldChange)>1) %>%
  mutate(label = if_else(abs(log2FoldChange) > 7, GENE_NAME, NA_character_))

volcano <- ggplot(plot_res, aes(x = log2FoldChange, y = -log10(padj), color = highlight)) +
        geom_point() +
  coord_cartesian(ylim = c(0, 300)) +
  geom_text(aes(label = label), vjust = -0.7, hjust = 0.6, size = 3, na.rm = TRUE) +
  labs(
    title = "Differentially Expressed Genes in Whole Blood across Sexes (MALE)",
  )
print(volcano)                    

ggsave("/Users/cmdb/qb25-answers/week8/volcano.png", plot = volcano, width = 8, height = 12)
