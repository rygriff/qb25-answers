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


