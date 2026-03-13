#!/bin/bash
# Script: listar_rejeicoes.sh
# Descrição: Lista logins rejeitados por outros motivos (usuário inexistente, permissão negada, etc.)

LOG_FILE="/var/log/auth.log"

echo "=== LOGINS REJEITADOS POR OUTROS MOTIVOS ==="
echo

echo "1. USUÁRIOS INEXISTENTES:"
{
    # Formato: Invalid user
    grep "Invalid user" "$LOG_FILE" | awk '{for(i=1;i<=NF;i++) if($i=="Invalid" && $(i+1)=="user") print $(i+2)}'
    
    # Formato: user unknown
    grep "user unknown" "$LOG_FILE" | grep -o "user [^,]*" | cut -d' ' -f2
    
    # Formato: FAILED LOGIN for UNKNOWN
    grep "FAILED LOGIN.*FOR 'UNKNOWN'" "$LOG_FILE" | echo "UNKNOWN_USER"
    
} | grep -v "^$" | sort | uniq -c | sort -nr

echo
echo "2. PERMISSÃO NEGADA:"
{
    # Formato: Permission denied
    grep "Permission denied" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: not allowed to authenticate
    grep "not allowed to authenticate" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
} | grep -v "^$" | sort | uniq -c | sort -nr

echo
echo "3. CONTA BLOQUEADA/EXPIRADA:"
{
    # Formato: account locked
    grep "account locked" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: account expired
    grep "account expired" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: password expired
    grep "password expired" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
} | grep -v "^$" | sort | uniq -c | sort -nr

echo
echo "4. LIMITE DE TENTATIVAS EXCEDIDO:"
{
    # Formato: maximum number of tries exceeded
    grep "maximum number of tries exceeded" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: retry limit exceeded
    grep "retry limit exceeded" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
} | grep -v "^$" | sort | uniq -c | sort -nr

echo
echo "5. OUTROS MOTIVOS:"
{
    # Formato: connection closed
    grep "connection closed" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: timeout
    grep "timeout" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
    # Formato: no matching key exchange method
    grep "no matching" "$LOG_FILE" | grep -o "user [^ ]*" | cut -d' ' -f2
    
} | grep -v "^$" | sort | uniq -c | sort -nr