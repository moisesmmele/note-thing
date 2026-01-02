#!/bin/bash

# Copy cron file to /etc/cron.d/
cp /etc/cron.d/sync-cron-source /etc/cron.d/sync-cron

# Set correct permissions
chmod 0644 /etc/cron.d/sync-cron
chmod +x /scripts/export_notes.sh

# Create log file
touch /var/log/cron.log

# Start Python service in background
echo "Starting Sync Service Daemon..."
python3 /App/main.py &

# Start cron in foreground
echo "Starting Cron..."
cron -f
