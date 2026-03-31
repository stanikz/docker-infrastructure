# docker-infrastructure

## My homelab docker infrastructure



This repository operates as a monorepo designed to manage infrastructure and deployments across multiple servers using a GitOps approach. It is organized into four primary root directories:

📂 bootstrap
Contains foundational services that require manual deployment. These components are necessary to establish the initial connection or environment before the repository can be synced with the Komodo server instance.

📂 common
Houses global services and configurations that are intended to be deployed across all servers in the infrastructure (e.g., monitoring agents, base networking tools).

📂 old-compose
Here resides all the compose files that are outdate/old, which have either been moved to the common templating services or completely removed. 

📂 services
A catalog of optional or experimental services. These are fully configured deployment files for applications that are currently not active in "production" but are available for future use or testing ("nice-to-haves").

📂 stacks
This is the core directory containing active production deployments. It is segmented by server, where each folder represents a distinct machine with a specific purpose and goal.


As of 2026-03-31, the infrastructure consists of the following server stacks:

```
 stacks
    ├── ai
    ├── dietpi
    ├── docker
    ├── media
    ├── stremio
    └── vps
    
```

- ai – Services that utilizes AI and LLM workloads - e.g.; ollama
- dietpi – Lightweight utility services - pocketid (OIDC) service and nginx proxy manager for internal DNS + adsblock
- docker – General container management
- media – Media server applications (Plex/Arr stack)
- stremio – streaming services
- vps - Services that resides inside my VPS
