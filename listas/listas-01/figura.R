dados <- read.csv("airquality.csv")

pdf("figura.pdf", width = 7, height = 5)

boxplot(
  Ozone ~ Month,
  data = dados,
  xlab = "Mês",
  ylab = "Concentração de Ozônio (ppb)",
  main = "Distribuição de Ozônio por Mês",
  col = "lightblue",
  border = "darkblue"
)

dev.off()
