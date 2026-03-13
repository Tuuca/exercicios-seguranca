#!/bin/bash
# Script: listar_atualizacoes.sh
# Descrição: Lista todos os pacotes que foram atualizados no sistema, mostrando o nome do pacote e a data da atualização.

LOG_DIR="/var/log/apt"
TEMP_FILE=$(mktemp)

# Processar todos os arquivos history.log (atuais e compactados)
# Formato: Upgrade: pacote:arquitetura (versao_antiga, versao_nova)
for logfile in $LOG_DIR/history.log*; do
    if [[ "$logfile" == *.gz ]]; then
        # Arquivo compactado
        zcat "$logfile" 2>/dev/null | awk '
            /Start-Date:/ {data = substr($0, index($0,":")+2)}
            /Upgrade:/ {
                for(i=1;i<=NF;i++) {
                    if($i ~ /^[a-zA-Z0-9_-]+:/) {
                        split($i, pacote, ":")
                        print data " " pacote[1]
                    }
                }
            }
        '
    else
        # Arquivo texto normal
        cat "$logfile" 2>/dev/null | awk '
            /Start-Date:/ {data = substr($0, index($0,":")+2)}
            /Upgrade:/ {
                for(i=1;i<=NF;i++) {
                    if($i ~ /^[a-zA-Z0-9_-]+:/) {
                        split($i, pacote, ":")
                        print data " " pacote[1]
                    }
                }
            }
        '
    fi
done | sort -k2,2 -k1,1 | awk '
    {
        if ($2 != pacote_anterior) {
            if (pacote_anterior != "") printf "\n"
            printf "%s %s", $2, $1
            pacote_anterior = $2
        } else {
            printf " | %s", $1
        }
    }
    END {printf "\n"}
' | sort

rm -f "$TEMP_FILE"