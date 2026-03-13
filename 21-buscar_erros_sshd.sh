#!/bin/bash
# Script: buscar_erros_ssh.sh
# Descrição: Busca mensagens de erro e aviso do serviço SSH no sistema

LOG_FILE="/var/log/auth.log"
SERVICE="sshd"

grep "$SERVICE" "$LOG_FILE" | grep -i "error\|warning\|failed\|failure\|invalid" | while read line; do
    echo "$line"
done | less