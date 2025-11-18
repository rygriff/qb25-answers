Title: Week 7 Assignment Answers

# Exercise 1

## Examine the PCA plot. Does everything look okay?

### No. The replicates of tissues Fe and LFC.Fe are not clustering together properly.  

## What does the PCA plot suggest to you about the data? Why?

### It looks like, based on the PCA plot on on the raw data table, that LCF.Fe_rep3 and Fe_rep1 may have been switched. I can tell as LFC.Fe_rep3 is clustering with the other Fe samples and Fe_rep1 is clustering with the other LFC.Fe samples. I am going to fix it by "un-swapping" the samples before running the PCA analysis.

## What feature explains the first principal component (simply saying “tissue” is not sufficient)?

### The tissue clusters are separating along PC1 based on each tissues location along the gut.

# Exercise 3

## Do the categories of enrichment make sense? Why?

### In cluster 1 I am seeing a lot of enrichment in genes involved in RNA processing (at various steps). In cluster 8, the enriched genes are largely involved in innate immunity. It makes sense that gene expression would vary across different segments of the midgut, as the cell types and functions differ across the regions. Since different clusters were generated with tissues as factors, these varying purposes are baked into the clustering data as well. So it is not surprising that different clusters would represent enrichment for different gene pathways.
