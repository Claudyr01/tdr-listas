## Lê o arquivo CSV bruto e adiciona o nome do mês como fator ordenado
ler_dados <- function(caminho) {
  dados <- read.csv(caminho)
  dados$Nome_Mes <- factor(
    month.name[dados$Month],
    levels = month.name[5:9]
  )
  return(dados)
}

## Calcula a média mensal de Ozone e Wind omitindo valores ausentes
calcular_medias <- function(dados) {
  aggregate(
    cbind(Ozone, Wind) ~ Nome_Mes,
    data = dados,
    FUN = mean,
    na.rm = TRUE
  )
}

## Ajusta um modelo de regressão linear simples com Ozone ~ Wind
ajustar_modelo <- function(dados) {
  lm(Ozone ~ Wind, data = dados)
}

## Desenha a dispersão com a reta de regressão ajustada e salva como PNG
desenhar_dispersao <- function(dados, modelo, caminho_saida) {
  dir.create(dirname(caminho_saida), recursive = TRUE, showWarnings = FALSE)
  png(filename = caminho_saida, width = 800, height = 600, res = 120)
  plot(
    dados$Wind,
    dados$Ozone,
    pch = 19,
    col = "#34495e",
    xlab = "Velocidade do Vento (mph)",
    ylab = "Concentração de Ozônio (ppb)",
    main = "Ozônio vs. Vento"
  )
  abline(modelo, col = "blue", lwd = 2)
  dev.off()
  return(caminho_saida)
}

## Exporta a tabela de médias mensais para um arquivo CSV
exportar_medias <- function(tabela_medias, caminho_saida) {
  dir.create(dirname(caminho_saida), recursive = TRUE, showWarnings = FALSE)
  write.csv(tabela_medias, file = caminho_saida, row.names = FALSE)
  return(caminho_saida)
}
