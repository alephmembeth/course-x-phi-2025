# create boxplot
ggplot(df,
       aes(x=Condition,
           y=Ascription,
           fill=Condition)) +
  theme(legend.position = "none") +
  geom_boxplot() +
  ggtitle("Replication of Study 1 from Knobe (2003) by Students")
ggsave("replication_knobe_fig_2.png")
