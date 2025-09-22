#!/bin/sh

# Entrypoint script for keepalived Docker container

# Check if configuration file exists
if [ ! -f /etc/keepalived/keepalived.conf ]; then
    echo "ERROR: No keepalived configuration found at /etc/keepalived/keepalived.conf"
    echo "Please mount your configuration file to /etc/keepalived/keepalived.conf"
    exit 1
fi

# Validate configuration syntax
keepalived -t -f /etc/keepalived/keepalived.conf
if [ $? -ne 0 ]; then
    echo "ERROR: keepalived configuration is invalid"
    exit 1
fi

# Create necessary directories
mkdir -p /var/run/keepalived
mkdir -p /var/log

echo "Starting keepalived..."

# Execute the command passed as arguments or default CMD
exec "$@"