#!/bin/bash
# Script: listar_mensagens_criticas.sh
# Descrição: Lista todas as mensagens de log que contêm "critical", "fatal" ou "segfault"

LOG_DIR="/var/log"
PALAVRAS="critical\|fatal\|segfault"

# Buscar as palavras em todos os arquivos .log do diretório
grep -r -i -h "$PALAVRAS" "$LOG_DIR"/*.log 2>/dev/null | sort | uniq