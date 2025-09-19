#!/bin/bash

bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed

cut -f1-3,5 hg16-kc.tsv > hg16-kc.bed

bedtools intersect -c -a hg16-1mb.bed -b hg16-kc.bed > hg16-kc-count.bed

wc -l hg19-kc.bed

# hg 19 has 80270 genes

bedtools intersect -v -a hg19-kc.bed -b hg16-kc.bed > hg19_but_not_in_hg16.bed
wc -l hg19_but_not_in_hg16.bed

#42717 hg19_but_not_in_hg16.bed

#Some genes are expected to be in hg19 (newer) and not in hg16 (older assembly) because as the genome assembly was improved regions that had gaps have been filled with "new" genes.

wc -l hg16-kc.bed

#21365 hg16-kc.bed

bedtools intersect -v -a hg16-kc.bed -b hg19-kc.bed > hg16_but_not_in_hg19.bed
wc -l hg16_but_not_in_hg19.bed

#3460 hg16_but_not_in_hg19.bed

#some genes may be unique to hg16 and no longer visable in hg19 because they have been re-annotated to be more accurately described or dropped due to initially being incorrectly identified as a unique transcript. 


