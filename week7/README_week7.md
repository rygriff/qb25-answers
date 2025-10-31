Title: Week 7 Assignment Answers

# Exercise 1

## Examine the PCA plot. Does everything look okay?

### NO! All the data points are along the same axis of PC1 and only vary along the axis of PC2. That might mean that PC1 is explaining variance in something experimental that is not relevant for us (maybe batch effect?).

### I looked at a heat map of weights for the PCs next.

## What does the PCA plot suggest to you about the data? Why?

### Based on the heat map of weights, it looks like the sd column is throwing everything off. It is highly weighted for PC1 while everything else is very minimally weighted.

## What feature explains the first principal component (simply saying “tissue” is not sufficient)?

### PC1 seems to be influenced by a negative correlation of Tissues A1 and A2.3 and a positive correlation of Tissues Fe and P1.

# Exercise 3

## Do the categories of enrichment make sense? Why?

### In cluster 1 I am seeing a lot of enrichment in genes involved in RNA processing (at various steps). In cluster 8, the enriched genes are largely involved in innate immunity. It makes sense that gene expression would vary across different segments of the midgut, as the cell types and functions differ across the regions. Since different clusters were generated with tissues as factors, these varying purposes are baked into the clustering data as well. So it is not surprising that different clusters would represent enrichment for different gene pathways.
