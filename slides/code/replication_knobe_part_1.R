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
