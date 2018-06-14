# Compreendendo a ordem dos fatores

# Niveis dos fatores
# Internamente, o R armazena valores inteiros e faz um mapeamento para as strings (em ordem alfabetica)
# e agrupa as estat√?sticas por n√?veis.

# Criando vetores
vec1 <- c(1001, 1002, 1003, 1004, 1005)
vec2 <- c(0, 1, 1, 0, 2)
vec3 <- c('Verde','Laranja','Azul','Laranja','Verde')

# Unindo os vetores em um dataframe
df <- data.frame(vec1, vec2, vec3)
df

# Verificando que o R categorizou a ultima coluna como factor
str(df)

# Verificando os niveis do fator. Perceba que os niveis est√£o categorizados em ordem alfabetica
levels(df$vec3)

# Criando uma outra coluna e atribuindo labels
df$cat1 <- factor(df$vec3, labels = c("cor2", "cor1", "cor3"))
df

# Internamente, os fatores sao registrados como inteiros, mas a ordenacao segue a ordem alfabetica
# das strings
str(df)

# Veja como foi feita a atribuicao:
# Azul = cor2
# Laranja = cor1
# Verde = cor3
# Ou seja, os vetores com os labels, seguiram a ordem alfabetica dos niveis classificados pelo R

# Criando uma outra coluna e atribuindo labels
# Ao aplicarmos a fun√ß√£o factor() a coluna vec2, internamente o R classificou em ordem alfabetica
# e quando atribuimos os labels, foi feita a associacao.
df$cat2 <- factor(df$vec2, labels = c("Divorciado", "Casado", "Solteiro"))
df
str(df)
levels(df$cat2)













