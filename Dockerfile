 # Use the PHP 8.2 FPM image as the base image
FROM php:8.2-fpm

# Install system dependencies, curl, unzip, and libraries required by Composer and OpenSSL for SSL support
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    libssl-dev \
    ca-certificates \
    pkg-config \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for Laravel (e.g., GD for image processing, etc.)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install MongoDB PHP extension using PECL
RUN pecl install mongodb && \
    docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Add a new user for running the app and change ownership of the directory to that user
RUN useradd -ms /bin/bash myuser

# Switch to the 'root' user temporarily for chown
USER root

# Change the ownership of files and directories to www-data (required for Laravel to work properly)
RUN chown -R www-data:www-data /var/www/html
# Switch back to the 'www-data' user for the rest of the operations
USER www-data

# Install Laravel dependencies using Composer
RUN /usr/local/bin/composer install --no-dev --optimize-autoloader

# Ensure the permissions are correct after Composer installation
RUN chown -R www-data:www-data /var/www/html/vendor
RUN chmod -R 775 /var/www/html/vendor

# Set the port environment variable (this can be changed as needed)
ENV PORT 8080

# Expose the port to be used by Laravel
EXPOSE 8080

# Ensure that necessary directories have the correct permissions for Laravel to write to
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Use artisan to start the Laravel application on the correct port
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=${PORT:-8080}"]
