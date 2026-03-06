#!/bin/sh

# Mount the union remote (based on this message: https://discord.com/channels/1148672013028831352/1400845854243422390/1443227583612194948)
rclone mount nzb-dav: /data \
  --allow-non-empty \
  --cache-dir=/mnt/.cache \
  --vfs-cache-mode=full \
  --vfs-read-chunk-size=64M \
  --vfs-read-chunk-size-limit=off \
  --vfs-cache-max-size=100G \
  --vfs-cache-max-age=24h \
  --vfs-read-ahead=512M \
  --dir-cache-time=10s \
  --buffer-size=0M \
  --links \
  --use-cookies \
  --allow-other \
  --uid=1000 \
  --gid=1000 \
  --async-read=true \
  --use-mmap \
  --log-level=INFO \
  --rc \
  --rc-addr=0.0.0.0:9990 \
  --rc-no-auth \
  --rc-web-gui \
  --rc-web-gui-no-open-browser
