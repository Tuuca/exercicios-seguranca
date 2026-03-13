#!/bin/bash
# Script: pacotes_instalados.sh
# Descrição: Lista pacotes instalados na última semana com a data de instalação

LOG_DPKG="/var/log/dpkg.log"
LOG_APT="/var/log/apt/history.log"
DATA_LIMITE=$(date --date="7 days ago" +"%Y-%m-%d")

echo "Pacotes instalados desde $DATA_LIMITE (última semana):"
echo "----------------------------------------"

# Buscar em dpkg.log (incluindo arquivos rotacionados)
{
    # Arquivo atual e arquivos rotacionados (.1, .2.gz, etc.)
    zgrep -h " install " /var/log/dpkg.log* 2>/dev/null | while read line; do
        data=$(echo "$line" | cut -d' ' -f1)
        if [[ "$data" > "$DATA_LIMITE" ]] || [[ "$data" == "$DATA_LIMITE" ]]; then
            pacote=$(echo "$line" | awk '{print $4}' | cut -d':' -f1)
            echo "$data $pacote"
        fi
    done
    
    # Buscar em apt/history.log para complementar
    if [ -f "$LOG_APT" ]; then
        awk -v limite="$DATA_LIMITE" '
            /Start-Date:/ {
                data=$2
                if (data >= limite) { dentro=1 } else { dentro=0 }
            }
            dentro && /Install:/ {
                for (i=2; i<=NF; i++) {
                    gsub(/,/, "", $i)
                    split($i, pkg, ":")
                    print data " " pkg[1]
                }
            }
        ' "$LOG_APT"
    fi
} | sort -u | column -t