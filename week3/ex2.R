library(ggplot2)
af <- read.table("/Users/cmdb/qb25-answers/week3/AF.txt", header = TRUE)
af$AF <- as.numeric(af$AF)
p1 <- ggplot(af, aes(x = AF)) +
  geom_histogram(
    bins = 11,
    fill = "skyblue",
    color = "white"
  ) +
  labs(
    title = "Allele Frequency Spectrum",
    x = "Allele Frequency",
    y = "Number of Variants"
  ) +
  theme_minimal(base_size = 14)
print(p1)
#2.1: The histogram shows a binomial-like distribution, with most variants having intermediate allele frequencies (around 0.5). This is expected because the dataset represents a population of segregants from a cross between two yeast strains. For loci that differ between the parental strains, each allele should appear in roughly 50% of the haploid offspring.

dp <- read.table("/Users/cmdb/qb25-answers/week3/DP.txt", header = TRUE)
dp$DP <- as.numeric(dp$DP)
p2 <- ggplot(dp, aes(x = DP)) +
  geom_histogram(
    bins = 21,
    fill = "skyblue",
    color = "white"
  ) +
  labs(
    title = "Read Depth Distribution",
    x = "Read Depth (DP)",
    y = "Count"
  ) +
  xlim(0, 20) +  
  theme_minimal(base_size = 14)

print(p2)

#2.2: The histogram shows that most variants have a per-sample coverage of 3–7 reads per variant site. This is expected because the sequencing of these samples was not performed at high depth. We would anticipate most sites to have the target coverage (low depth) with a few showing higher coverage due to random variation. This distribution is called a negative binomial.


  
  
  
  
  
  
  
  
  

