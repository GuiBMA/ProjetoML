#* @apiTitle HR Analytics Prediction API

library(tidyverse)

hr_data <- read_csv("data/WA_Fn-UseC_-HR-Employee-Attrition.csv") |>
  janitor::clean_names() |>
  mutate(attrition = factor(attrition, levels = c("No", "Yes")))

lm_model <- lm(monthly_income ~ total_working_years, data = hr_data)
log_model <- glm(attrition ~ monthly_income, data = hr_data, family = "binomial")

#* @param years_worked Total working years
#* @get /prediction
function(years_worked) {
  # Validação de entrada
  if (is.na(as.numeric(years_worked))) {
    return(list(error = "Parâmetro years_worked deve ser um número"))
  }
  
  years_worked <- as.numeric(years_worked)
  
  # Validação de faixa
  min_years <- min(hr_data$total_working_years)
  max_years <- max(hr_data$total_working_years)
  
  if (years_worked < min_years || years_worked > max_years) {
    return(list(
      error = paste("Anos de trabalho devem estar entre", min_years, "e", max_years)
    ))
  }
  
  prediction <- predict(lm_model, newdata = data.frame(total_working_years = years_worked))
  list(predicted_monthly_income = round(prediction, 2))
}

#* @param income Monthly income
#* @get /classification
function(income) {
  # Validação de entrada
  if (is.na(as.numeric(income))) {
    return(list(error = "Parâmetro income deve ser um número"))
  }
  
  income <- as.numeric(income)
  
  # Validação de faixa
  min_income <- min(hr_data$monthly_income)
  max_income <- max(hr_data$monthly_income)
  
  if (income < min_income || income > max_income) {
    return(list(
      error = paste("Renda mensal deve estar entre", min_income, "e", max_income)
    ))
  }
  
  probability <- predict(log_model, newdata = data.frame(monthly_income = income), type = "response")
  class <- ifelse(probability > 0.5, "Yes", "No")
  list(predicted_attrition = class, probability = round(probability, 3))
}
