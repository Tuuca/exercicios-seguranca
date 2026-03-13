#!/bin/bash
# Script: listar_falhas_sistema.sh
# Descrição: Lista eventos de segfault (falha de segmentação) e processos killed no sistema

LOG_FILE="/var/log/syslog"

# Buscar eventos de segfault e killed
{
    # Eventos de segfault (falha de segmentação)
    grep -i "segfault" "$LOG_FILE"
    
    # Processos mortos (killed)
    grep -i "killed" "$LOG_FILE"
    
} | sort | uniq -c | sort -nr