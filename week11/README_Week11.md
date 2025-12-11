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
