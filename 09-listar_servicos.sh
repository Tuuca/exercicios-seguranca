#!/bin/bash
# Script: listar_servicos.sh
# Descrição: Lista a data e o nome dos serviços que foram iniciados ou parados recentemente.

LOG_ENTRY_TYPE="--type=service"
RECENT_TIME="--since=1 hour ago"

# Executa o journalctl para buscar eventos de serviço iniciados e parados
# e formata a saída para mostrar apenas a data/hora e o nome do serviço.
{
  journalctl $RECENT_TIME $LOG_ENTRY_TYPE --state=started --output=short-iso
  journalctl $RECENT_TIME $LOG_ENTRY_TYPE --state=stopped --output=short-iso
} | grep -E "Started|Stopped" | awk '{print $1, $5}' | sort