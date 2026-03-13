#!/bin/bash
# Script: ultimo_boot.sh
# Descrição: Mostra a data e hora do último boot do sistema

# Comando who com opção -b mostra a hora do último boot
who -b | awk '{print $3, $4}'