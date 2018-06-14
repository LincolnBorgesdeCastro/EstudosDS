# Split-Apply-Combine - plyr

install.packages("plyr")
install.packages("gapminder")
# https://www.gapminder.org

library(plyr)
library(gapminder)

?ddply
# Split-Apply-Combine
df <- ddply(gapminder, ~ continent, 
            summarize, 
            max_le = max(lifeExp))
str(df)
head(df)
levels(df$continent)

# Split-Apply-Combine
ddply(gapminder, ~ continent, 
      summarize, 
      n_uniq_countries = length(unique(country)))

ddply(gapminder, ~ continent, 
      function(x) c(n_uniq_countries = length(unique(x$country))))

ddply(gapminder, ~ continent, 
      summarize,
      min = min(lifeExp), 
      max = max(lifeExp),
      median = median(gdpPercap))


# Usando um dataset do ggplot
library(ggplot2)
data(mpg)
str(mpg)
?mpg

# Trabalhando com um subset do dataset
data <- mpg[,c(1,7:9)]
str(data)


# Sumarizando e Agregando Dados
ddply(data, .(manufacturer), 
      summarize, 
      avgcty = mean(cty))

# Varias funcoes em uma unica chamada
ddply(data, .(manufacturer), 
      summarize, 
      avgcty = mean(cty), 
      sdcty = sd(cty), 
      maxhwy = max(hwy))

# Sumarizando os dados pela combinação de variáveis/fatores
ddply(data, .(manufacturer, drv), 
      summarize, 
      avgcty = mean(cty), 
      sdcty = sd(cty),
      maxhwy = max(hwy))

# *** Obs ***
# Os pacotes reshape/reshape2 sao formas elegantes de agrupar 
# diversas variaveis ao mesmo tempo

# Perceba a diferenca entre summarize e transform
ddply(data, .(drv), summarize, avgcty = mean(cty))
ddply(data, .(drv), transform, avgcty = mean(cty))


