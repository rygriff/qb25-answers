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

p1 <- plotPCA(vsd, intgroup = "AGE")
p2 <- plotPCA(vsd, intgroup = "SEX")
p3 <- plotPCA(vsd, intgroup = "DTHHRDY")

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
# None of the predictors (DTHHRDY, AGE, SEX) have p-values < 0.05; SEXmale has a P value of 2.792437e-01 and an estimate of 0.11876976, this suggests that males have a slightly higher expression of WASH7P but it is no where close to significant. 

# Now repeat your analysis for the gene SLC25A47. 

m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()

## Does this gene show evidence of sex-differential expression (and if so, in which direction)? Explain your answer.
# SEXmale has a P value of 2.569926e-02 (significant) and an estimate of 0.51832893, indicating that males have a modest but significant higher expression of SLC25A47.

# Step 2.2: Perform differential expression analysis “the right way” with DESeq2
dds <- DESeq(dds)

# Step 2.3: Extract and interpret the results for sex differential expression

# Extract the differential expression results for the variable SEX.
res <- results(dds, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")


