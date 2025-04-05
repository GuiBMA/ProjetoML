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
  years_worked <- as.numeric(years_worked)
  prediction <- predict(lm_model, newdata = data.frame(total_working_years = years_worked))
  list(predicted_monthly_income = round(prediction, 2))
}

#* @param income Monthly income
#* @get /classification
function(income) {
  income <- as.numeric(income)
  probability <- predict(log_model, newdata = data.frame(monthly_income = income), type = "response")
  class <- ifelse(probability > 0.5, "Yes", "No")
  list(predicted_attrition = class, probability = round(probability, 3))
}
