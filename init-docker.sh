#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# Function to check and create network
create_network() {
  local NETWORK_NAME=$1
  if [ -z "$NETWORK_NAME" ]; then
    echo "Network name is not defined."
    return
  fi

  if docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}$"; then
    echo "Network '$NETWORK_NAME' already exists."
  else
    echo "Creating network '$NETWORK_NAME'..."
    docker network create "$NETWORK_NAME"
  fi
}

# Function to check and create volume
create_volume() {
  local VOLUME_NAME=$1
  if [ -z "$VOLUME_NAME" ]; then
    echo "Volume name is not defined."
    return
  fi

  if docker volume ls --format '{{.Name}}' | grep -q "^${VOLUME_NAME}$"; then
    echo "Volume '$VOLUME_NAME' already exists."
  else
    echo "Creating volume '$VOLUME_NAME'..."
    docker volume create "$VOLUME_NAME"
  fi
}

# Create Resources
echo "Initializing Docker resources..."

# Create Network
create_network "$NETWORK_NAME"

# Create Volumes
create_volume "$MONGO_VOLUME_NAME"
create_volume "$FILES_VOLUME_NAME"
create_volume "$NATS_VOLUME_NAME"

echo "Docker resources initialization complete."
