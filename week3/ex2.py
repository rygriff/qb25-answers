#!/usr/bin/env python3
AF = open("AF.txt", "w")
AF.write("AF\n")
DP = open("DP.txt", "w")
DP.write("DP\n")
#parsing VFC File
for line in open("/Users/cmdb/qb25-answers/week3/BYxRM_bam/filtered.vcf"):
    if line.startswith('#'):
        continue
    fields = line.rstrip('\n').split('\t')

    # grab what you need from `fields`
    info = fields[7]
    info_entries = info.split(';')
    for entry in info_entries:
        if entry.startswith("AF="):
            af = entry.split('=')[1]
            AF.write(af + "\n")
            break
        
    if len(fields) > 9:
        for sample_field in fields[9:]:
            value = sample_field.split(':')
            DP.write(value[2]+"\n")

AF.close()
DP.close()