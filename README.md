# Ibis Docker Setup

This repository provides a Docker-based setup for running [Ibis](https://github.com/Nutomic/ibis), a federated wiki system.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ibis-docker.git
   cd ibis-docker
   ```

2. Edit the configuration (optional):
   - Modify `config.toml` to set your admin credentials and domain

3. Start the services:
   ```bash
   docker-compose up -d
   ```

4. Access Ibis:
   - Open http://localhost:3000 in your browser
   - Login with the admin credentials from config.toml

## Configuration

The main configuration file is `config.toml`. Key settings:

- `[federation].domain` - Your instance's domain
- `[database].connection_url` - PostgreSQL connection string
- `[setup].admin_username` - Initial admin username
- `[setup].admin_password` - Initial admin password
