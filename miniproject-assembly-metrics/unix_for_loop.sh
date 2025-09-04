#!/bin/bash 

cd /Users/cmdb/qb25-answers/miniproject-assembly-metrics

for fasta in *.fa; do echo $fasta >> README.md; python3 assembly-metrics.py $fasta >> README.md; done


