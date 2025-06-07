# Trabalho Final - Análise de Câncer de Pulmão
# Integrantes: Guilherme Almeida, Ian, João Campelo

# Pacotes necessários
library(tidyverse)
library(caret)
library(randomForest)
library(pROC)

# Leitura do dataset com colunas relevantes
data <- read.csv("Ap2\dataset_med.csv", stringsAsFactors = FALSE)[, c(
  "age", "gender", "family_history", "smoking_status", "bmi",
  "cholesterol_level", "hypertension", "asthma", "cirrhosis",
  "other_cancer", "treatment_type", "cancer_stage", "survived"
)]

# Remover linhas com valores ausentes
data <- na.omit(data)

# Transformar target em fator
data$survived <- factor(data$survived, levels = c(0, 1), labels = c("No", "Yes"))

# Converter variáveis categóricas em fatores
categorical_vars <- c("gender", "family_history", "smoking_status", "treatment_type", "cancer_stage")
data[categorical_vars] <- lapply(data[categorical_vars], factor)

# Estatísticas descritivas - distribuição da idade por sobrevida
summary(data$age)
boxplot(age ~ survived, data = data, main = "Idade vs Sobrevivência", ylab = "Idade", col = c("tomato", "lightgreen"))

# Divisão dos dados
set.seed(123)
index <- createDataPartition(data$survived, p = 0.8, list = FALSE)
train <- data[index, ]
test <- data[-index, ]

# ------------------- Regressão Logística -------------------
log_model <- glm(survived ~ ., data = train, family = binomial)
summary(log_model)

# Predição
log_probs <- predict(log_model, test, type = "response")
log_pred <- factor(ifelse(log_probs > 0.5, "Yes", "No"), levels = c("No", "Yes"))

# Avaliação
cat("=== Regressão Logística ===\n")
print(confusionMatrix(log_pred, test$survived, positive = "Yes"))

# Curva ROC e AUC
roc_log <- roc(test$survived, log_probs)
cat("AUC (Logística): ", auc(roc_log), "\n")

# ------------------- Random Forest -------------------
rf_model <- randomForest(survived ~ ., data = train, ntree = 100, importance = TRUE)

# Predição
rf_pred <- predict(rf_model, test)
rf_probs <- predict(rf_model, test, type = "prob")[, "Yes"]

# Avaliação
cat("=== Random Forest ===\n")
print(confusionMatrix(rf_pred, test$survived, positive = "Yes"))

# Curva ROC e AUC
roc_rf <- roc(test$survived, rf_probs)
cat("AUC (Random Forest): ", auc(roc_rf), "\n")

# Importância das variáveis
pdf("rf_importancia.pdf")
varImpPlot(rf_model, main = "Importância das Variáveis - Random Forest")
dev.off()

# ------------------- Curvas ROC -------------------
pdf("roc_comparison.pdf")
plot(roc_log, col = "blue", lwd = 2, main = "Curvas ROC - Modelos")
plot(roc_rf, col = "red", lwd = 2, add = TRUE)
legend("bottomright", legend = c("Logística", "Random Forest"), col = c("blue", "red"), lwd = 2)
dev.off()
