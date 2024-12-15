#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Detect operating system
OS="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '\"')"


# Show script startup
echo     
echo     
echo "======================================"
echo "    Pterodactyl Update Script"
echo "    Your OS: $OS"
echo "    Checking if your OS is supported."
echo "======================================"
echo 
sleep 2
# Checking if current OS is supported.
IS_DEBIAN=$(lsb_release -a 2>/dev/null | grep -i "debian" > /dev/null && echo "yes" || echo "no")
if [[ "$OS" == "Ubuntu"* || "$OS" == "Debian"* ]]; then
    WEBSERVER_USER="www-data"
    WEBSERVER_GROUP="www-data"
    echo "Your OS $OS is supported. Starting update process."
    sleep 2
elif [[ "$OS" == "CentOS"* ]]; then
    if systemctl is-active --quiet nginx; then
        WEBSERVER_USER="nginx"
        WEBSERVER_GROUP="nginx"
        echo "Your OS CentOS with Nginx detected. Starting update process."
        sleep 2
    elif systemctl is-active --quiet httpd; then
        WEBSERVER_USER="apache"
        WEBSERVER_GROUP="apache"
        echo "Your OS CentOS with Nginx detected. Starting update process."
        sleep 2
    else
        echo "CentOS detected but no supported web server (nginx or apache) is active. Exiting."
        exit 1
    fi
else
    echo "Unsupported OS detected. Exiting."
    exit 1
fi

# Define pterodactyl directory
PTERODACTYL_DIR="/var/www/pterodactyl"

# Navigate to the Pterodactyl directory
cd "$PTERODACTYL_DIR"

# Put the panel into maintenance mode
php artisan down

# Download and extract the latest release
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

# Fix permissions
chmod -R 755 storage/* bootstrap/cache

# Install dependencies with Composer
if [[ "$IS_DEBIAN" == "yes" ]]; then
    # Use su for Debian
    su -s /bin/bash -c "COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader"
else
    # Use sudo for other systems
    sudo COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
fi

# Clear cached views and configuration
php artisan view:clear
php artisan config:clear

# Run database migrations and seeders
php artisan migrate --seed --force

# Set ownership of files to the web server user and group
chown -R "$WEBSERVER_USER":"$WEBSERVER_GROUP" /var/www/pterodactyl/*

# Restart the queue workers
php artisan queue:restart

# Bring the panel out of maintenance mode
php artisan up

# Notify the user the script has completed
echo "Pterodactyl Panel update completed successfully! If you found this useful, feel free to leave a star on my GitHub."
echo 
