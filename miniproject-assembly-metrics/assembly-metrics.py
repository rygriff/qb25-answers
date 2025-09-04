#!/usr/bin/env python3

import sys
import fasta

my_file = open(sys.argv[1]) #io.TextIOWrapper name='caenorhabditis_remanei.PRJNA248909.WBPS19.genomic.fa' mode='r' encoding='UTF-8'> this is a pointer to the file path
contigs = fasta.FASTAReader(my_file)

for ident, sequence in contigs:
    print( f"Name: {ident}" )
    print( f"First 20 nucleotides: {sequence[:20]}" )

    