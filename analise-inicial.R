install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("DescTools")

library(readr)
library(dplyr)
library(tidyverse)
library(stats)
library(DescTools)

dados = read.csv("./atrasadas-paralisadas copy (copy).csv", stringsAsFactors = F)
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

# Obras que passaram do valor previsto
obras_passaram_valor = dados %>% filter(valor_total_pago > valor_inicial_contrato)
total_obras_passaram_valor = length(obras_passaram_valor$descricao_obra)

obras_passaram_valor$gasto_nao_previsto = obras_passaram_valor$valor_total_pago - obras_passaram_valor$valor_inicial_contrato
gastos_por_cidade = aggregate(obras_passaram_valor$gasto_nao_previsto, by=list(municipio=obras_passaram_valor$municipio_nome), FUN=sum)

# Municípios com mais obras não-entregues
municipios_prejudicados = table(dados$municipio_nome)
municipios_prejudicados = as.data.frame(municipios_prejudicados)
municipios_prejudicados = municipios_prejudicados %>% arrange(desc(Freq))
colnames(municipios_prejudicados) = c("Município", "Obras não-entregues")

# Tipo de obra com mais atrasos
tipo_obra = table(dados$classificacao)
tipo_obra = as.data.frame(tipo_obra)
tipo_obra = tipo_obra %>% arrange(desc(Freq))
colnames(tipo_obra) = c("Classificação", "Obras não-entregues")


