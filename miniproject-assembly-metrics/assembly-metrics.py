#!/usr/bin/env python3

import sys
import fasta

my_file = open(sys.argv[1]) #io.TextIOWrapper name='caenorhabditis_remanei.PRJNA248909.WBPS19.genomic.fa' mode='r' encoding='UTF-8'> this is a pointer to the file path
contigs = fasta.FASTAReader(my_file)
i=0
lengths = []
total_length = 0
for ident, sequence in contigs:
    total_length = total_length + len(sequence)
    lengths.append(len(sequence))
    i += 1
print(f"number of contigs:{i}")
lengths.sort( reverse=True )

running_sum = 0
for contig in lengths:
    running_sum = running_sum + contig
    if running_sum > total_length / 2:
        print(f"N50 = {contig}")
        break
    
# counter = 0
# for contig in range(len(sorted_lengths)):
#     print(sorted_lengths[contig])
#     counter += 1
    # if counter < 10:
    #     print(sorted_lengths[contig])
    # elif counter > 1581:
    #     print(sorted_lengths[contig])
    # else:
    #     continue

# print(counter)

    
    