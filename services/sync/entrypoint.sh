#!/bin/bash

# Copy cron file to /etc/cron.d/
cp /etc/cron.d/sync-cron-source /etc/cron.d/sync-cron

# Set correct permissions
chmod 0644 /etc/cron.d/sync-cron

# Create log file
touch /var/log/cron.log

# Start cron in foreground
cron -f
