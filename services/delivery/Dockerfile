FROM ubuntu:24.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    cron \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /App

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
