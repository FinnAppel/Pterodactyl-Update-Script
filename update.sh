#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Detect operating system
OS="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '\"')"

if [[ "$OS" == "Ubuntu"* || "$OS" == "Debian"* ]]; then
    WEBSERVER_USER="www-data"
    WEBSERVER_GROUP="www-data"
    echo "$OS detected. Using $WEBSERVER_USER:$WEBSERVER_GROUP for ownership."
elif [[ "$OS" == "CentOS"* ]]; then
    if systemctl is-active --quiet nginx; then
        WEBSERVER_USER="nginx"
        WEBSERVER_GROUP="nginx"
        echo "CentOS with Nginx detected. Using $WEBSERVER_USER:$WEBSERVER_GROUP for ownership."
    elif systemctl is-active --quiet httpd; then
        WEBSERVER_USER="apache"
        WEBSERVER_GROUP="apache"
        echo "CentOS with Apache detected. Using $WEBSERVER_USER:$WEBSERVER_GROUP for ownership."
    else
        echo "CentOS detected but no supported web server (nginx or apache) is active. Exiting."
        exit 1
    fi
else
    echo "Unsupported operating system: $OS. Exiting."
    exit 1
fi

# Define the Pterodactyl directory
PTERODACTYL_DIR="/var/www/pterodactyl"

# Navigate to the Pterodactyl directory
cd "$PTERODACTYL_DIR"

# Put the application into maintenance mode
php artisan down

# Download and extract the latest panel release
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

# Set permissions
chmod -R 755 storage/* bootstrap/cache

# Install dependencies with Composer
composer install --no-dev --optimize-autoloader

# Clear cached views and configuration
php artisan view:clear
php artisan config:clear

# Run database migrations and seeders
php artisan migrate --seed --force

# Set ownership of files to the web server user and group
chown -R "$WEBSERVER_USER":"$WEBSERVER_GROUP" "$PTERODACTYL_DIR/*"

# Restart the queue workers
php artisan queue:restart

# Bring the application out of maintenance mode
php artisan up

# Notify the user the script has completed
echo "Pterodactyl Panel update completed successfully."
