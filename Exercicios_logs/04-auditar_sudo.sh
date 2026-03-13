#!/bin/bash
# Script: auditar_sudo.sh
# Descrição: Lista todas as execuções de comandos sudo com usuário, data/hora e comando executado

LOG_FILE="/var/log/auth.log"

# Extrair eventos de sudo com data/hora, usuário e comando executado
grep "sudo:" "$LOG_FILE" | grep "COMMAND=" | while read line; do
    # Extrair data/hora (formato ISO)
    data=$(echo "$line" | cut -d'T' -f1)
    hora=$(echo "$line" | cut -d'T' -f2 | cut -d'+' -f1 | cut -c1-8)
    
    # Extrair usuário
    usuario=$(echo "$line" | grep -o "sudo: *[^ ]*" | cut -d' ' -f2)
    
    # Extrair comando executado
    comando=$(echo "$line" | grep -o "COMMAND=.*$" | cut -d'=' -f2-)
    
    echo "$data $hora - $usuario - $comando"
done | sort