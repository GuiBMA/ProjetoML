# Relatório Final: Projeto de Machine Learning em Análise de RH da IBM

## 1. Apresentação do Conjunto de Dados
- [x] Conjunto de dados do Kaggle: IBM HR Analytics  
- [x] 1470 linhas, 35 variáveis  
- [x] Inclui variáveis contínuas e binárias: adequado para tarefas de regressão.

## 2. Pré-processamento e Análise Exploratória
- Sem valores ausentes  
- Renda com assimetria à direita  
- Rotatividade (attrition) desbalanceada

## 3. Teste de Normalidade
- Variavel `monthly_income` não possui distribuição normal (p < 0,05 para Shapiro/KS)

## 4. Correlação
- Correlação de Pearson forte (r = 0,77) entre renda e experiência

## 5. Regressão Linear Simples
- Modelo: `monthly_income ~ total_working_years`  
- R² = 0,59, MAE ~1200, RMSE ~1500

## 6. Regressão Logística
- Modelo: `attrition ~ monthly_income`  
- Acurácia: 85%, algumas classificações incorretas da classe minoritária

## 7. API REST
- `/prediction`: Prediz renda com base nos anos de trabalho
- `/classification`: Prediz rotatividade com base na renda
- Construída com `plumber`, documentada com Swagger

## 8. Conclusão
Este projeto demonstra modelagem e deploy práticos de ML em R para análise de RH.
