#!/bin/bash
# Script: logs_servicos.sh
# Descrição: Conta a frequência de mensagens por serviço no /var/log/syslog e lista em ordem decrescente

LOG_FILE="/var/log/syslog"

# Extrair nome do serviço (geralmente o campo após o hostname) e contar
grep -v "^#" "$LOG_FILE" | awk '{for(i=1;i<=NF;i++) if($i ~ /.*\[[0-9]+\]:?$/ || $i ~ /^[a-zA-Z0-9_-]+:$/) {print $i; break}}' | sed 's/\[[0-9]*\]://g' | sed 's/://g' | sort | uniq -c | sort -nr