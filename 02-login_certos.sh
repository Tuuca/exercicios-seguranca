#!/bin/bash
# Script: login-certos.sh
# Descrição: Lista todos os logins bem-sucedidos no sistema com usuário e data/hora

LOG_FILE="/var/log/auth.log"

# Extrair informações de logins bem-sucedidos
{
    # Formato: session opened for user usuario
    grep "session opened for user" "$LOG_FILE" | grep -v "sudo" | while read line; do
        data=$(echo "$line" | cut -d'T' -f1)
        hora=$(echo "$line" | cut -d'T' -f2 | cut -d'+' -f1 | cut -c1-8)
        usuario=$(echo "$line" | grep -o "user [^ ]*" | cut -d' ' -f2)
        echo "$data $hora - $usuario"
    done
    
    # Formato: login session opened (para logins no terminal)
    grep "login:session.*opened" "$LOG_FILE" | while read line; do
        data=$(echo "$line" | cut -d'T' -f1)
        hora=$(echo "$line" | cut -d'T' -f2 | cut -d'+' -f1 | cut -c1-8)
        usuario=$(echo "$line" | grep -o "user [^ ]*" | cut -d' ' -f2)
        echo "$data $hora - $usuario"
    done
    
    # Formato: Accepted password for usuario (logins SSH)
    grep "Accepted password for" "$LOG_FILE" | while read line; do
        data=$(echo "$line" | cut -d'T' -f1)
        hora=$(echo "$line" | cut -d'T' -f2 | cut -d'+' -f1 | cut -c1-8)
        usuario=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}')
        echo "$data $hora - $usuario"
    done
    
} | grep -v "^$" | sort