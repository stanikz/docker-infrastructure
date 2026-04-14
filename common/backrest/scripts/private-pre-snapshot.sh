#!/bin/bash
set -e

HOST=$(hostname)
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
LOG_FILE="/var/log/backrest/private-pre_${TIMESTAMP}.log"

# Passed from Environment variable
SOURCE_PATH="$PRIVATE_DATA"

echo "[$TIMESTAMP] === PRIVATE-DATA PRE-SNAPSHOT STARTED on $HOST ===" | tee -a "$LOG_FILE"

# 1. Check if the environment variable is actually set
if [ -z "$SOURCE_PATH" ]; then
    echo "[$TIMESTAMP] ❌ ERROR: Environment variable PRIVATE_DATA is not set!" | tee -a "$LOG_FILE"
    exit 1
fi

# 2. Check if source directory exists and is not empty inside the container
if [ ! -d "$SOURCE_PATH" ] || [ -z "$(ls -A "$SOURCE_PATH" 2>/dev/null)" ]; then
    echo "[$TIMESTAMP] ❌ ERROR: Source path $SOURCE_PATH is missing or empty!" | tee -a "$LOG_FILE"
    exit 1 
fi

echo "[$TIMESTAMP] Successfully verified source path: [HIDDEN]" | tee -a "$LOG_FILE"

# 3. Optional: Clean up junk files
#find "$SOURCE_PATH" -name ".DS_Store" -type f -delete 2>/dev/null || true

# 4. Flush filesystem caches
sync && sync

echo "[$TIMESTAMP] === PRIVATE-DATA PRE-SNAPSHOT COMPLETED ===" | tee -a "$LOG_FILE"
exit 0
