#!/bin/bash
# Script: pacotes_removidos.sh
# Descrição: Lista todos os pacotes que foram removidos do sistema

LOG_FILE="/var/log/dpkg.log"

# Extrair pacotes removidos e contar ocorrências
{
    # Pacotes removidos (remove)
    grep " remove " "$LOG_FILE" | awk '{print $4}' | cut -d: -f1
    
    # Pacotes removidos (purge)
    grep " purge " "$LOG_FILE" | awk '{print $4}' | cut -d: -f1
    
} | sort | uniq -c | sort -nr