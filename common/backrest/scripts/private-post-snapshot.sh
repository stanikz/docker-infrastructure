#!/bin/bash
set -e

HOST=$(hostname)
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
LOG_FILE="/var/log/backrest/private-post_${TIMESTAMP}.log"

echo "[$TIMESTAMP] === PRIVATE-DATA POST-SNAPSHOT COMPLETED on $HOST ===" | tee -a "$LOG_FILE"

exit 0
