install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")

library(readr)
library(dplyr)
library(tidyverse)

dados = read.csv2("./dados/atrasadas-paralisadas copy.csv", stringsAsFactors = F)
dados$valor_total_pago = as.numeric(dados$valor_total_pago)
dados$valor_inicial_contrato = as.numeric(dados$valor_inicial_contrato)

# Paralisadas
paralisadas = dados %>% filter(situacao_obra=="Paralisada")
gastos_paralisadas = sum(paralisadas$valor_total_pago, na.rm=T)
valor_inicial_paralisadas = sum(paralisadas$valor_inicial_contrato,na.rm=T)

# Atrasadas
atrasadas = dados %>% filter(situacao_obra=="Atrasada")
gastos_atrasadas = sum(atrasadas$valor_total_pago, na.rm = T)
valor_inicial_atrasadas = sum(atrasadas$valor_inicial_contrato,na.rm=T)

# Atrasadas e Paralisadas
gastos_totais = sum(dados$valor_total_pago, na.rm = T)
valor_inicial_total = sum(dados$valor_inicial_contrato,na.rm=T)

congelado = valor_inicial_total - gastos_totais

# Total de obras
total_obras = length(dados$descricao_obra)



