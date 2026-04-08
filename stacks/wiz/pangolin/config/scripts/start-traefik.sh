#!/bin/sh
set -e

echo "Preparing Traefik configuration..."
envsubst < /etc/traefik/traefik_config.yml.template > /etc/traefik/traefik_config.yml
envsubst < /etc/traefik/dynamic_config.yml.template > /etc/traefik/dynamic_config.yml

echo "Starting Traefik..."
exec traefik --configFile=/etc/traefik/traefik_config.yml