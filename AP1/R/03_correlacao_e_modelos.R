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
metrics_lm <- data.frame(
  R2 = summary(lm_model)$r.squared,
  MAE = mae(hr_data$monthly_income, predictions),
  RMSE = rmse(hr_data$monthly_income, predictions),
  MAPE = mape(hr_data$monthly_income, predictions),
  AIC = AIC(lm_model),
  BIC = BIC(lm_model)
)

# Criar diretório se não existir
dir.create("AP1/outputs/metrics", recursive = TRUE, showWarnings = FALSE)

# Salvar métricas
write.csv(metrics_lm, "AP1/outputs/metrics/metricas_modelo_linear.csv", row.names = FALSE)

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

# Métricas do modelo logístico
metrics_log <- data.frame(
  AIC = AIC(log_model),
  BIC = BIC(log_model),
  Deviance = deviance(log_model),
  Null_Deviance = log_model$null.deviance,
  Accuracy = mean(predicted_class == hr_data$attrition)
)

# Salvar métricas do modelo logístico
write.csv(metrics_log, "AP1/outputs/metrics/metricas_modelo_logistico.csv", row.names = FALSE)

# Matriz de Confusão
conf_matrix <- as.data.frame.matrix(table(Predicted = predicted_class, Actual = hr_data$attrition))
write.csv(conf_matrix, "AP1/outputs/metrics/matriz_confusao.csv", row.names = TRUE)
