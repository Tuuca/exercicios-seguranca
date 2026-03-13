#!/bin/bash
# Script: login_falhas.sh
# Descrição: Lista usuários com tentativas de login falhas e o número de tentativas

LOG_FILE="/var/log/auth.log"

# Extrair nomes de usuário de diferentes formatos de log e contar ocorrências
{
    # FAILED LOGIN ... FOR 'usuario'
    grep "FAILED LOGIN" "$LOG_FILE" | grep -o "FOR '[^']*'" | cut -d"'" -f2
    
    # authentication failure; ... user=usuario
    grep "authentication failure" "$LOG_FILE" | grep -o "user=[^ ;]*" | cut -d= -f2
    
    # Invalid user usuario
    grep "Invalid user" "$LOG_FILE" | awk '{for(i=1;i<=NF;i++) if($i=="Invalid" && $(i+1)=="user") print $(i+2)}'
    
    # user unknown (usuários inexistentes)
    grep "user unknown" "$LOG_FILE" | echo "UNKNOWN"
    
} | grep -v "^$" | sort | uniq -c | sort -nr