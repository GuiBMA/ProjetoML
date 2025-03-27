data(iris)
iris_bin$Species <- factor(iris_bin$Species)
iris_bin <- subset(iris, Species %in% c("setosa", "versicolor"))
iris_bin$Species <- factor(iris_bin$Species)
str(iris_bin)
modelo_log <- glm(Species ~ Sepal.Length + Sepal.Width + Petal.Length
                  + Petal.Width, data = iris_bin, family = binomial)
summary(modelo_log)
probabilidades <- predict(modelo_log, type = "response")
head(probabilidades)
predicoes <- ifelse(probabilidades > 0.5, "versicolor", "setosa")
predicoes <- factor(predicoes, levels = levels(iris_bin$Species))
tabela_confusao <- table(Predito = predicoes, Real = iris_bin$Species)
print(tabela_confusao)



library(caret)
library(jsonlite)
library(plumber)

#* @apiTitle API de Regressão Linear com o dataset iris
#* @param Petal.Length
#* @param Petal.Width
#* @param Sepal.Width
#* @param Sepal.Length
#* @get /prever
function(Petal.Length, Petal.Width, Sepal.Width, Sepal.Length) {
  Petal.Length <- as.numeric(Petal.Length)
  Petal.Width <- as.numeric(Petal.Width)
  Sepal.Width <- as.numeric(Sepal.Length)
  Sepal.Length <- as.numeric(Sepal.Length)
  
  if(is.na(Petal.Length)) {
    return(list(error = "Parâmetro inválido"))
  }
  if(is.na(Petal.Width)) {
    return(list(error = "Parâmetro inválido"))
  }
  if(is.na(Sepal.Width)) {
    return(list(error = "Parâmetro inválido"))
  }
  if(is.na(Sepal.Length)) {
    return(list(error = "Parâmetro inválido"))
  }
  
  predicao <- predict(modelo_log, newdata = data.frame(Petal.Length = Petal.Length, 
                                                       Petal.Width = Petal.Width,
                                                       Sepal.Width = Sepal.Width,
                                                       Sepal.Length = Sepal.Length))
  
  classe_prevista <- ifelse(predicao > 0.5, "versicolor", "setosa")
  
  
  return(list(
    comprimento_petala = Petal.Length,
    comprimento_sepala = Sepal.Length,
    largura_petala = Petal.Width,
    largura_sepala = Sepal.Width,
    previsao = classe_prevista
  ))
} 