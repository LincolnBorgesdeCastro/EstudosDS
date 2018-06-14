# Este codigo contem comandos para filtrar e transformar os dados de aluguel de bikes, dados que estao em nosso dataset
# Este codigo foi criado para executar tanto no Azure, quanto no RStudio.
# Para executar no Azure, altere o valor da variavel Azure para TRUE. Se o valor for FALSE, o codigo sera executado no RStudio

# Configuracao do diretorio de trabalho
# setwd("/opt/DSA/MachineLearning/Azure/Regressao")

# Variavel que controla a execucao do script
Azure <- FALSE

# Execucao de acordo com o valor da variavel Azure
if(Azure){
  source("src/Tools.R")
  bikes <- maml.mapInputPort(1)
  bikes$dteday <- set.asPOSIXct(bikes)
}else{
  source("Tools.R")
  bikes <- read.csv("bikes.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE )
  
  ## Selecionar as variaveis que serao usadas
  cols <- c("dteday", "mnth", "hr", "holiday",
            "workingday", "weathersit", "temp",
            "hum", "windspeed", "cnt")
  
  # Criando um subset dos dados
  bikes <- bikes[, cols]
  
  ## Transformar o objeto de data
  bikes$dteday <- char.toPOSIXct(bikes)
  
  ## Normalizar as variaveis preditoras numericas 
  cols <- c("temp", "hum", "windspeed") 
  bikes[, cols] <- scale(bikes[, cols])  
}

#?scale
#str(bikes)

## Criar uma nova variavel para indicar dia da semana (workday)
bikes$isWorking <- ifelse(bikes$workingday & !bikes$holiday, 1, 0)  

## Adicionar uma coluna com a quantidade de meses, o que vai ajudar a criar o modelo
bikes <- month.count(bikes)

## Criar um fator ordenado para o dia da semana, comecando por segunda-feira
## Neste fator eh convertido para ordenado numerico para ser compativel com os tipos de dados do Azure ML
bikes$dayWeek <- as.factor(ordered(weekdays(bikes$dteday), 
                           labels = c("Monday", 
                                      "Tuesday", 
                                      "Wednesday", 
                                      "Thursday", 
                                      "Friday", 
                                      "Saturday", 
                                      "Sunday")))

bikes$dayWeek <- as.numeric(ordered(bikes$dayWeek, 
                                    levels = c("Monday", 
                                               "Tuesday", 
                                               "Wednesday", 
                                               "Thursday", 
                                               "Friday", 
                                               "Saturday", 
                                               "Sunday")))

# str(bikes)

## Adiciona uma variavel com valores unicos para o horario do dia para dias da semana e dias de fim de semana
## Com isso diferenciamos as horas dos dias da semana, das horas em dias de fim de semana
bikes$workTime <- ifelse(bikes$isWorking, bikes$hr, bikes$hr + 24) 

## Transforma os valores de hora na madrugada, quando a demanda por bibicletas eh praticamente nula 
bikes$xformHr <- ifelse(bikes$hr > 4, bikes$hr - 5, bikes$hr + 19)

## Adiciona uma variavel com valores unicos para o horario do dia para dias da semana e dias de fim de semana
bikes$xformWorkHr <- ifelse(bikes$isWorking, bikes$xformHr, bikes$xformHr + 24) 

# str(bikes)

## Gera saida no Azure ML
if(Azure) maml.mapOutputPort('bikes')

