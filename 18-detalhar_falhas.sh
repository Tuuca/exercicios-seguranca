#!/bin/bash
# Script: detalhar_falhas.sh
# Descrição: Para cada tentativa de login falha, extrai o nome do usuário e o método de autenticação

LOG_FILE="/var/log/auth.log"

# Processar cada linha de falha de autenticação
grep -E "FAILED LOGIN|authentication failure|Invalid user|Failed password" "$LOG_FILE" | while read line; do
    # Inicializar variáveis
    usuario=""
    metodo=""
    
    # Determinar o método baseado no conteúdo da linha
    if echo "$line" | grep -q "sudo"; then
        metodo="sudo"
    elif echo "$line" | grep -q "sshd"; then
        metodo="ssh"
    elif echo "$line" | grep -q "login"; then
        metodo="login"
    elif echo "$line" | grep -q "su"; then
        metodo="su"
    else
        metodo="outro"
    fi
    
    # Extrair nome do usuário baseado no formato
    if echo "$line" | grep -q "FAILED LOGIN.*FOR '"; then
        # Formato: FAILED LOGIN ... FOR 'usuario'
        usuario=$(echo "$line" | grep -o "FOR '[^']*'" | cut -d"'" -f2)
    elif echo "$line" | grep -q "user="; then
        # Formato: authentication failure; ... user=usuario
        usuario=$(echo "$line" | grep -o "user=[^ ;]*" | cut -d= -f2)
    elif echo "$line" | grep -q "Invalid user"; then
        # Formato: Invalid user usuario
        usuario=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="Invalid" && $(i+1)=="user") print $(i+2)}')
    elif echo "$line" | grep -q "Failed password for"; then
        # Formato: Failed password for usuario
        if echo "$line" | grep -q "invalid user"; then
            usuario=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="invalid" && $(i+1)=="user") print $(i+2)}')
        else
            usuario=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}')
        fi
    fi
    
    # Se não conseguiu extrair usuário, marcar como desconhecido
    if [ -z "$usuario" ]; then
        usuario="DESCONHECIDO"
    fi
    
    # Extrair timestamp
    timestamp=$(echo "$line" | cut -d'T' -f1 2>/dev/null || echo "DATA_DESCONHECIDA")
    
    # Exibir resultado
    echo "$timestamp | Usuário: $usuario | Método: $metodo"
done