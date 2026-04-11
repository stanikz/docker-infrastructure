#!/bin/bash
set -e

HOST=$(hostname)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/var/log/backrest-post-snapshot.log"

echo "[$TIMESTAMP] === POST-SNAPSHOT HOOK STARTED on $HOST ===" | tee -a "$LOG_FILE"

# Function to restart containers based on priority
start_containers() {
    local priority=$1
    echo "[$TIMESTAMP] Restarting $priority priority containers..." | tee -a "$LOG_FILE"
    
    docker ps -a -q --filter "label=backrest.backup=true" \
                    --filter "label=backrest.priority=$priority" \
                    --filter "label=backrest.action=stop" \
                    --filter "status=exited" 2>/dev/null | while read container; do
        [ -z "$container" ] && continue
        name=$(docker inspect -f '{{.Name}}' "$container" | sed 's/^\///')
        echo "[$TIMESTAMP] Starting $name" | tee -a "$LOG_FILE"
        docker start "$container" 2>&1 | tee -a "$LOG_FILE" || true
    done
}

# ✅ CORRECTED: Restart in DEPENDENCY order (Critical → High → Medium)
echo "[$TIMESTAMP] Restarting containers in dependency order..." | tee -a "$LOG_FILE"
start_containers "critical"
start_containers "high"
start_containers "medium"

echo "[$TIMESTAMP] === POST-SNAPSHOT HOOK COMPLETED ===" | tee -a "$LOG_FILE"
exit 0
