#!/bin/bash

#Exercise 1
##how many features (lines)?
wc -l ce11_genes.bed

# 53935 ce11_genes.bed

##How many features per chr? e.g. `chrI`, `chrII`?
cut -f 1 ce11_genes.bed | sort | uniq -c

# 5460 chrI
# 6299 chrII
# 4849 chrIII
# 21418 chrIV
#   12 chrM
# 9057 chrV
# 6840 chrX

##How many features per strand? e.g. `+`, `-`?
cut -f 6 ce11_genes.bed | sort | uniq -c

# 26626 -
# 27309 +

#Exercise 2
./recalculate-scores.py ce11_genes.bed | head -n 15

# chrI    8377406 8390027 NM_059873.7     -75726  -
# chrI    8377598 8392758 NM_182066.7     -7610320        -
# chrI    8377600 8392768 NM_001129046.3  -106176 -
# chrI    1041473 1049600 NM_058410.5     3868452 +
# chrI    3144409 3147793 NM_058707.5     -1796904        -
# chrI    4193240 4203303 NM_058924.6     6772399 +
# chrI    6284972 6294057 NM_059412.6     4833220 +
# chrI    6289432 6294068 NM_001374900.1  2851140 +
# chrI    6290315 6293988 NM_001374901.1  2604157 +
# chrI    7339231 7345684 NM_001136303.4  45171   +
# chrI    9431248 9441017 NM_060105.7     4698889 +
# chrI    9435464 9441029 NM_060106.7     16695   +
# chrI    11526917        11557854        NM_060545.6     -15406626       -
# chrI    11526922        11552160        NM_001383731.1  -13527568       -
# chrI    11527027        11557792        NM_001306313.4  -184590 -

#Exercise 3
##Which three SMTSDs (Tissue Site Detail) have the most samples?
cut -f 7 /Users/cmdb/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | sort | uniq -c | sort | tail -3

# 867 Lung
# 1132 Muscle - Skeletal
# 3288 Whole Blood

##How many lines have "RNA"?
grep -c "RNA" /Users/cmdb/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt

#20017

##How many lines do **not** have "RNA"?
grep -cv "RNA" /Users/cmdb/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt

#2935

#Exercise 4
./transform_GTEx.py GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct