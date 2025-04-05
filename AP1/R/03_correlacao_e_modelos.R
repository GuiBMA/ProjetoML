# Correlação: renda vs anos de trabalho
cor.test(
  hr_data$monthly_income,
  hr_data$total_working_years,
  method = "pearson"
)

# Correlação visual
ggplot(hr_data, aes(x = total_working_years, y = monthly_income)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Monthly Income vs Total Working Years")

# Modelo linear 
lm_model <- lm(monthly_income ~ total_working_years, data = hr_data)
summary(lm_model)

# Predições
predictions <- predict(lm_model, hr_data)

# Métricas
library(Metrics)
cat("R²:", summary(lm_model)$r.squared, "\n")
cat("MAE:", mae(hr_data$monthly_income, predictions), "\n")
cat("RMSE:", rmse(hr_data$monthly_income, predictions), "\n")

# Regressão Logistica
hr_data <- hr_data |>
  mutate(attrition = factor(attrition, levels = c("No", "Yes")))

log_model <- glm(attrition ~ monthly_income, data = hr_data, family = "binomial")
summary(log_model)

# Predição de atrito
prob <- predict(log_model, type = "response")
predicted_class <- ifelse(prob > 0.5, "Yes", "No") |>
  factor(levels = c("No", "Yes"))

# Matriz de Cofusão
table(Predicted = predicted_class, Actual = hr_data$attrition)

# Accurácia
mean(predicted_class == hr_data$attrition)
