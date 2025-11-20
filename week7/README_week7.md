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

### In cluster 1 I am seeing enrichment that seems generally nonspecific. "Cellular processes" and "cellular component organization or biogenesis" are among my top hits. In cluster 8, enrichment is similarly nonsecific, with "macromolecule metabolic process" being the top hit. This could make sense given that (although a little vague in GO terms) the two different clusters, which we know from PC1 are clustering according to their position along the gut, would be expected to represent samples that perform different functions (as different segments of the gut are responsible for different steps of digestion and thus could be expected to have distinct gene expression patterns).
