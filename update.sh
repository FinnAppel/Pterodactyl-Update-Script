#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

# Set ownership of files to the web server user
ochown -R www-data:www-data "$PTERODACTYL_DIR/*"

# Restart the queue workers
php artisan queue:restart

# Bring the application out of maintenance mode
php artisan up

# Notify the user the script has completed
echo "Pterodactyl Panel update completed successfully."
