# Google Analytics Dashboard com Shiny
# ui.R é o código para interface com o usuário

# ***** Esta é a versão 2.0 deste script, atualizado em 10/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilização da versão 3.4.0 da linguagem R *****

# Pacotes
# Instalar os pacotes no console do RStudio, caso não estejam instalados no seu computador
# Para instalar os pacotes, digite: install.packages("nome_pacote")

#install.packages("shinydashboard")
#install.packages("shinyBS")
#install.packages("leaflet")

library(shiny)
library(shinydashboard)
library(shinyBS)
library(leaflet)

header <- dashboardHeader(title = "IPASGO1 Analytics", dropdownMenuOutput("notifications"))

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", 
             icon = icon("dashboard")),
    
    menuItem("Mapas", icon = icon("globe"), tabName = "map",
             badgeColor = "red"),
    
    dateRangeInput(inputId = "dateRange", label = "Período de Data", 
                   start = "2013-05-01"), 
    
    radioButtons(inputId = "outputRequired", 
                 label = "Selecione uma Opção", 
                 choices = list("Tempo Médio de Sessão" = "meanSession", 
                                "Usuários" = "users", 
                                "Sessões" = "sessions")),
    
    checkboxInput("smooth", label = "Adicionar Margem de Erro?",
                  value = FALSE),
    
    actionButton("showData", "Mostrar os Dados de Conexão")
  )
)

body <- dashboardBody(
  bsModal(id = "clientData", title = "Client Data", 
          trigger = "showData", 
          verbatimTextOutput("clientdataText")),
  tabItems(
    tabItem(tabName = "dashboard",
            fluidRow(
              infoBoxOutput(width = 3, "days"),
              infoBoxOutput(width = 3, "users"),
              infoBoxOutput(width = 3, "percentNew"),
              infoBox(width = 3, "Versão do Shiny", "0.12",
                      icon = icon("desktop"))),
            fluidRow(
              box(width = 5, plotOutput("trend")),
              box(width = 2, htmlOutput("gauge")),
              box(width = 5, plotOutput("histogram"))
            )
    ),
    
    tabItem(tabName = "map",
            box(width = 6, plotOutput("ggplotMap")),
            box(width = 6, leafletOutput("leaflet")))
  )
)

dashboardPage(header, sidebar, body)
