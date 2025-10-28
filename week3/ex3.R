library(readr)
library(dplyr)
library(ggplot2)

# read and prep
gt <- read_tsv("/Users/cmdb/qb25-answers/week3/gt_long.txt", show_col_types = FALSE) %>%
  mutate(
    pos = as.integer(pos),
    gt  = factor(gt)
  ) %>%
  filter(sample_id == "A01_62", chrom == "chrII")

plot_3.3 <- ggplot(gt, aes(x = pos, y = 0, color = gt)) +
  geom_point(size = 0.8, alpha = 0.9) +
  labs(
    title = "Ancestry along chrII sample A01_62",
    x = "chrII Position (bp)",
    y = NULL,
    color = "Genotype"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
ggsave("/Users/cmdb/qb25-answers/week3/plot_3.3.png", width = 8)

#Question 3.2: Do you notice any patterns? What do the transitions indicate?
## I notice longish stectches of one clor and than a sudden switch to the other gt. Switch point (positions along the chromosome where the ancestory switches from 0 to 1) represent recombination points. 
  

gt_all <- read_tsv("/Users/cmdb/qb25-answers/week3/gt_long.txt", show_col_types = FALSE) %>%
  mutate(
    pos = as.integer(pos),
    gt  = factor(gt) 
  )

gt_62 <- gt_all %>%
  filter(sample_id == "A01_62")

plot_3.4A <- ggplot(gt_62, aes(x = pos, y = 0, color = gt)) +
  geom_point(size = 0.6, alpha = 0.9) +
  facet_grid(chrom ~ ., scales = "free_x", space = "free_x") +
  labs(
    title = "Genotype along all chromosomes — sample A01_62",
    x = "Position (bp)",
    y = NULL,
    color = "Genotype"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.spacing.x = unit(6, "pt")
  )

plot_3.4A
ggsave("/Users/cmdb/qb25-answers/week3/plot_3.4A.png", plot_3.4A, width = 24)

plot_3.4B <- ggplot(gt_all, aes(x = pos, y = sample_id, color = gt)) +
  geom_point(size = 0.5, alpha = 0.8) +
  facet_grid(chrom ~ ., scales = "free_y", space = "free_y") +  # stack chromosomes vertically
  labs(
    title = "Genotype across chromosomes — all samples",
    x = "Position (bp)",
    y = "Sample",
    color = "Genotype"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.spacing.y = unit(6, "pt"),
    strip.text.y = element_text(angle = 0),  # keep facet labels horizontal
    legend.position = "right"
  )

plot_3.4B

ggsave("/Users/cmdb/qb25-answers/week3/plot_3.4B.png", plot_3.4B, width = 10, height = 20)

