library(shiny)
library(ggplot2)
library(dplyr)


data$survived <- factor(data$survived, levels = c(0, 1), labels = c("No", "Yes"))
categorical_vars <- c("gender", "family_history", "smoking_status", "treatment_type", "cancer_stage")
data[categorical_vars] <- lapply(data[categorical_vars], factor)


cores_sobrevivencia <- c("No" = "#E74C3C", "Yes" = "#27AE60")  # Vermelho e Verde

ui <- fluidPage(
  titlePanel("Dashboard Descritivo - Pacientes com Câncer"),
  
  tabsetPanel(
    
    tabPanel("Boxplot: Idade por Sobrevivência",
             br(),
             plotOutput("plot_idade")
    ),
    
    tabPanel("Histograma: Índice de Massa Corporal (BMI)",
             br(),
             sliderInput("bins", "Escolha o número de divisões (bins):", min = 5, max = 50, value = 20),
             plotOutput("plot_bmi")
    ),
    
    tabPanel("Barras: Estágio do Câncer por Sobrevivência",
             br(),
             plotOutput("plot_stage")
    ),
    
    tabPanel("Boxplot: Idade por Gênero e Sobrevivência",
             br(),
             plotOutput("plot_genero_idade")
    )
  )
)


server <- function(input, output) {
  
  output$plot_idade <- renderPlot({
    ggplot(data, aes(x = survived, y = age, fill = survived)) +
      geom_boxplot(width = 0.6, outlier.shape = 21, outlier.fill = "white") +
      scale_fill_manual(values = cores_sobrevivencia) +
      labs(
        title = "Distribuição da Idade por Sobrevivência",
        x = "Sobreviveu?",
        y = "Idade"
      ) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
  output$plot_bmi <- renderPlot({
    ggplot(data, aes(x = bmi)) +
      geom_histogram(bins = input$bins, fill = "#2980B9", color = "white", alpha = 0.85) +
      labs(
        title = "Distribuição do Índice de Massa Corporal (BMI)",
        x = "BMI",
        y = "Frequência"
      ) +
      theme_minimal(base_size = 14)
  })
  
  output$plot_stage <- renderPlot({
    ggplot(data, aes(x = cancer_stage, fill = survived)) +
      geom_bar(position = "dodge") +
      scale_fill_manual(values = cores_sobrevivencia) +
      labs(
        title = "Estágio do Câncer por Sobrevivência",
        x = "Estágio do Câncer",
        y = "Número de Pacientes",
        fill = "Sobreviveu?"
      ) +
      theme_minimal(base_size = 14)
  })
  
  output$plot_genero_idade <- renderPlot({
    ggplot(data, aes(x = gender, y = age, fill = survived)) +
      geom_boxplot(outlier.shape = 21, outlier.fill = "white") +
      scale_fill_manual(values = cores_sobrevivencia) +
      labs(
        title = "Idade por Gênero e Sobrevivência",
        x = "Gênero",
        y = "Idade",
        fill = "Sobreviveu?"
      ) +
      theme_minimal(base_size = 14)
  })
}

# Run app
shinyApp(ui = ui, server = server)