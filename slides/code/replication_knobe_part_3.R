# calculate summary statistic
library(magrittr)
library(rstatix)
df %>%
  group_by(Condition) %>%
  get_summary_stats(Ascription, type = "mean_sd")

# calculate Weltch's t-test
stat.test <- df %>% 
  t_test(Ascription ~ Condition) %>%
  add_significance()
stat.test

# calculate Cohen's d
df %>%
  cohens_d(Ascription ~ Condition, var.equal = FALSE)
