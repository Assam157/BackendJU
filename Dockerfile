 # Use official PHP image from Docker Hub
FROM php:8.2-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy all project files into the container
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions for Laravel storage and cache folders
RUN chmod -R 775 storage bootstrap/cache

# Expose port 8080 (Laravel uses 8080 in this setup)
EXPOSE 8080

# Command to run PHP's built-in server (Laravel uses public/index.php)
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
