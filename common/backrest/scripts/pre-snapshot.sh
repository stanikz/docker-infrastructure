#!/bin/bash
set -e

HOST=$(hostname)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/var/log/backrest/backrest-pre-snapshot.log"

echo "[$TIMESTAMP] === PRE-SNAPSHOT HOOK STARTED on $HOST ===" | tee -a "$LOG_FILE"

# Function to safely stop containers based on priority
stop_containers() {
    local priority=$1
    echo "[$TIMESTAMP] Checking for $priority priority containers to stop..." | tee -a "$LOG_FILE"
    
    docker ps -q --filter "label=backrest.backup=true" \
                 --filter "label=backrest.priority=$priority" \
                 --filter "label=backrest.action=stop" 2>/dev/null | while read container; do
        [ -z "$container" ] && continue
        name=$(docker inspect -f '{{.Name}}' "$container" | sed 's/^\///')
        wait_time=$(docker inspect -f '{{index .Config.Labels "backrest.wait-time"}}' "$container")
        wait_time=${wait_time:-30} # Fallback to 30s if missing
        
        echo "[$TIMESTAMP] Stopping $name (wait: ${wait_time}s)" | tee -a "$LOG_FILE"
        docker stop --time="$wait_time" "$container" 2>&1 | tee -a "$LOG_FILE" || true
    done
}

# Stop in order: Critical first, then High, then Medium (if any are set to stop)
stop_containers "critical"
stop_containers "high"
stop_containers "medium"

# Log containers that are backing up LIVE (action=none)
echo "[$TIMESTAMP] Containers backing up LIVE (no stop):" | tee -a "$LOG_FILE"
docker ps -q --filter "label=backrest.backup=true" \
             --filter "label=backrest.action=none" 2>/dev/null | while read container; do
    [ -z "$container" ] && continue
    name=$(docker inspect -f '{{.Name}}' "$container" | sed 's/^\///')
    echo "[$TIMESTAMP]   - $name" | tee -a "$LOG_FILE"
done

# Flush filesystem caches to disk
echo "[$TIMESTAMP] Flushing filesystem caches..." | tee -a "$LOG_FILE"
sync
sync
{ echo 3 > /proc/sys/vm/drop_caches; } 2>/dev/null || true

echo "[$TIMESTAMP] === PRE-SNAPSHOT HOOK COMPLETED ===" | tee -a "$LOG_FILE"
exit 0
