# sample IDs (in order, corresponding to the VCF sample columns)
sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31",
              "A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]

# open the VCF file
for line in open("/Users/cmdb/qb25-answers/week3/BYxRM_bam/filtered.vcf"):
    if line.startswith('#'):
        continue
    
    # split the line into fields by tab, then
    fields = line.rstrip('\n').split('\t')
    chrom = fields[0]
    pos   = fields[1]
    
    # for each sample in sample_ids:
        # get the sample's data from fields[9], fields[10], ...
        # genotypes are represented by the first value before ":" in that sample's data
        # if genotype is "0" then print "0"
        # if genotype is "1" then print "1"
        # otherwise skip