#!/usr/bin/env python3
import numpy as np

##---Step 1.2---##

## I know num_reads should be (coverage * genomesize)/readlength
## "3x coverage of a 1Mbp genome with 100bp reads"
genomesize = 1000000
readlength = 100
coverage = 3

## could make a function to calculate (what I think the assignment is asking for)
def calculate_number_of_reads(genomesize, readlength, coverage):
    return int((genomesize * coverage) / readlength)
num_reads = calculate_number_of_reads(genomesize, readlength, coverage)

## but it also seems like you could just define num_reads = int((genomesize * coverage) / readlength) (not sure which is better?)

## use an array to keep track of the coverage at each position in the genome
genome_coverage = np.zeros(genomesize, dtype=int)

for i in range(num_reads):
  startpos = np.random.randint(0,genomesize-readlength+1)
  endpos = startpos + readlength
  genome_coverage[startpos:endpos] += 1

## Save genome_coverage to text file for plotting in R
np.savetxt("coverage.txt", genome_coverage, fmt="%d")

##---Step 1.5---##

## Repeat for 10X coverage 
coverage = 10
num_reads = calculate_number_of_reads(genomesize, readlength, coverage)
genome_coverage = np.zeros(genomesize, dtype=int)

for i in range(num_reads):
  startpos = np.random.randint(0,genomesize-readlength+1)
  endpos = startpos + readlength
  genome_coverage[startpos:endpos] += 1

np.savetxt("coverage_10.txt", genome_coverage, fmt="%d")

##---Step 1.6---##

## Repeat for 30X coverage 
coverage = 30
num_reads = calculate_number_of_reads(genomesize, readlength, coverage)
genome_coverage = np.zeros(genomesize, dtype=int)

for i in range(num_reads):
  startpos = np.random.randint(0,genomesize-readlength+1)
  endpos = startpos + readlength
  genome_coverage[startpos:endpos] += 1

np.savetxt("coverage_30.txt", genome_coverage, fmt="%d")