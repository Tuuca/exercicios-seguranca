#!/bin/bash
# Script: kernel_errors.sh
# Descrição: Filtra e exibe mensagens de erro/falha do kernel

LOG_FILE="/var/log/kern.log"

# Buscar mensagens com palavras-chave de erro/falha
grep -i -E "error|fail|warn|critical|alert|panic" "$LOG_FILE"