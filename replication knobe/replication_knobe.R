# read data
df <- read.csv("replication_knobe_data.csv", sep = ';')
print(df)
dput(names(df))

# create fourfold table
table <- xtabs (~ df$Condition + df$Answer)
print(table)

# calculate expected frequencies
n <- sum(table)
ef <- outer (rowSums(table), colSums(table)) / n
print(ef)

# calculate chi-squared test
chisq.test(df$Condition, df$Answer)

# calculate Fisher's exact test
fisher.test(df$Condition, df$Answer)

# calculate Cohen's w
library(rcompanion)
cohenW(df$Condition, df$Answer)

# create bar chart
library(ggplot2)
ggplot(df,
       aes(x = Condition,
           fill = Answer)) +
  geom_bar(position="dodge") +
  ylab("Count") +
  ggtitle("Replication of Study 1 from Knobe (2003) by Students")
ggsave("replication_knobe_fig_1.png")

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

# create boxplot
ggplot(df,
       aes(x=Condition,
           y=Ascription,
           fill=Condition)) +
  theme(legend.position = "none") +
  geom_boxplot() +
  ggtitle("Replication of Study 1 from Knobe (2003) by Students")
ggsave("replication_knobe_fig_2.png")
