#!/usr/bin/env python3

import sys

recalc = open(sys.argv[1])

for line in recalc:
    line = line.strip("\n")
    column = line.split("\t")
    score = column[4]
    new_score = int(score) * (int(column[2])-int(column[1]))
    if column[5] == "-":
        new_score = new_score * int(-1)
    print(f"{column[0]}\t{column[1]}\t{column[2]}\t{column[3]}\t{new_score}\t{column[5]}")
    
          
          

    