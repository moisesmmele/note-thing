#!/bin/bash

# Joplin Configuration
TARGET_ID="${JOPLIN_SYNC_TARGET_ID:-}"
JOPLIN_URL="${JOPLIN_SERVER_URL:-}"
JOPLIN_USER="${JOPLIN_SERVER_EMAIL:-}"
JOPLIN_PASS="${JOPLIN_SERVER_PASSWORD:-}"

# Local Paths
EXPORT_DIR="${EXPORT_DIR:-/data/raw}"

# Redis (Preserved from original)
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_STREAM="${REDIS_STREAM:-note_events}"

# --- Pre-flight Checks ---

if [ -z "$JOPLIN_URL" ]; then
    echo "[$(date -Iseconds)] ERROR: JOPLIN_SERVER_URL is not set."
    exit 1
fi

# --- 1. Configure Joplin (Idempotent) ---

# check if sync.target key in config export is already set;
# if not set, checkenv vars and configure
JOPLIN_CONFIG="$(joplin config --export)"
if ! echo "$JOPLIN_CONFIG" | grep -q "\"sync.target\": $TARGET_ID"; then
    echo "[$(date -Iseconds)] Configuring Joplin CLI..."

    # Safety check for target id
    if [ -z "$TARGET_ID" ]; then
        echo "[$(date -Iseconds)] ERROR: TARGET_ID is not set."
        exit 1
    fi

    joplin config sync.target "$TARGET_ID"
    joplin config "sync.$TARGET_ID.path" "$JOPLIN_URL"
    joplin config "sync.$TARGET_ID.username" "$JOPLIN_USER"
    joplin config "sync.$TARGET_ID.password" "$JOPLIN_PASS"
    joplin config encryption.enabled false
else
    echo "[$(date -Iseconds)] Joplin is already configured."
fi

# --- 2. Sync & Export ---
echo "[$(date -Iseconds)] 1/3: Syncing Joplin from Server..."
# Capture output or suppress if too verbose, checking exit code implicitly with 'set -e' if we had it, but we handle explicit checks or let it run.
# The original script didn't use set -e, but the reference did. We will stick to simple execution but check success.
if joplin sync; then
    echo "[$(date -Iseconds)] Sync complete."
else
    echo "[$(date -Iseconds)] WARNING: Joplin sync failed. Proceeding with export of existing data..."
fi

echo "[$(date -Iseconds)] 2/3: Exporting notes to $EXPORT_DIR..."
# Ensure export directory exists and is empty
mkdir -p "$EXPORT_DIR"
# Clean export dir safely
find "$EXPORT_DIR" -mindepth 1 -delete

if joplin export --format raw "$EXPORT_DIR"; then
    echo "[$(date -Iseconds)] Export successful."
    
    # Notify Redis
    echo "[$(date -Iseconds)] 3/3: Sending SYNC_COMPLETE event to Redis..."
    redis-cli -h "$REDIS_HOST" XADD "$REDIS_STREAM" "*" event SYNC_COMPLETE
    
    echo "[$(date -Iseconds)] Job Complete."
else
    echo "[$(date -Iseconds)] Error: Joplin export failed." >&2
    exit 1
fi
