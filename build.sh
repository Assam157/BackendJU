#!/bin/bash
# Install necessary dependencies for PHP and Composer

# Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies (via Composer)
composer install --no-dev --optimize-autoloader

# Make sure the permissions are correct for Laravel
chmod -R 775 storage bootstrap/cache
