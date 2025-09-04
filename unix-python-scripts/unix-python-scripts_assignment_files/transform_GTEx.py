#!/usr/bin/env python3

import sys
import gzip

transform = gzip.open(sys.argv[1])
_=transform.readline().decode()
_=transform.readline().decode()
headers = transform.readline().decode().strip("\n").split("\t")
line3 = transform.readline().decode().strip("\n").split("\t")

my_dict = {}

for header in range(2,len(headers)):
    my_dict.setdefault(headers[header])
    my_dict[headers[header]] = line3[header]

#print(len(my_dict))
#dict is 17382 long

expression = open(sys.argv[2])
feilds = expression.readline().strip("\n").split("\t")
#print(feilds)
for line in expression:
    line = line.strip("\n").split("\t")
    if line[0] in my_dict and float(my_dict[line[0]]) > 0:
        print(line[0],my_dict[line[0]],line[6])
