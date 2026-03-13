#!/bin/bash
# Script: filtrar_horario.sh
# Descrição: Filtra eventos de um arquivo de log entre 14h e 15h de um dia específico
# Uso: ./filtrar_horario.sh <arquivo_log> <YYYY-MM-DD>

LOG_FILE="$1"
DATA="$2"

if [ ! -f "$LOG_FILE" ] || [ ! -r "$LOG_FILE" ]; then
    echo "Erro: Não foi possível ler $LOG_FILE"
    exit 1
fi

# Filtrar eventos entre 14h e 15h do dia especificado
grep "^$DATA" "$LOG_FILE" | grep -E "T1[4-5]:[0-5][0-9]:[0-5][0-9]"