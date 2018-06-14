#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#install.packages("speedR")
#install.packages("XLConnect")
#install.packages("XLConnectJars")

library(shiny)
library(ggplot2)
library(RODBC)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Quantidade de usuarios ativos por ano"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("Anos",
                     "Ano:",
                     step = 1,
                     sep = "",
                     min = 2010,
                     max = 2017,
                     value = 2017)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("mpgPlot")
      )
   )
)


# Define server logic required to draw a histogram
server <- function(input, output) {

  # db <- odbcDriverConnect('driver={SQL Server};server=ARGENTINA;database=DW;trusted_connection=true')
  # 
  # dados <-sqlQuery(db, "select d.NUMR_Ano, d.DESC_AnoMes, d.NOME_Mes, count(*)/1000 Quantidade
  #                       from dmcl_FatPessoas p inner join dmcl_DimDatas d on p.NUMG_DataReferencia = d.NUMG_Data
  #                       where d.NUMR_Ano >= 2010 
  #                       and p.FLAG_Excluido = 0
  #                       and p.FLAG_Bloqueado = 0
  #                       group by d.NUMR_Ano, d.DESC_AnoMes, d.NOME_Mes
  #                       order by d.DESC_AnoMes")
  
  #setwd("D:\\Estudos\\Teste Shiny\\app\\")
  
  dados <- read.csv2("Dados.csv", head = TRUE,  sep = "\t", skipNul = TRUE, fileEncoding="UCS-2LE")
   
  #View(dados)  
  #dadosMes <- subset(dados, dados["NUMR_Ano"]==2017)
  
  output$mpgPlot <- renderPlot({

    dadosMes <- subset(dados, dados["NUMR_Ano"]==input$Anos)
    
    dadosMes$NOME_Mes = factor(dadosMes$NOME_Mes, levels = dadosMes$NOME_Mes[order(dadosMes$DESC_AnoMes)] )
    
    ggplot(dadosMes, aes(x = dadosMes$NOME_Mes, y = dadosMes$Quantidade, color = dadosMes$Quantidade)) +
    geom_col(col="black", 
             fill="green", 
             alpha = .2,
             show.legend = FALSE) +
    geom_text(aes(label = paste(dadosMes$Quantidade,"K"), y = dadosMes$Quantidade + 0.05),
              color = "black",
              position = position_dodge(0.9),
              show.legend=FALSE,
              vjust = -0.5) +
    theme(axis.title.x = element_blank()) +         
    labs(title="Quantidade de usuarios ativos", fill = "NOME_Mes") +
    labs(x="Meses", y=NULL)
      
   })
  #close(db)
}


# Run the application 
shinyApp(ui = ui, server = server)

