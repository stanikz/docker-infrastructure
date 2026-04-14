#!/bin/bash

HOST=$(hostname)
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
ERROR_LOG="/var/log/backrest/private-errors_${TIMESTAMP}.log"

{
    echo "[$TIMESTAMP] ❌ PRIVATE DATA BACKUP FAILED on $HOST"
    echo "Task: ${TASK:-unknown}"
    echo "Error: ${ERROR:-unknown}"
    echo "---"
} >> "$ERROR_LOG"

exit 0
