#!/bin/bash
# Script: listar_shutdown.sh
# Descrição: Lista todos os eventos de desligamento (shutdown) e reinicialização do sistema

LOG_FILE="/var/log/auth.log"
LOG_SYSLOG="/var/log/syslog"

{
    # Shutdown e reboot via comando (shutdown, reboot, halt, poweroff)
    grep -E "shutdown|reboot|halt|poweroff" "$LOG_FILE" | grep -E "COMMAND=|USER=" | grep -o "USER=[^ ]*" | cut -d= -f2
    
    # Sistema sendo desligado (systemd)
    grep "System is shutting down" "$LOG_FILE" | echo "SYSTEM"
    
    # Reinicializações (reboot)
    grep "reboot:" "$LOG_FILE" | grep -o "by [^ ]*" | cut -d' ' -f2
    
    # Desligamentos via init
    grep "init:" "$LOG_FILE" | grep "shutdown" | echo "INIT"
    
    # Logs do syslog para eventos de shutdown/reboot
    if [ -f "$LOG_SYSLOG" ] && [ -r "$LOG_SYSLOG" ]; then
        grep -E "Shutdown|Reboot|desligamento|reinicialização" "$LOG_SYSLOG" | grep -o "by [^ ]*" | cut -d' ' -f2
    fi
    
} | grep -v "^$" | sort | uniq -c | sort -nr