# Script para checar as colunas do dataset

# Define o diretorio de trabalho
setwd("/opt/DSA/MachineLearning/Azure/Classificacao")

# Carrega o dataset antes da transformacao
df <- read.csv("credito.csv")
head(df)
str(df)


# Nome das variaveis
# CheckingAcctStat, Duration, CreditHistory, Purpose, CreditAmount, SavingsBonds, Employment, InstallmentRatePecnt, SexAndStatus, OtherDetorsGuarantors, PresentResidenceTime, Property, Age, OtherInstallments, Housing, ExistingCreditsAtBank, Job, NumberDependents, Telephone, ForeignWorker, CreditStatus
