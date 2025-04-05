# Projeto de Machine Learning

## Organização de Pastas

```plaintext
Proj.ML/
├── AC/
│   ├── api_iris.R
│   └── modelo_classificacao_iris.rds
├── AP1/
│   ├── data/
│   │   └── WA_Fn-UseC_-HR-Employee-Attrition.csv
│   ├── R/
│   │   ├── 01_load_and_clean_data.R
│   │   ├── 02_eda_and_normality.R
│   │   ├── 03_correlation_and_models.R
│   │   └── 04_api.R
│   ├── outputs/
│   │   ├── plots/
│   │   └── metrics/
│   ├── docs/
│   │   └── relatorio_final.md
│   └── api.R
├── README.md
└── requirements.txt
```

## AP1:

### IBM HR Analytics – Projeto de Machine Learning

Este projeto analisa o conjunto de dados de RH da IBM para prever a renda e a rotatividade de funcionários utilizando modelos básicos de ML em R.

#### 📊 Tarefas Concluídas

- Limpeza de dados e análise exploratória
- Análise de normalidade e correlação
- Regressão linear simples
- Regressão logística
- Deploy de API REST utilizando plumber

#### 🚀 Como Executar a API
1. Clone o repositório
2. Instale os pacotes R necessários
3. Execute:

```bash
library(plumber)
pr("api.R") |> pr_run(port = 8000)
```