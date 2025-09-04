#!/usr/bin/env python3

import sys
import fasta

my_file = open(sys.argv[1]) #io.TextIOWrapper name='caenorhabditis_remanei.PRJNA248909.WBPS19.genomic.fa' mode='r' encoding='UTF-8'> this is a pointer to the file path
contigs = fasta.FASTAReader(my_file)
i=0
lengths = []
for ident, sequence in contigs:
    # print(ident)
    # print( f"First 20 nucleotides: {sequence[:20]}" )
    lengths.append(len(sequence))
    i += 1
print(i) #i = 1591
print(f"The sum of all contigs is {sum(lengths)}") #The sum of all contigs is 118549266
print(f"The average contig size is {sum(lengths)/len(lengths)}") #The average contig size is 74512.42363293526



    