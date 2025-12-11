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

##---Step 2.1---#

# Next, you’re going to generate your own de Bruijn graph using a provided set of reads. 
reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']

# Write code to find all of the edges in the de Bruijn graph corresponding to the provided reads using k = 3 
k = 3

# (assume all reads are from the forward strand, no sequencing errors, complete coverage of the genome). 
# Each edge should be of the format ATT -> TTC. 
# Write all edges to a file, with each edge as its own line in the file.

graph = set()

for read in reads:
  for i in range(len(read) - k):
     kmer1 = read[i: i+k]
     kmer2 = read[i+1: i+1+k]
     edge = f"{kmer1} -> {kmer2}"
     graph.add(edge)

# Step 2.3 linked documentation tells me a .dot file for a directed graph looks like this"

"""
digraph {
    vertex1 -> vertex2
    vertex2 -> vertex3
    vertex1 -> vertex3
    ...
}
"""

with open("graph.dot", "w") as f:
    f.write("digraph {\n")
    for edge in graph:
       f.write(edge + "\n")
    f.write("}\n")


