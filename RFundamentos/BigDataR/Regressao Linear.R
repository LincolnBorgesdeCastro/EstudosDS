# Regressao Linear

# Definindo o diretorio de trabalho
setwd("/opt/DSA/MachineLearning/BigDataR")

## Exemplo 1 - Massa de dados aleatoria

# Criando a massa de dados (apesar de aleatoria, y possui 
# uma relacao com os dados de x)
x <- seq(0, 100)
y <- 2 * x + 35

# Imprimindo as variaveis
x
y

# Gerando uma distribuicao normal
y1 <- y + rnorm(101, 0, 50)
y1
hist(y1)

# Plotando o relacionamento
plot(x, y1, pch = 19, xlab = 'X', ylab = 'Y')

# Criando um modelo de Regressao
modelo <- lm(y1 ~ x)
modelo
class(modelo)

# Capturando os coeficentes
a <- modelo$coefficients[1]
b <- modelo$coefficients[2]

# Formula de Regressao
y2 <- a + b*x

# Visualizando a linha de Regressao
lines(x, y2, lwd = 2)

# Simulando outras possiveis linhas de Regressao
y3 <- (y2[51]-50*(b-1))+(b-1)*x
y4 <- (y2[51]-50*(b+1))+(b+1)*x
y5 <- (y2[51]-50*(b+2))+(b+2)*x
lines(x,y3,lty=3)
lines(x,y4,lty=3)
lines(x,y5,lty=3)


## Exemplo 2 - Pesquisa sobre idade e tempo de reacao

# Criando os dados
Idade <- c(9,13,14,21,15,18,20,8,14,23,16,21,10,12,20,
           9,13,5,15,21)

Tempo <- c(17.87,13.75,12.72,6.98,11.01,10.48,10.19,19.11,
           12.72,0.45,10.67,1.59,14.91,14.14,9.40,16.23,
           12.74,20.64,12.34,6.44)

# Grafico de Dispersao (ScatterPlot)
plot(Idade, Tempo, 
     xlab = 'Idade', 
     ylab = 'Tempo de Reacao')

# Criando o Modelo
modelo <- lm(Idade ~ Tempo)
modelo

# Calculando a reta
reta <- 25.75 - 0.93*Idade

# Gerando gráfico
lines(Idade,reta)


# Exemplo 3 - Relacao entre altura e peso

# Criando os dados
alturas = c(176, 154, 138, 196, 132, 176, 181, 169, 150, 175)
pesos = c(82, 49, 53, 112, 47, 69, 77, 71, 62, 78)

plot(pesos, alturas, pch = 16, cex = 1.3, col = "blue", 
     main = "Altura x Peso", 
     xlab = "Peso Corporal (kg)", 
     ylab = "Altura (cm)")

# Criando o modelo
lm(alturas ~ pesos)

# Gerando a linha de Regressao
abline(98.0054, 0.9528)

# Criacao do modelo
modelo <-  lm(alturas ~ pesos)

# Visualizando o modelo
summary(modelo)

# Prevendo os possiveis resultados
previsao <- predict(modelo)
previsao

# Plot
plot(pesos, alturas, pch = 16, cex = 1.3, 
     col = "blue", 
     main = "Altura x Peso", 
     xlab = "Peso (kg)", 
     ylab = "Altura (cm)")

# Construindo a linha de Regressao
abline(lm(alturas ~ pesos)) 

# Obtendo o tamanho de uma das amostras de dados
num <- length(alturas)
num

# Gerando um grafico com os valores residuais
for (k in 1: num)  
  lines(c(pesos[k], pesos[k]), 
        c(alturas[k], previsao[k]))

# Gerando graficos com a distribuicao dos residuos
par(mfrow = c(2,2))
plot(modelo)