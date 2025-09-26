#!/bin/bash

#exercise1

#index genome
bowtie2-build sacCer3.fa sacCer3     

#Map reads to genome and sort/index with samtools (as many times as samples)
cd variants
bowtie2 -p 4 -x /Users/cmdb/qb25-answers/week2/genomes/sacCer3 -U /Users/cmdb/Data/BYxRM/fastq/A01_01.fq.gz > A01_01.sam

# 740067 reads; of these:
#   740067 (100.00%) were unpaired; of these:
#     3135 (0.42%) aligned 0 times
#     719904 (97.28%) aligned exactly 1 time
#     17028 (2.30%) aligned >1 times
# 99.58% overall alignment rate

#-o filewearemaking.bam inputfile.sam
samtools sort -o A01_01.bam A01_01.sam

#index .bam file so IGV can read it
samtools index A01_01.bam

#create idxstats report
samtools idxstats A01_01.bam > A01_01.idxstats

#output looks like...
# chrI	230218	8935	0
# chrII	813184	48852	0
# chrIII	316620	19671	0
# chrIV	1531933	93309	0
# chrIX	439888	23597	0
# chrV	576874	33089	0
# chrVI	270161	12330	0
# chrVII	1090940	67253	0
# chrVIII	562643	32411	0
# chrX	745751	44133	0
# chrXI	666816	41299	0
# chrXII	1078177	66342	0
# chrXIII	924431	56740	0
# chrXIV	784333	47048	0
# chrXV	1091291	65696	0
# chrXVI	948066	57075	0
# chrM	85779	19152	0
# *	0	0	3135

#exercise 2

#The samples in igv viewer that have a lot of colorful lines (snps) correspond to "R" strains in the BYxRM_GenoData.txt file. This makes sense because the reference strain for IGV is "B".

#Exercise 4
minimap2 -a -x map-ont ../genomes/sacCer3.fa ../rawdata/ERR8562476.fastq > longreads.sam
samtools sort -o longreads.bam longreads.sam
samtools index longreads.bam
samtools idxstats longreads.bam > longreads.idxstats

#exercise 5
hisat2 -x ../rawdata/sacCer3 -U ../rawdata/SRR10143769.fastq -S SRR10143769.sam

#   2917686 reads; of these:
#   2917686 (100.00%) were unpaired; of these:
#   296805 (10.17%) aligned 0 times
#   2245829 (76.97%) aligned exactly 1 time
#   375052 (12.85%) aligned >1 times
#   89.83% overall alignment rate

samtools sort -o SRR10143769.bam SRR10143769.sam
samtools index SRR10143769.bam
samtools idxstats SRR10143769.bam > SRR10143769.idxstats

#   generally it seems like coverage of RNAs is highest in exons and weakest across introns. However, it does seem like some genes see high coverage over intron regions - this could be non-coding regulatory RNAs that are expressed. 