FROM dunglas/frankenphp:php8.2

# Set Caddy Server Name to listen on port 80
ENV SERVER_NAME=":80"

# Install system dependencies and PHP extensions
# install-php-extensions is built-in
RUN install-php-extensions \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    intl \
    opcache

# Install additional system tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

# The default FrankenPHP Caddyfile expects code in /app/public (if root is set to public/)
# or /app (if root is not set). 
# By default, dunglas/frankenphp serves /app/public/index.php if it exists, or /app/index.php.
# Ensure your docker-compose mounts your app to /app.

ENTRYPOINT ["entrypoint"]
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
