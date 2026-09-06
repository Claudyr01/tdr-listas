
#!/usr/bin/env bash
set -euo pipefail
##Resume os arquivos CSV de um diretório: nome, linha e tamanho
##
##Uso: ./resumo-csv.sh [diretporio]
##sem argumento, usa diretório atual.
##
##https://fernandomayer.github.io/tdr/02-cliunix.html
##distribuído sog a GPL-3

# 1. Validação dos argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <arquivo.csv> <numero_da_coluna>" >&2
    exit 1
fi

ARQUIVO="$1"
COL="$2"

if [ ! -f "$ARQUIVO" ]; then
    echo "Erro: arquivo '$ARQUIVO' não encontrado." >&2
    exit 1
fi

# 2. Nome da coluna
NOME_COLUNA=$(head -n 1 "$ARQUIVO" | cut -d',' -f"$COL" | tr -d '"\r')
echo "Coluna: $NOME_COLUNA"

# 3. Número de observações
TOTAL_LINHAS=$(wc -l < "$ARQUIVO")
NUM_OBS=$((TOTAL_LINHAS - 1))
echo "Observações: $NUM_OBS"

# 4. Quantidade de valores NA
QTD_NA=$(tail -n +2 "$ARQUIVO" | cut -d',' -f"$COL" | grep -w -c "NA" || true)
echo "Valores NA: $QTD_NA"

# 5. Média da coluna por mês com número de dias medidos (Month = coluna 5)
echo "Média por mês:"
awk -F',' -v c="$COL" '
NR > 1 {
    val = $c
    mes = $5
    if (val != "NA" && val != "") {
        soma[mes] += val
        dias[mes]++
    }
}
END {
    for (m in soma) {
        printf "  Mês %s: média = %.2f (%d dias medidos)\n", m, soma[m]/dias[m], dias[m]
    }
}' "$ARQUIVO" | sort -k2,2n
