#!/bin/bash
grep 1_Active nhek.bed > nhek-active.bed
grep 12_Repressed nhek.bed > nhek-repressed.bed
grep 1_Active nhlf.bed > nhlf-active.bed 
grep 12_Repressed nhlf.bed > nhlf-repressed.bed

bedtools intersect -a nhek-active.bed -b nhek-repressed.bed | wc -l
#0
bedtools intersect -a nhlf-active.bed -b nhlf-repressed.bed | wc -l
#0

bedtools intersect -a nhek-active.bed -b nhlf-active.bed | wc -l
#14888
bedtools intersect -v -a nhek-active.bed -b nhlf-active.bed | wc -l
#0

wc -l nhek-active.bed 
#14013 
#14888 does not equal the 14013 lines in nhek-active.bed. This could be because some of the overlapping regions are double counting. 

bedtools intersect -u -a nhek-active.bed -b nhlf-active.bed | wc -l
#11608

bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
bedtools intersect -F 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
bedtools intersect -F 1 -f 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
#4821
#6731
#1409

#-f 1 makes it so that active regions in nhek are totally overlapping with active regions in nhlf (nhlf is longer than nhek so nhek is totally contained within the nhlf region)
#-F 1 is the exact opposit of above
#-f 1 -F 1 displays only active regions that exactly overlap between nhlf and nhek

#Active in NHEK, Active in NHLF
bedtools intersect -F 1 -f 1 -a nhek-active.bed -b nhlf-active.bed
#across all 9 conditions: nearly all active.

#Active in NHEK, Repressed in NHLF
bedtools intersect -a nhek-active.bed -b nhlf-repressed.bed
#across all 9 conditions: about hald active promoters overlapping across conditions. 3 out of 9 are repressed. 1 condition has an insulator at the same region, and 1 condition has a strong enhancer at the region in question with an active promoter downstream.

#Repressed in NHEK, Repressed in NHLF
bedtools intersect -F 1 -f 1 -a nhek-repressed.bed -b nhlf-repressed.bed
#across all 9 conditions: Most condistions are also repressed. Many have insulators upstream of the repressed region. A couple have elongations.