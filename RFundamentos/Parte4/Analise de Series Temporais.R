# Analise de Series Temporais

# Repositorios de Dados de Series Temporais
# http://robjhyndman.com/tsdldata

# Importando dados com a funcao scan()
?scan
reis <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat", skip = 3)
reis
class(reis)

# Transformando os dados em series temporais
tsreis <- ts(reis)
tsreis
class(tsreis)
plot.ts(tsreis)


nascimentos <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
tsnascimentos <- ts(nascimentos, frequency = 12, start = c(1946, 1))
tsnascimentos
plot.ts(tsnascimentos)


# Pacote forecast
install.packages("forecast")
install.packages("xts")
library(xts)
library(forecast)

# Cotacao de acoes da Petrobras
url <- "http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=2&c=1990&d=05&e=26&f=2016&g=d&ignore=.csv"

# Lendo o conteudo da url para um dataframe
IBM.df <- read.table(url, header = TRUE, sep = ",")		

# Visualizando as primeiras linhas do dataframe
head(IBM.df)				

# Convertendo o dataframe em série temporal
IBM <- xts(IBM.df$Close, as.Date(IBM.df$Date))	
head(IBM)

# Construindo um plot
plot(IBM)		

# Criando um subset do conjunto de dados de series temporais
IBM.2014 <- window(IBM,start="2014-01-01", end="2015-01-01")	

# Plotando
plot(IBM.2014)         
