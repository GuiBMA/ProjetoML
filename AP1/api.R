#* @apiTitle HR Attrition & Income API

# Load required packages and models
library(tidyverse)

# Load model and data
hr_data <- read_csv("WA_Fn-UseC_-HR-Employee-Attrition.csv") |>
  janitor::clean_names()

# Prepare logistic and linear models
hr_data <- hr_data |>
  mutate(attrition = factor(attrition, levels = c("No", "Yes")))

lm_model <- lm(monthly_income ~ total_working_years, data = hr_data)
log_model <- glm(attrition ~ monthly_income, data = hr_data, family = "binomial")

#* Predict Monthly Income
#* @param years_worked Total working years
#* @get /prediction
function(years_worked) {
  years_worked <- as.numeric(years_worked)
  y_pred <- predict(lm_model, newdata = data.frame(total_working_years = years_worked))
  list(predicted_monthly_income = round(y_pred, 2))
}

#* Classify Attrition
#* @param income Monthly income
#* @get /classification
function(income) {
  income <- as.numeric(income)
  prob <- predict(log_model, newdata = data.frame(monthly_income = income), type = "response")
  class <- ifelse(prob > 0.5, "Yes", "No")
  list(predicted_attrition = class, probability = round(prob, 3))
}
