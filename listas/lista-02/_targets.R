library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("here")
)

# Carrega as funcoes modulares
tar_source("R/funcoes.R")

list(
  # 1. Arquivo de dados de entrada
  tar_target(
    arquivo_dados,
    here::here("dados", "airquality.csv"),
    format = "file"
  ),
  # 2. Dados lidos
  tar_target(
    dados,
    ler_dados(arquivo_dados)
  ),
  # 3. Medias mensais
  tar_target(
    medias_mensais,
    calcular_medias(dados)
  ),
  # 4. Modelo ajustado
  tar_target(
    modelo_ajustado,
    ajustar_modelo(dados)
  ),
  # 5. Figura salva em disco
  tar_target(
    figura_dispersao,
    desenhar_dispersao(
      dados,
      modelo_ajustado,
      here::here("saidas", "dispersao.png")
    ),
    format = "file"
  ),
  # 6. CSV com as medias exportado para saidas/
  tar_target(
    arquivo_medias_csv,
    exportar_medias(
      medias_mensais,
      here::here("saidas", "medias_mensais.csv")
    ),
    format = "file"
  )
)
