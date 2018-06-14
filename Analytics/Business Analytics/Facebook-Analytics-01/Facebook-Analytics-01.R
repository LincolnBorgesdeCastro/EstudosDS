# Facebook Analytics
# https://github.com/pablobarbera/Rfacebook

# ***** Esta é a versão 2.0 deste script, atualizado em 04/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilização da versão 3.4.0 da linguagem R *****

# Pasta de trabalho
setwd("D:\\Pessoal\\Estudos\\DSA\\Business Analytics\\Facebook-Analytics-01\\")
getwd()

#install.packages("devtools") 

# Instalando pacote RFacebook a partir do Github
library(devtools)
#install_github("pablobarbera/Rfacebook", subdir = "Rfacebook", force = TRUE)

# Carregando o pacote
library(Rfacebook)

# Usando token com duração de 2 horas
token <- "EAACEdEose0cBALhsaOTinrrXNOpZAs66ZALClZCyhY9OX2MxFDLlQ24LWs6xStujEjaprrcIkGP7ZCyQu9yT01qDhsSSpagViiMiuJop0RTnJxmdZAQZA4WBkvkZAZBCmix4QvV3mkLBLBxe4N6YZAr2ZCboAegNhOvAPRCGfS8XblLQZDZD"

# Obtendo dados do usuário
user <- getUsers("10204596355468033", token, private_info = TRUE)
user$name  

# Configurando autenticação
# https://developers.facebook.com/apps/
require("Rfacebook")

# Autenticando por 2 meses
fb_oauth <- fbOAuth(app_id = "144474322965288", app_secret = "7bb3ef46dae54ea980e17abc5936259c", extended_permissions = TRUE)

# Salvando a configuração
save(fb_oauth, file = "fb_oauth")
load("fb_oauth")

# Obtendo a lista de usuários
friends <- getFriends(token, simplify = TRUE)
head(friends) 

# Obtendo dados sobre os amigos
friends_data <- getUsers(friends$id, token, private_info = TRUE)

# Sexo
table(friends_data$gender)  

# Idioma
table(substr(friends_data$locale, 1, 2)) 

# Pa�???s
table(substr(friends_data$locale, 4, 5))  

# Status
table(friends_data$relationship_status)


## Network analysis
?getNetwork
network <- getNetwork(token, format = "adj.matrix")
head(network)

# Usando igraph
install.packages("igraph")
require(igraph)

# Social graph
?graph.adjacency
social_graph <- graph.adjacency(network)
layout <- layout.drl(social_graph, options = list(simmer.attraction = 0))

# Plot
plot(social_graph, 
     vertex.size = 10, 
     vertex.color = "green", 
     vertex.label = NA, 
     vertex.label.cex = 0.5,
     edge.arrow.size = 0, 
     edge.curved = TRUE,
     layout = layout.fruchterman.reingold)

# Salvando em png
dev.copy(png,filename = "network.png", width = 600, height = 600)
dev.off()

# Degree - número de conexões diretas que um node tem dentro da rede
# Um degree alto significa que o node tem muitas conexões diretas dentro da rede
degree(social_graph, 
       v = V(social_graph), 
       mode = c("all", "out", "in", "total"), 
       loops = TRUE, 
       normalized = FALSE) 

degree.distribution(social_graph, cumulative = FALSE)

# Betweenness - conceito de centralização
# É calculado com base em quantos pares de indiv�???duos (outros nós na rede) teriam que passar por 
# você (nó para o qual ele é calculado), a fim de alcançar um outro no número m�???nimo de saltos.
# O nó com maior alcance terá uma maior influência no fluxo da informação.
betweenness(social_graph, 
            v = V(social_graph), 
            directed = TRUE, 
            weights = NULL, 
            nobigint = TRUE, 
            normalized = FALSE)

# Closeness
# O quão central você está (nó para o qual é calculado) depende do comprimento do caminho mais curto 
# médio entre o nó de medição e todos os outros nós na rede. Os nós com alta proximidade são muito 
# importantes porque estão em uma excelente posição para monitorar o que está acontecendo na rede, 
# ou seja, nós com maior visibilidade. Esta medida pode não ser muito útil quando nossa rede tem 
# muitos componentes desconectados.
closeness(social_graph, 
          vids = V(social_graph), 
          mode = c("out", "in", "all", "total"), 
          weights = NULL, 
          normalized = FALSE)

# Cluster in network
# Cluster é uma medida em que os nós da rede tendem a se agrupar uns com os outros. 
# Podemos ver quantos clusters existem na nossa rede usando a seguinte função:
is.connected(social_graph, mode = c("weak", "strong"))
clusters(social_graph, mode = c("weak", "strong"))

# Comunidade
# Depois de verificar o número de clusters na rede, vamos verificar como esses clusters são espalhados na rede.
# A função modularity() é utilizada para detectar as comunidades na rede. Ela mede como modular uma 
# divisão dada de um gráfico de rede em subgrafos é, isto é, quão forte é uma divisão dentro de uma rede. 
# As redes com alto grau de modularidade têm conexões fortes entre os nós dentro de seu cluster 
# (grupo / comunidade).
network_Community <- walktrap.community(social_graph)
modularity(network_Community)

# Plot
plot(network_Community, 
     social_graph, 
     vertex.size = 10, 
     vertex.label.cex = 0.5, 
     vertex.label = NA, 
     edge.arrow.size = 0, 
     edge.curved = TRUE,
     layout=layout.fruchterman.reingold)

# Salva a imagem
dev.copy(png,filename = "comunidade.png", width = 600, height = 600)
dev.off()


