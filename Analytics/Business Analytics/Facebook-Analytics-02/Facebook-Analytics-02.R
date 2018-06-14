# Facebook Analytics
# https://github.com/pablobarbera/Rfacebook

# ***** Esta e a versão 2.0 deste script, atualizado em 04/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilizacao da versão 3.4.0 da linguagem R *****

# Pasta de trabalho
setwd("D:\\Pessoal\\Estudos\\DSA\\Business Analytics\\Facebook-Analytics-02\\")

# Instalando pacote RFacebook a partir do Github
library(devtools)
#install_github("pablobarbera/Rfacebook", subdir = "Rfacebook", force = TRUE)

# Carregando o pacote
library(Rfacebook)

# Usando token com duracao de 2 horas
token <- "6edc93994e2b9055d97a74f92f58308e"

# Configurando autenticacao
# https://developers.facebook.com/apps/
require("Rfacebook")

# Autenticando por 2 meses
fb_oauth <- fbOAuth(app_id = "144474322965288", app_secret = "7bb3ef46dae54ea980e17abc5936259c", extended_permissions = TRUE)

# Salvando a configuracao
save(fb_oauth, file = "fb_oauth")
load("fb_oauth")


## Dados de Paginas no Facebook

# Obtcam dados de uma pagina
?getPage
page <- getPage("ipasgosaude", token, n = 400)
View(page)
class(page)

# Busca por paginas
?searchPages
pages <- searchPages(string = "IPASGO", token = token, n = 200)
View(pages)

# Post com maior numero de likes
page[which.max(page$likes_count), ]

# Filtrando pela data mais recente
pageRecent <- page[which(page$created_time > "2017-04-02"), ]

# Ordenando pelo numero de likes
top <- pageRecent[order(- pageRecent$likes),]
head(top, n = 2)

# Verificando trend
post1 <- getPost("207042172664303_1471408149561026", token, n = 1000, likes = FALSE, comments = FALSE)
post2 <- getPost("207042172664303_1358551147513394", token, n = 1000, likes = FALSE, comments = FALSE)
View(post1)


# Usando Linguagem SQL e Minerando dados do Facebook
post_id <- head('207042172664303_1358551147513394', n = 1)  

# Busca likes e comentarios
post <- getPost(post_id, token, n = 1000, likes = TRUE, comments = TRUE)
head(post$comments, n = 2)

# Gravando os comentarios
comments <- post$comments
class(comments)
View(comments)

# Usando SQL
#install.packages("sqldf")
#install.packages("RSQLite")
library(sqldf)

# Usuarios mais influenciadores
infusers <- sqldf("select from_name, sum(likes_count) as totlikes from comments group by from_name")
head(infusers)

# Buscando os "top" influenciadores
infusers$totlikes <- as.numeric(infusers$totlikes)
top <- infusers[order(- infusers$totlikes),]
head(top, n = 10)

# Buscando comentarios de varios posts simultaneamente
post_id <- head(page$id, n = 100)
head(post_id, n = 10)
post_id <- as.matrix(post_id)
allcomments <- ""

# Percorrendo todos os posts e coletando comentarios de todos eles
for (i in 1:nrow(post_id))
{
  post <- getPost(post_id[i,], token, n = 1000, likes = TRUE, comments = TRUE)
  comments <- post$comments
  allcomments <- rbind(allcomments, comments)
}

# Usuarios mais influentes
infusers <- sqldf("select from_name, sum(likes_count) as totlikes from allcomments group by from_name")
infusers$totlikes <- as.numeric(infusers$totlikes)
top <- infusers[order(- infusers$totlikes),]
head(top, n = 20)
View(allcomments)


# Performance da pagina

# Converte o formato de data do Facebook para o formato do R
format.facebook.date <- function(datestring) {
  date <- as.POSIXct(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
}

# Agregando a metrica de counts por mes
aggregate.metric <- function(metric) {
  m <- aggregate(page[[paste0(metric, "_count")]], list(month = page$month), mean)
  m$month <- as.Date(paste0(m$month, "-15"))
  m$metric <- metric
  return(m)
}

# Obtendo os posts da pagina da Nvidia
page <- getPage("nvidiabrasil", token, n = 500)

# Aplicando a agregacao aos dados coletados
page$datetime <- format.facebook.date(page$created_time)
page$month <- format(page$datetime, "%Y-%m")
df.list <- lapply(c("likes", "comments", "shares"), aggregate.metric)
df <- do.call(rbind, df.list)

# Plot
library(ggplot2)
library(scales)

ggplot(df, aes(x = month, y = x, group = metric)) + 
  geom_line(aes(color = metric)) + 
  scale_y_log10("Media de Counts por Mes", breaks = c(10, 100, 1000, 10000, 50000)) + 
  theme_bw() + 
  theme(axis.title.x = element_blank()) + 
  ggtitle("Performance da Pagina no Facebook")

# Salvando a imagem 
ggsave(file="chart.png", dpi = 500)


