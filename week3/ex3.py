#!/usr/bin/env python3
# sample IDs (in order, corresponding to the VCF sample columns)
sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31",
              "A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]
gt_long = open("/Users/cmdb/qb25-answers/week3/gt_long.txt", "w")
gt_long.write("sample_id\tchrom\tpos\tgt\n")

# open the VCF file
for line in open("/Users/cmdb/qb25-answers/week3/BYxRM_bam/filtered.vcf"):
    #if line starts with "#":
        #skip it, as these are metadata
    if line.startswith('#'):
        continue
    
    # split the line into fields by tab
    fields = line.rstrip('\n').split('\t')
    chrom = fields[0]
    pos   = fields[1]
    #print(chrom)
    # for each sample in sample_ids:
    for i in range(len(sample_ids)):
             # get the sample's data from fields[9], fields[10], ...
            sample_id = sample_ids[i]
            sample_gt = fields[9 + i] 

            # genotypes are represented by the first value before ":" in that sample's data
            # if genotype is "0" then print "0"
            # if genotype is "1" then print "1"
            gt = sample_gt.split(":")[0]
        # otherwise skip
            if gt == "2" in gt:
                continue
            gt_long.write(f"{sample_id}\t{chrom}\t{pos}\t{gt}\n")
    
gt_long.close()