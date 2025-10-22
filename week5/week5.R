library(tidyverse)
library(dplyr)
library(broom)

#exercise 1

#ex1.1 - load De Novo Mutations (DNMs)
DNM <- read.csv("/Users/cmdb/qb25-answers/week5/aau1043_dnm.csv")
#ex1.2 - Count by parental origin per proband
summary_DNM <- DNM %>%
  group_by(Proband_id, Phase_combined) %>%
  filter(Phase_combined != "") %>%
  summarise(
    count = n()
  )
print(summary_DNM)

#ex1.3 - load parent ages
parent_ages <- read.csv("/Users/cmdb/qb25-answers/week5/aau1043_parental_age.csv")
#ex1.4 - merge counts with ages
parent_ages_DNM <- inner_join(summary_DNM, parent_ages, by = "Proband_id")
print(parent_ages_DNM)

#exercise 2

#ex2.1. 1 - Create a scatter plot of the count of maternal DNMs vs. maternal age → save as ex2_a.png
ex2_a <- ggplot(data = filter(parent_ages_DNM, Phase_combined == "mother"),
       aes(x = Mother_age, y = count)) +
  geom_point() +
  labs(
    title = "Count of Maternal DNMs per Proband vs Maternal Age",
    x = "Maternal Age",
    y = "Count of Maternal DNMs"
  )
ggsave("/Users/cmdb/qb25-answers/week5/ex2_a.png", plot = ex2_a, width = 8)

#ex2.1. 2 - Create a scatter plot of the count of paternal DNMs vs. paternal age → save as ex2_b.png
ex2_b <- ggplot(data = filter(parent_ages_DNM, Phase_combined == "father"),
                aes(x = Father_age, y = count)) +
  geom_point() +
  labs(
    title = "Count of Paternal DNMs per Proband vs Paternal Age",
    x = "Paternal Age",
    y = "Count of Paternal DNMs"
  )
ggsave("/Users/cmdb/qb25-answers/week5/ex2_b.png", plot = ex2_b, width = 8)

#ex2.2 - OLS: maternal age vs. maternal DNMs
#Fit a simple linear regression model relating maternal age to the number of maternal de novo mutations.

lm(data = filter(parent_ages_DNM, Phase_combined == "mother"), formula = count ~ 1 + Mother_age) %>%
  summary()
#2.2.1 the size (slope) of the relationship between count of maternal DNMs and Maternal age is 0.37757. This means that for every additional yera of maternal age we'd expect an additional 0.37757 DNMs. This seems to generally match the scatter plot, as the slope is positive, and less than 1.
#2.2.2 The relationship is significant, as the P-value is <2e-16 (very small). In plain language, the chances that the what the data is showing us (linear relationship) is purely due to chance and not a true correlation, is incredibly small.

#ex2.3 - OLS: paternal age vs. paternal DNMs
#Fit a simple linear regression model relating paternal age to the number of paternal de novo mutations.

lm(data = filter(parent_ages_DNM, Phase_combined == "father"), formula = count ~ 1 + Father_age) %>%
  summary()
#2.3.1 the size (slope) of the relationship between count of paternal DNMs and paternal age is 1.35384. This means that for every additional year of paternal age, you could expect an additional 1.35384 DNMs from paternal gametes. This seems to generally match the scatter plot, as the slope is positive, and significantly more steep than the maternal plot.
#2.3.2 The relationship is significant, as the P-value is <2e-16 (very small). In plain language, the chances that the what the data is showing us (linear relationship) is purely due to chance and not a true correlation, is incredibly small.

#Step 2.4 — Predict for a 50.5-year-old father
#Use the paternal regression model to predict the expected number of paternal DNMs for a father of age 50.5.
#y = 1.35384 (50.5) + 10.32632
#y = 78.69524

#Step 2.5 — Compare distributions of maternal vs. paternal DNMs
merged_data <- parent_ages_DNM %>%
  dplyr::select(Proband_id, Phase_combined, count) %>%
  pivot_wider(
    names_from = Phase_combined,
    values_from = count
  )

print(merged_data)

t.test(merged_data$mother, merged_data$father, paired = TRUE)

# Paired t-test
# data:  merged_data$mother and merged_data$father
# t = -61.609, df = 395, p-value < 2.2e-16
# alternative hypothesis: true mean difference is not equal to 0
# 95 percent confidence interval:
#   -40.48685 -37.98284
# sample estimates:
#   mean difference 
# -39.23485 

#1. What is the “size” of this relationship (i.e., the average difference in counts of maternal and paternal DNMs)? 
#Interpret the difference in plain language. Does it match your plot? 

#Average difference is -39.23485 which means that fathers contribute about 39 more DNMs per proband than mothers. This matches the plots, where the paternal DNM vs Father age plot has DNM counts that go almost up to 90 while the maternal plot only has a y axis that extends to about 40. 

#2. Is the relationship significant? How do you know? Explain the p-value in plain but precise language.

#The relationship is significant. The p value is very small. The p value represents the chance that the relationship we see between the distribution of maternal and paternal DNMs is by chance (essentially 0 in this case). 

lm(I(mother - father) ~ 1, data = merged_data) %>%
  summary()

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -61.765  -7.765   1.235   9.235  30.235 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -39.2348     0.6368  -61.61   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 12.67 on 395 degrees of freedom

#How would you interpret the coefficient estimate for the intercept term?

#The intercept is -39.2348 (aligns with T test) and again can be interpreted as fathers contribute 39.2348 more DNM per proband than mothers.

#Ex3 - "Pixar Films"

#install.packages("tidytuesdayR")

tuesdata <- tidytuesdayR::tt_load(2025, week = 10)
pixar_films <- tuesdata$pixar_films
public_response <- tuesdata$public_response
pixar_data <- inner_join(pixar_films, public_response, by = "film")

print(pixar_data)

pixar_long <- pixar_data %>%
  pivot_longer(
    cols = c(metacritic, rotten_tomatoes, critics_choice),
    names_to = "score_type",
    values_to = "score"
  ) %>%
  filter(score != "NA")

print(pixar_long)

release_date_scores <- ggplot(pixar_long, aes(x = release_date, y = score, color = score_type)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Pixar Film Release Date vs. Review Scores",
    x = "Release Date",
    y = "Score (out of 100)",
    color = "Score Type"
  ) +
  theme_minimal()

ggsave("/Users/cmdb/qb25-answers/week5/release_date_scores.png", plot = release_date_scores, width = 8) 

runtime_scores <- ggplot(pixar_long, aes(x = run_time, y = score, color = score_type)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Pixar Film Run Time vs. Review Scores",
    x = "Run Time",
    y = "Score (out of 100)",
    color = "Score Type"
  ) +
  theme_minimal()

ggsave("/Users/cmdb/qb25-answers/week5/runtimes_scores.png", plot = runtime_scores, width = 8) 

pixar_date_numeric <- pixar_long %>%
  mutate(release_year = as.numeric(format(release_date, "%Y")))

lm_release <- lm(score ~ release_year, data = pixar_date_numeric)
summary(lm_release)

# Call:
#   lm(formula = score ~ release_year, data = pixar_date_numeric)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -45.128  -6.039   2.640   8.634  16.110 
# 
# Coefficients:
#                    Estimate  Std. Error t value Pr(>|t|)   
# (Intercept)       1150.4366   426.7983   2.696  0.00894 **
# release_year        -0.5297     0.2123  -2.495  0.01513 * 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 12.19 on 65 degrees of freedom
# Multiple R-squared:  0.08743,	Adjusted R-squared:  0.07339 
# F-statistic: 6.227 on 1 and 65 DF,  p-value: 0.01513


