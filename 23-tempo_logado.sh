#!/bin/bash
# Script: tempo_logado.sh
# Descrição: Calcula o tempo total que cada usuário permaneceu logado no sistema
# Uso: sudo ./tempo_logado.sh [usuario]

LOG_FILE="/var/log/auth.log"

# Se um usuário foi especificado, filtra por ele, senão mostra todos
USUARIO_FILTRO="$1"

# Processar eventos de login e logout
grep -E "session opened|session closed" "$LOG_FILE" | \
    grep -v "sudo" | \
    grep ${USUARIO_FILTRO:+"$USUARIO_FILTRO"} | \
    awk '{
        # Extrair data e hora no formato ISO
        data_hora = $1 " " $2
        gsub(/T/, " ", data_hora)
        gsub(/\+.*/, "", data_hora)
        
        # Converter para timestamp
        cmd = "date -d \"" data_hora "\" +%s 2>/dev/null"
        cmd | getline timestamp
        close(cmd)
        
        if (timestamp == "") next
        
        # Extrair usuário
        for (i=1; i<=NF; i++) {
            if ($i == "user") {
                usuario = $(i+1)
                gsub(/[()]/, "", usuario)
                break
            }
        }
        
        if (usuario == "") next
        
        # Identificar se é abertura ou fechamento de sessão
        if ($0 ~ /session opened/) {
            inicio[usuario] = timestamp
        } else if ($0 ~ /session closed/) {
            if (inicio[usuario] != "") {
                tempo = timestamp - inicio[usuario]
                if (tempo > 0) {
                    total[usuario] += tempo
                }
                delete inicio[usuario]
            }
        }
    } END {
        for (u in total) {
            tempo = total[u]
            horas = int(tempo / 3600)
            minutos = int((tempo % 3600) / 60)
            segundos = tempo % 60
            printf "%s %02d:%02d:%02d\n", u, horas, minutos, segundos
        }
    }' | sort