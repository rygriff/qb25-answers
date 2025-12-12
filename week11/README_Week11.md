# Step 1.1

### How many 100bp reads are needed to sequence a 1Mbp genome to 3x coverage?

(1000000 \* 3)/100 = 30000

# Step 1.4

### In your simulation, how much of the genome has not been sequenced (has 0x coverage)?

49981 positions or 4.9981% of the genome has 0X coverage.

### How well does this match Poisson expectations? How well does the normal distribution fit the data?

| Model / Source       | Zero-Coverage Count | Zero-Coverage % |
|----------------------|--------------------:|----------------:|
| **Observed**         |              49,981 |        4.9981 % |
| **Poisson Expected** |           49,787.07 |        4.9787 % |
| **Normal Expected**  |           51,393.44 |        5.1393 % |

While both models fit pretty well in terms of estimating 0X coverage, the Poisson is more accurate.

# Step 1.5

### In your simulation, how much of the genome has not been sequenced (has 0x coverage)?

140 positions or 0.0140% of the genome have 0× coverage.

### How well does this match Poisson expectations? How well does the normal distribution fit the data?

| Model / Source       | Zero-Coverage Count | Zero-Coverage % |
|----------------------|--------------------:|----------------:|
| **Observed**         |                 140 |        0.0140 % |
| **Poisson Expected** |               45.40 |        0.0045 % |
| **Normal Expected**  |              850.04 |        0.0850 % |

Neither model is as accurate in terms of estimating 0X coverage as when I simulated 3X coverage, but the Poisson is still more accurate.

# Step 1.6

### In your simulation, how much of the genome has not been sequenced (has 0x coverage)?

2 positions or 0.0002% of the genome have 0× coverage.

### How well does this match Poisson expectations? How well does the normal distribution fit the data?

| Model / Source       | Zero-Coverage Count |   Zero-Coverage % |
|----------------------|--------------------:|------------------:|
| **Observed**         |                   2 |          0.0002 % |
| **Poisson Expected** |    0.00000009 (≈ 0) | 0.0000000000094 % |
| **Normal Expected**  |                0.02 |    0.0000000022 % |

Both models are essentially estimating 0% of the genome will be 0X covered.

# Step 2.4

### Now, use dot to produce a directed graph. Record the command you used.

dot -Tpng graph.dot -o ex2_digraph.png

# Step 2.5

### Assume that the maximum number of occurrences of any 3-mer in the actual genome is five. 
### Using your graph from Step 2.4, write one possible genome sequence that would produce these reads.

CTTATTGATTCATTT

# Step 2.6

### In a few sentences, what would it take to accurately reconstruct the sequence of the genome? 

To accurately reconstruct the genome, you would need a de Bruijn graph that correctly represents all the k-mers and their true proportions in the genome. 
Knowing how often each k-mer appears helps determine how many times to visit each edge, especially when loops or repeats are present. 
Even with perfect k-mer counts and graph structure, highly repetitive regions would still be challenging to reconstruct because multiple paths can look equally valid. 
This would make it difficult to determine the exact order of fragments, regardless of how well covered the genome is. 

