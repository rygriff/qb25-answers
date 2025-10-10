#!/bin/bash

cd /Users/cmdb/qb25-answers/week3/
# tar -xzvf BYxRM_bam.tar.gz
cd /Users/cmdb/qb25-answers/week3/BYxRM_bam

for file in *.bam
do
   samtools index $file
   samtools view -c $file 
 done > read_counts.txt
 
 for file in *.bam
 do 
   echo $file
 done > bamListFile.txt
 
# run FreeBayes to discover variants 
freebayes -f /Users/cmdb/qb25-answers/week2/genomes/sacCer3.fa -L /Users/cmdb/qb25-answers/week3/BYxRM_bam/bamListFile.txt --genotype-qualities -p 1 > unfiltered.vcf

vcffilter -f "QUAL > 20" -f "AN > 9" unfiltered.vcf > filtered.vcf
#vcfallelicprimitives -kg filtered.vcf > decomposed.vcf - This tool couldn't be found so I cannot run it
#vcfbreakmulti decomposed.vcf > biallelic.vcf



