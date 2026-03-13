#!/bin/bash
# Script: monitorar_falhas.sh
# Descrição: Monitora tentativas de login falhas em tempo real

LOG_FILE="/var/log/auth.log"

echo "Monitorando tentativas de login falhas em tempo real"
echo "Data e hora: $(date)"
echo "----------------------------------------"

# Monitorar o arquivo de log em tempo real e filtrar apenas eventos de falha
tail -f "$LOG_FILE" | grep --line-buffered -E "FAILED LOGIN|authentication failure|Invalid user|user unknown"