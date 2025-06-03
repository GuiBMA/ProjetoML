# Lung Cancer Dataset Analysis - R script
# Author: Guilherme Almeida, Ian, João Campelo

# Load required packages
library(tidyverse)
library(caret)
library(randomForest)
library(pROC)

# Read dataset
data <- read.csv("dataset_med.csv", stringsAsFactors = FALSE)

# Preprocessing
# Convert gender
data$gender <- factor(data$gender,
                      levels = c("M", "F"),
                      labels = c("Male", "Female"))

# List of binary variables coded 1/2
bin_vars <- c("Smoking", "Yellow.Fingers", "Anxiety", "Peer.Pressure",
              "Chronic.Disease", "Fatigue", "Allergy", "Wheezing",
              "Alcohol.Consuming", "Coughing", "Shortness.of.Breath",
              "Swallowing.Difficulty", "Chest.Pain")

# Convert binary predictors to factors Yes/No
for (v in bin_vars) {
  data[[v]] <- factor(data[[v]],
                      levels = c(1, 2),
                      labels = c("No", "Yes"))
}

# Convert target to factor
data$Lung.Cancer <- factor(data$Lung.Cancer,
                           levels = c("NO", "YES"),
                           labels = c("No", "Yes"))


# Q1: Age distribution (patients with cancer)
age_stats <- data %>%
  filter(Lung.Cancer == "Yes") %>%
  summarise(
    mean_age = mean(Age),
    median_age = median(Age),
    sd_age = sd(Age),
    q1_age = quantile(Age, 0.25),
    q3_age = quantile(Age, 0.75),
    min_age = min(Age),
    max_age = max(Age)
  )
print(age_stats)

# Histogram saved to PDF
pdf("age_histogram.pdf")
ggplot(data %>% filter(Lung.Cancer == "Yes"), aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "grey70", color = "black") +
  labs(
    title = "Age Distribution of Lung Cancer Patients",
    x = "Age (years)",
    y = "Count"
  ) +
  theme_minimal()
dev.off()


# Q2: Smoking vs Lung Cancer
tab_smoke <- table(data$Smoking, data$Lung.Cancer)
print(tab_smoke)
chi_smoke <- chisq.test(tab_smoke)
print(chi_smoke)


# Q3: Gender proportions among cancer cases
sex_tab <- table(data$Gender, data$Lung.Cancer)
print(sex_tab)
prop_cancer_gender <- prop.table(sex_tab, 2)
print(prop_cancer_gender)

# Two-proportion test among cancer cases only
sex_cancer <- sex_tab[, "Yes"]
prop_test <- prop.test(sex_cancer, p = c(0.5, 0.5))
print(prop_test)


# Q4: Alcohol vs Lung Cancer
tab_alcohol <- table(data$Alcohol.Consuming, data$Lung.Cancer)
print(tab_alcohol)
chi_alcohol <- chisq.test(tab_alcohol)
print(chi_alcohol)


# Machine Learning Models
set.seed(123)  # Reproducibility
train_index <- createDataPartition(data$Lung.Cancer, p = 0.80, list = FALSE)
trainData <- data[train_index, ]
testData  <- data[-train_index, ]

# Logistic Regression
log_model <- glm(
  Lung.Cancer ~ .,
  data = trainData,
  family = binomial(link = "logit")
)

# Predict on test
log_prob <- predict(log_model, newdata = testData, type = "response")
log_pred <- factor(ifelse(log_prob > 0.5, "Yes", "No"), levels = c("No", "Yes"))

conf_log <- confusionMatrix(log_pred, testData$Lung.Cancer, positive = "Yes")
print(conf_log)

# ROC & AUC for Logistic Regression
roc_log <- roc(
  testData$Lung.Cancer,
  log_prob,
  levels = c("No", "Yes"),
  direction = "<"
)
auc_log <- auc(roc_log)
print(paste("AUC (Logistic):", auc_log))

# Random Forest
rf_model <- randomForest(
  Lung.Cancer ~ .,
  data = trainData,
  ntree = 100,
  mtry = 4,
  importance = TRUE
)

# Predict on test
rf_pred <- predict(rf_model, newdata = testData)
conf_rf <- confusionMatrix(rf_pred, testData$Lung.Cancer, positive = "Yes")
print(conf_rf)

rf_prob <- predict(rf_model, newdata = testData, type = "prob")[, "Yes"]
roc_rf <- roc(
  testData$Lung.Cancer,
  rf_prob,
  levels = c("No", "Yes"),
  direction = "<"
)
auc_rf <- auc(roc_rf)
print(paste("AUC (Random Forest):", auc_rf))

# Variable importance
imp <- importance(rf_model)
write.csv(imp, "rf_variable_importance.csv", row.names = TRUE)

# Plot variable importance to PDF
pdf("rf_importance.pdf")
varImpPlot(rf_model, main = "Random Forest Variable Importance")
dev.off()

# Plot ROC curves to PDF
pdf("roc_curves.pdf")
plot(roc_log, main = "ROC Curves - Logistic vs Random Forest")
plot(roc_rf, col = "red", add = TRUE)
legend("bottomright", legend = c("Logistic", "Random Forest"), col = c("black", "red"), lwd = 2)
dev.off()
