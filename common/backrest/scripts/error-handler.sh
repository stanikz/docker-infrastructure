#!/bin/bash

HOST=$(hostname)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
ERROR_LOG="/var/log/backrest-errors.log"

{
    echo "[$TIMESTAMP] ❌ BACKUP FAILED on $HOST"
    echo "Task: ${TASK:-unknown}"
    echo "Error: ${ERROR:-unknown}"
    echo "---"
} >> "$ERROR_LOG"

# Ensure ALL stopped containers are turned back on to prevent downtime
echo "[$TIMESTAMP] Error detected - ensuring all stopped containers are restarted..." >> "$ERROR_LOG"
docker ps -a -q --filter "label=backrest.backup=true" \
                --filter "label=backrest.action=stop" \
                --filter "status=exited" 2>/dev/null | while read container; do
    [ -z "$container" ] && continue
    name=$(docker inspect -f '{{.Name}}' "$container" | sed 's/^\///')
    echo "[$TIMESTAMP] Emergency restart: $name" >> "$ERROR_LOG"
    docker start "$container" 2>&1 >> "$ERROR_LOG" || true
done

exit 0
