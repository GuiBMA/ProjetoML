# ---------------------- PACOTES NECESSÁRIOS ----------------------
library(tidyverse)
library(caret)
library(randomForest)
library(pROC)

# ---------------------- LEITURA E PRÉ-PROCESSAMENTO ----------------------
data <- read.csv("Ap2\dataset_med.csv", stringsAsFactors = FALSE)[, c(
  "age", "gender", "family_history", "smoking_status", "bmi",
  "cholesterol_level", "hypertension", "asthma", "cirrhosis",
  "other_cancer", "treatment_type", "cancer_stage", "survived"
)]
data <- na.omit(data)
data$survived <- factor(data$survived, levels = c(0, 1), labels = c("No", "Yes"))
categorical_vars <- c("gender", "family_history", "smoking_status", "treatment_type", "cancer_stage")
data[categorical_vars] <- lapply(data[categorical_vars], factor)

# ---------------------- ANÁLISE DESCRITIVA ----------------------
summary(data$age)
boxplot(age ~ survived, data = data, main = "Idade vs Sobrevivência", ylab = "Idade", col = c("tomato", "lightgreen"))

# ---------------------- DIVISÃO TREINO/TESTE ----------------------
set.seed(123)
index <- createDataPartition(data$survived, p = 0.8, list = FALSE)
train <- data[index, ]
test <- data[-index, ]

# ---------------------- REGRESSÃO LOGÍSTICA ORIGINAL ----------------------
log_model <- glm(survived ~ ., data = train, family = binomial)
log_probs <- predict(log_model, test, type = "response")
log_pred <- factor(ifelse(log_probs > 0.5, "Yes", "No"), levels = c("No", "Yes"))
cat("=== Logística ORIGINAL ===\n")
print(confusionMatrix(log_pred, test$survived, positive = "Yes"))
roc_log <- roc(test$survived, log_probs)
cat("AUC (Logística): ", auc(roc_log), "\n")

# ---------------------- RANDOM FOREST ORIGINAL ----------------------
rf_model <- randomForest(survived ~ ., data = train, ntree = 100, importance = TRUE)
rf_pred <- predict(rf_model, test)
rf_probs <- predict(rf_model, test, type = "prob")[, "Yes"]
cat("=== Random Forest ===\n")
print(confusionMatrix(rf_pred, test$survived, positive = "Yes"))
roc_rf <- roc(test$survived, rf_probs)
cat("AUC (Random Forest): ", auc(roc_rf), "\n")

# ---------------------- MELHORIAS: NORMALIZAÇÃO ----------------------
num_vars <- c("age", "bmi", "cholesterol_level")
train[num_vars] <- scale(train[num_vars])
test[num_vars] <- scale(test[num_vars])

# ---------------------- MELHORIAS: BALANCEAMENTO ----------------------
set.seed(123)
train_bal <- downSample(x = train[, -which(names(train) == "survived")],
                        y = train$survived,
                        yname = "survived")

# ---------------------- LOGÍSTICA COM MELHORIAS ----------------------
log_model_bal <- glm(survived ~ ., data = train_bal, family = binomial)
log_probs_bal <- predict(log_model_bal, test, type = "response")

# Limiar padrão (0.5)
log_pred_bal <- factor(ifelse(log_probs_bal > 0.5, "Yes", "No"), levels = c("No", "Yes"))
cat("=== Logística BALANCEADA (limiar 0.5) ===\n")
print(confusionMatrix(log_pred_bal, test$survived, positive = "Yes"))

# Limiar ajustado (0.3)
log_pred_bal_03 <- factor(ifelse(log_probs_bal > 0.3, "Yes", "No"), levels = c("No", "Yes"))
cat("=== Logística BALANCEADA (limiar 0.3) ===\n")
print(confusionMatrix(log_pred_bal_03, test$survived, positive = "Yes"))

# ROC do modelo balanceado
roc_bal <- roc(test$survived, log_probs_bal)
cat("AUC (Logística Balanceada): ", auc(roc_bal), "\n")

# ---------------------- CURVAS ROC COMPARATIVAS ----------------------
plot(roc_log, col = "blue", lwd = 2, main = "Curvas ROC - Comparativo")
plot(roc_rf, col = "red", lwd = 2, add = TRUE)
plot(roc_bal, col = "darkgreen", lwd = 2, add = TRUE)
legend("bottomright",
       legend = c("Logística Original", "Random Forest", "Logística Balanceada"),
       col = c("blue", "red", "darkgreen"), lwd = 2)
