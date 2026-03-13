#!/bin/bash
# Script: rastrear_pacotes.sh
# Descrição: Mostra quem executou comandos de gerenciamento de pacotes e qual ação foi realizada

LOG_FILE="/var/log/auth.log"

# Buscar comandos de gerenciamento de pacotes no histórico
{
    # apt e apt-get commands
    grep -E "apt|apt-get|dpkg" "$LOG_FILE" | grep "COMMAND=" | while read line; do
        usuario=$(echo "$line" | grep -o "user [^ ]*" | cut -d' ' -f2)
        comando=$(echo "$line" | grep -o "COMMAND=[^ ]*" | cut -d'=' -f2- | sed 's/^\/usr\/bin\///g')
        
        # Classificar a ação
        if echo "$comando" | grep -q "install"; then
            acao="INSTALAR"
        elif echo "$comando" | grep -q "remove\|purge"; then
            acao="REMOVER"
        elif echo "$comando" | grep -q "update"; then
            acao="ATUALIZAR"
        elif echo "$comando" | grep -q "upgrade\|dist-upgrade"; then
            acao="UPGRADE"
        elif echo "$comando" | grep -q "search"; then
            acao="BUSCAR"
        elif echo "$comando" | grep -q "show"; then
            acao="MOSTRAR"
        else
            acao="OUTRO"
        fi
        
        echo "$usuario | $acao | $comando"
    done
    
    # sudo commands com apt
    grep "sudo.*apt\|sudo.*apt-get\|sudo.*dpkg" "$LOG_FILE" | grep -v "COMMAND=" | while read line; do
        usuario=$(echo "$line" | grep -o "sudo: *[^ ]*" | cut -d' ' -f2)
        comando=$(echo "$line" | grep -o "COMMAND=.*$" | cut -d'=' -f2-)
        
        if [ -n "$usuario" ] && [ -n "$comando" ]; then
            if echo "$comando" | grep -q "install"; then
                acao="INSTALAR"
            elif echo "$comando" | grep -q "remove\|purge"; then
                acao="REMOVER"
            elif echo "$comando" | grep -q "update"; then
                acao="ATUALIZAR"
            elif echo "$comando" | grep -q "upgrade\|dist-upgrade"; then
                acao="UPGRADE"
            else
                acao="OUTRO"
            fi
            echo "$usuario | $acao | $comando"
        fi
    done
    
} | sort | uniq