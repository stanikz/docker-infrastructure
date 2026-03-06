#!/bin/sh
set -e

CONF="$PGDATA/postgresql.conf"
MARKER="# --- custom docker tuning ---"

echo "Postgres tuning entrypoint starting…"

# Apply tuning only once
if ! grep -q "$MARKER" "$CONF"; then
  echo "Applying PostgreSQL tuning to existing config"

  cat >> "$CONF" <<EOF

$MARKER
shared_buffers = 512MB
effective_cache_size = 1536MB
work_mem = 16MB
maintenance_work_mem = 256MB
checkpoint_completion_target = 0.9
max_connections = 100

# Parallelism (2 vCPU LXC-safe)
max_worker_processes = 4
max_parallel_workers = 2
max_parallel_workers_per_gather = 1

# WAL / checkpoints
wal_buffers = 16M
max_wal_size = 2GB
min_wal_size = 512MB

# Planner / I/O (SSD / NVMe)
random_page_cost = 1.1
effective_io_concurrency = 200
EOF
else
  echo "PostgreSQL tuning already present — skipping"
fi

# Hand off to official entrypoint
exec docker-entrypoint.sh postgres
