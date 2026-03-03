#!/bin/sh

# Mount the union remote
rclone mount nzb-dav: /data \
  --vfs-cache-mode=full \
  --buffer-size=1024 \
  --dir-cache-time=1s \
  --vfs-cache-max-size=5G \
  --vfs-cache-max-age=180m \
  --links \
  --use-cookies \
  --allow-other \
  --allow-non-empty \
  --uid=1000 \
  --gid=1000