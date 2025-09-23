#!/usr/bin/env python3

import sys

sam = open(sys.argv[1])
chrom_dict = {}
nmtag_dict = {}
for line in sam:
    if line.startswith("@"):
        continue
    feilds = line.strip().split()
    rname = feilds[2]
    chrom_dict[rname] = chrom_dict.get(rname, 0) + 1
    for tag in feilds[11:]:
        if tag.startswith("NM:i:"):
            count = int(tag[5:])
            nmtag_dict[count] = nmtag_dict.get(count, 0) + 1
            break
for chrom in chrom_dict.keys():
    print(chrom, chrom_dict[chrom])
print()
for nmtag in sorted(nmtag_dict.keys()):
    print(nmtag, nmtag_dict[nmtag])

