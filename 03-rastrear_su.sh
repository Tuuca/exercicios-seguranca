#!/bin/bash
# Script: rastrear_su.sh
# Descrição: Rastreia tentativas de uso do comando su, mostrando quem executou e para qual usuário tentou mudar

LOG_FILE="/var/log/auth.log"

# Extrair informações do comando su
grep "su:" "$LOG_FILE" | grep -E "session opened for user|authentication failure|FAILED SU" | while read line; do
    # Caso: su com sucesso (session opened)
    if echo "$line" | grep -q "session opened for user"; then
        de=$(echo "$line" | grep -o "by [^(]*" | cut -d' ' -f2)
        para=$(echo "$line" | grep -o "for user [^)]*" | cut -d' ' -f3)
        echo "SUCESSO: $de -> $para"
    
    # Caso: falha de autenticação no su
    elif echo "$line" | grep -q "authentication failure"; then
        de=$(echo "$line" | grep -o "ruser=[^ ]*" | cut -d= -f2)
        para=$(echo "$line" | grep -o "user=[^ ]*" | cut -d= -f2)
        echo "FALHA: $de -> $para"
    
    # Caso: FAILED SU (formato específico)
    elif echo "$line" | grep -q "FAILED SU"; then
        de=$(echo "$line" | grep -o "BY [^ ]*" | cut -d' ' -f2)
        para=$(echo "$line" | grep -o "TO [^ ]*" | cut -d' ' -f2)
        echo "FALHA: $de -> $para"
    fi
done | sort | uniq -c | sort -nr