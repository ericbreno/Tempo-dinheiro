install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("DescTools")

library(readr)
library(dplyr)
library(tidyverse)
library(stats)
library(DescTools)

dados = read.csv("./dados/atrasadas-paralisadas-copy2.csv", stringsAsFactors = F)
dados$valor_total_pago = as.numeric(dados$valor_total_pago)
dados$valor_inicial_contrato = as.numeric(dados$valor_inicial_contrato)

dados_concluidas = read.csv("./dados/concluidas-tratadas.csv", stringsAsFactors = F)
dados_concluidas$valor_total_pago = as.numeric(dados_concluidas$valor_total_pago)
dados_concluidas$valor_inicial_contrato = as.numeric(dados_concluidas$valor_inicial_contrato)

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

# Frequência de entregas por município
municipios_prejudicados = table(dados$municipio_nome)
municipios_prejudicados = as.data.frame(municipios_prejudicados)
municipios_prejudicados = municipios_prejudicados %>% arrange(desc(Freq))
colnames(municipios_prejudicados) = c("Município", "Obras não-entregues")

municipios_obras_entregues = table(dados_concluidas$municipio_nome)
municipios_obras_entregues = as.data.frame(municipios_obras_entregues)
municipios_obras_entregues = municipios_obras_entregues %>% arrange(desc(Freq))
colnames(municipios_obras_entregues) = c("Município", "Obras entregues")

comparacao_municipios = full_join(municipios_prejudicados, municipios_obras_entregues)
comparacao_municipios[is.na(comparacao_municipios)] <- 0
comparacao_municipios$`Total de Obras` = comparacao_municipios$`Obras não-entregues` + comparacao_municipios$`Obras entregues`
comparacao_municipios$`Taxa de Obras Não Entregues` = round((comparacao_municipios$`Obras não-entregues` / comparacao_municipios$`Total de Obras`) * 100, 2)

# Tipo de obra com mais atrasos
tipo_obra = table(dados$classificacao)
tipo_obra = as.data.frame(tipo_obra)
tipo_obra = tipo_obra %>% arrange(desc(Freq))
colnames(tipo_obra) = c("Classificação", "Obras não-entregues")

# Frequência de entrega das empresas
empresas_que_atrasam = table(dados$contratada)
empresas_que_atrasam = as.data.frame(empresas_que_atrasam)
empresas_que_atrasam = empresas_que_atrasam %>% arrange(desc(Freq))
colnames(empresas_que_atrasam) = c("Empresa", "Obras não-entregues")

empresas_que_concluem = table(dados_concluidas$contratada)
empresas_que_concluem = as.data.frame(empresas_que_concluem)
empresas_que_concluem = empresas_que_concluem %>% arrange(desc(Freq))
colnames(empresas_que_concluem) = c("Empresa", "Obras entregues")

comparacao_entregas = full_join(empresas_que_atrasam, empresas_que_concluem)
comparacao_entregas[is.na(comparacao_entregas)] <- 0
comparacao_entregas$`Total de Obras` = comparacao_entregas$`Obras não-entregues` + comparacao_entregas$`Obras entregues`
comparacao_entregas$`Taxa de Obras Não Entregues` = round((comparacao_entregas$`Obras não-entregues` / comparacao_entregas$`Total de Obras`) * 100, 2)
