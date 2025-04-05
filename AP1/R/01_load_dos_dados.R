# Load de Bibliotecas
library(tidyverse)
library(janitor)

# Load dataset
hr_data <- read_csv("AP1/data/WA_Fn-UseC_-HR-Employee-Attrition.csv")

# Limpando nome de colunas
hr_data <- hr_data |>
  clean_names()

# Inspeção
glimpse(hr_data)
