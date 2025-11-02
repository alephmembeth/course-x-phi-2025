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
