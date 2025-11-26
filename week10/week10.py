#!/usr/bin/env python3

import sys

import numpy as np

from fasta import readFASTA


#====================#
# Read in parameters #
#====================#

# Read in the actual sequences using readFASTA

input_sequences = readFASTA(open(sys.argv[1]))

seq1_id, sequence1 = input_sequences[0]
seq2_id, sequence2 = input_sequences[1]

# The scoring matrix is assumed to be named "sigma_file" and the 
# output filename is assumed to be named "out_file" in later code


# Read the scoring matrix into a dictionary
fs = open(sys.argv[2])
sigma = {}
alphabet = fs.readline().strip().split()
for line in fs:
	line = line.rstrip().split()
	for i in range(1, len(line)):
		sigma[(alphabet[i - 1], line[0])] = float(line[i])
fs.close()

#=====================#
# Initialize F matrix #
#=====================#

f_matrix = np.zeros((len(sequence1) + 1, len(sequence2) + 1), dtype = float)
#print(f_matrix)


#=============================#
# Initialize Traceback Matrix #
#=============================#
tb_matrix = np.zeros((len(sequence1) + 1, len(sequence2) + 1), dtype = float)
#print(f_matrix)

#===================#
# Populate Matrices #
#===================#


# fill in gap penalties

gap_penalty = float(sys.argv[3]) #Help from friend

d = 1 # "go diag"
h = 2 # "go left"
v = 3 # "go up"

for i in range (1, len(sequence1) + 1):
	f_matrix[i, 0] = f_matrix[i -1, 0] + gap_penalty
	tb_matrix[i, 0] = v
for j in range(1, len(sequence2) + 1):
	f_matrix[0, j] = f_matrix[0, j -1] + gap_penalty
	tb_matrix[0, j] = h


#print(f_matrix)


for i in range(1, len(sequence1) + 1):
	for j in range (1, len(sequence2) + 1):
		v_score = gap_penalty + f_matrix[i - 1, j]
		h_score = gap_penalty + f_matrix[i, j - 1]
		d_score = sigma[(sequence1[i - 1],sequence2[j - 1])] + f_matrix[i - 1, j - 1]
		f_matrix[i, j] = max(v_score, h_score, d_score)
		if f_matrix[i, j] == d_score:
			tb_matrix[i, j] = d
		elif f_matrix[i, j] == h_score:
			tb_matrix[i, j] = h
		else:
			tb_matrix[i, j] = v
		
#print(f_matrix)
#print(tb_matrix)

#========================================#
# Follow traceback to generate alignment #
#========================================#
seq1 = ""
seq2 = ""
i = len(sequence1)
j = len(sequence2)
while i >0 or j >0: 
	if tb_matrix[i, j] == d:
		seq1 = sequence1[i -1] + seq1
		seq2 = sequence2[j -1] + seq2
		i = i -1
		j = j -1
	elif tb_matrix[i, j] == h:
		seq1 = "-" + seq1
		seq2 = sequence2[j -1] + seq2
		j = j - 1
	elif tb_matrix[i, j] == v:
		seq1 = sequence1[i -1] + seq1
		seq2 = "-" + seq2
		i = i - 1
	#print(i,j)

#=================================#
# Generate the identity alignment #
#=================================#

# This is just the bit between the two aligned sequences that
# denotes whether the two sequences have perfect identity
# at each position (a | symbol) or not.

identity_alignment = ''
for i in range(len(seq1)):
	if seq1[i] == seq2[i]:
		identity_alignment += '|'
	else:
		identity_alignment += ' '

#print(seq1)
#print(identity_alignment)
#print(seq2)	

#===========================#
# Write alignment to output #
#===========================#

# Certainly not necessary, but this writes 100 positions at
# a time to the output, rather than all of it at once.

output = open(sys.argv[4], 'w')

for i in range(0, len(identity_alignment), 100):
	output.write(seq1[i:i+100] + '\n')
	output.write(identity_alignment[i:i+100] + '\n')
	output.write(seq2[i:i+100] + '\n\n\n')

#=============================#
# Calculate sequence identity #
#=============================#

alignment_length = len(identity_alignment)
matches = identity_alignment.count("|")
percent_sequence_id = matches / alignment_length

#print(matches)
#print(alignment_length)
#print(percent_sequence_id)


#======================#
# Print alignment info #
#======================#
print(
    f"Percent Sequence Identity: {percent_sequence_id*100:.2f}%\n"
    f"Gaps in Sequence 1: {seq1.count('-')}\n"
    f"Gaps in Sequence 2: {seq2.count('-')}\n"
    f"Alignment Score: {f_matrix[len(sequence1), len(sequence2)]}"
)

# You need the number of gaps in each sequence, 
# the sequence identity in each sequence, 
# and the total alignment score