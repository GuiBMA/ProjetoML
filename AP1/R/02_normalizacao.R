library(ggplot2)

# Checando valores ausentes
colSums(is.na(hr_data))

# Resumo estatistico
summary(select(hr_data, where(is.numeric)))

# Distribuição de renda por mes
ggplot(hr_data, aes(x = monthly_income)) +
  geom_histogram(binwidth = 1000, fill = "#0073C2FF", color = "white") +
  labs(title = "Distribution of Monthly Income")

# Renda por mes vs idade
ggplot(hr_data, aes(x = age, y = monthly_income)) +
  geom_point(alpha = 0.6) +
  labs(title = "Monthly Income vs Age")

# Attrition distribution
ggplot(hr_data, aes(x = attrition)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Attrition Count")

# Shapiro-Wilk
set.seed(123)
sample_income <- sample(hr_data$monthly_income, 5000)
shapiro.test(sample_income)

# Kolmogorov-Smirnov
ks.test(
  hr_data$monthly_income,
  "pnorm",
  mean = mean(hr_data$monthly_income),
  sd = sd(hr_data$monthly_income)
)
