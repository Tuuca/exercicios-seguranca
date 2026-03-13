#!/bin/bash
# Script: tempo_atividade.sh
# Descrição: Mostra o tempo de atividade atual do sistema

echo "Tempo de atividade do sistema:"
uptime -p
echo "Desde: $(uptime -s)"