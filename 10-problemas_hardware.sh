#!/bin/bash
# Script: problemas_hardware.sh
# Descrição: Busca por mensagens de log que indicam problemas com dispositivos de hardware

LOG_FILE="/var/log/syslog"

# Buscar por problemas de hardware no syslog
grep -i -E "disk|usb|hardware|error|fail|i/o|timeout|disconnect|sda|sdb|hd[a-z]|sd[a-z]" "$LOG_FILE" | grep -i -E "error|fail|timeout|not found|unable|can't|cannot|disconnect|reset" | tail -100