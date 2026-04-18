#!/bin/sh

# ── Startup: clean any stale mount from previous run ──────────────────────────
MOUNT_POINT="/data"

if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
  echo "[rclone] Stale mount detected at $MOUNT_POINT, cleaning up..."
  fusermount -uz "$MOUNT_POINT" 2>/dev/null || umount -l "$MOUNT_POINT" 2>/dev/null || true
  sleep 1
fi

# ── Shutdown: cleanup on exit ──────────────────────────────────────────────────
cleanup() {
  echo "[rclone] Unmounting $MOUNT_POINT..."
  fusermount -uz "$MOUNT_POINT" || umount -l "$MOUNT_POINT" || true
}
trap cleanup EXIT INT TERM

# ── Mount ──────────────────────────────────────────────────────────────────────
echo "[rclone] Mounting zurg: -> $MOUNT_POINT"
rclone mount zurg: "$MOUNT_POINT" \
  --log-level DEBUG \
  --allow-other \
  --allow-non-empty \
  --dir-cache-time=5s \
  --vfs-cache-mode=full \
  --vfs-cache-max-size=15G \
  --vfs-cache-min-free-space=2G \
  --vfs-cache-max-age=6h \
  --vfs-read-chunk-size=8M \
  --vfs-read-chunk-size-limit=2G \
  --buffer-size=16M \
  --vfs-fast-fingerprint \
  --uid=1000 \
  --gid=1000
