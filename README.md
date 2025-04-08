# Projeto de Machine Learning

## Organização de Pastas

```plaintext
ProjetoML/
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

Segue a documentação da API incorporada ao `README.md`:


#### 📡 Documentação da API

A aplicação disponibiliza uma API REST implementada com `plumber` para previsão de renda mensal e classificação de rotatividade de funcionários com base no dataset de RH da IBM.

##### 🔧 Endpoints

###### `GET /prediction`

**Descrição:** Realiza a predição da renda mensal com base nos anos totais de trabalho usando regressão linear.

**Parâmetros:**

| Nome           | Tipo     | Descrição                     | Obrigatório |
|----------------|----------|-------------------------------|-------------|
| `years_worked` | numérico | Total de anos trabalhados     | Sim         |

**Exemplo de requisição:**

```
GET /prediction?years_worked=10
```

**Resposta:**

```json
{
  "predicted_monthly_income": 5632.78
}
```

---

###### `GET /classification`

**Descrição:** Classifica se o funcionário tende a sair da empresa com base na renda mensal usando regressão logística.

**Parâmetros:**

| Nome     | Tipo     | Descrição              | Obrigatório |
|----------|----------|------------------------|-------------|
| `income` | numérico | Renda mensal (em USD)  | Sim         |

**Exemplo de requisição:**

```
GET /classification?income=4500
```

**Resposta:**

```json
{
  "predicted_attrition": "No",
  "probability": 0.327
}
```

#### 🚀 Como Executar a API
1. Clone o repositório
2. Instale os pacotes R necessários
3. Execute:

```bash
library(plumber)
pr("api.R") |> pr_run(port = 8000)
```
