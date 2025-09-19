#!/bin/bash

bedtools intersect -c -a hg19-kc.bed -b snps-chr1.bed > snp_genes_chr1.bed
sort -k5 -n -r snp_genes_chr1.bed | head -n 5
#chr1	245912648	246670581	ENST00000490107.6_7	5445
#chr1	6845513	7829766	ENST00000303635.12_8	5076
#chr1	237205483	237997288	ENST00000366574.7_7	4586
#chr1	193442353	194167841	ENST00000656143.2_4	4265
#chr1	48998525	50489626	ENST00000371839.6_9	4003

# Human Gene SMYD3 (ENST00000490107.6_7) from GENCODE V48lift37
#  	Description: SET and MYND domain containing 3, transcript variant 3 (from RefSeq NM_001375962.1)
# Gencode Transcript: ENST00000490107.6_7
# Gencode Gene: ENSG00000185420.19_12
# Transcript (Including UTRs)
#    Position: hg19 chr1:245,912,649-246,670,581 Size: 757,933 Total Exon Count: 12 Strand: -
# Coding Region
#    Position: hg19 chr1:245,912,865-246,670,519 Size: 757,655 Coding Exon Count: 12 

#SMYD3 is a chromatin remodeler that is associated with the development of cancer. This could explain why it has so many SNPs across the population, as potentially oncogenic genes are likely varied across the population.

bedtools sample -n 20 -seed 42 -i snps-chr1.bed | bedtools sort -i - > subset_snps-chr1.bed

bedtools sort -i hg19-kc.bed > sort_hg19-kc.bed

bedtools closest -d -t first -a subset_snps-chr1.bed -b sort_hg19-kc.bed > inside_outside_snps.bed
# chr1    3810505         3810506         rs78397137      0       +       chr1    3805696         3816836         ENST00000361605.4_7     0
# chr1    11638083        11638084        rs6698664       0       +       chr1    11653741        11655507        ENST00000793460.1_2     15658
# chr1    11839540        11839541        rs200540772     0       +       chr1    11822249        11849642        ENST00000688073.1_7     0
# chr1    19020850        19020851        rs71645417      0       +       chr1    18957339        19075360        ENST00000420770.7_4     0
# chr1    19821839        19821840        rs2088825       0       +       chr1    19823503        19890741        ENST00000816783.1_2     1664
# chr1    20821533        20821534        rs74720529      0       +       chr1    20825940        20834644        ENST00000264198.5_7     4407
# chr1    22371064        22371065        rs10917130      0       +       chr1    22351634        22418052        ENST00000695855.1_5     0
# chr1    36733538        36733539        rs12726228      0       +       chr1    36690043        36770958        ENST00000354618.10_6    0
# chr1    51041899        51041900        rs77222361      0       +       chr1    50902699        51425939        ENST00000396153.7_8     0
# chr1    55741406        55741407        rs572651962     0       +       chr1    55683317        55790364        ENST00000643232.1_3     0
# chr1    62606299        62606300        rs12072694      0       +       chr1    62208151        62629587        ENST00000642238.2_5     0
# chr1    65318583        65318584        rs188698        0       -       chr1    65298911        65432232        ENST00000342505.5_11    0
# chr1    83638833        83638834        rs9429360       0       +       chr1    83368865        83632498        ENST00000452901.5_3     6336
# chr1    156101548       156101549       rs2485668       0       -       chr1    156084501       156109872       ENST00000368300.9_4     0
# chr1    164976172       164976173       rs11325393      0       +       chr1    164953138       164953229       ENST00000390797.1       22944
# chr1    174840899       174840900       rs1883139       0       -       chr1    174128657       174964445       ENST00000681986.1_7     0
# chr1    174951356       174951357       rs2285209       0       -       chr1    174128657       174964445       ENST00000681986.1_7     0
# chr1    189602916       189602917       rs6672054       0       +       chr1    189537458       189714982       ENST00000758530.1_2     0
# chr1    201437831       201437832       rs35383942      0       +       chr1    201433405       201438316       ENST00000367311.5_7     0
# chr1    247118389       247118390       rs61852577      0       +       chr1    247108848       247242038       ENST00000465049.6_8     0

#15 SNPs fall inside the genes
#the range for SNPs falling outside of genes is 1664 to 22944 base pairs away from the closest gene
