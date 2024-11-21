 # Use the PHP base image with FPM
 FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    pkg-config \
    openssl

# Install PHP extensions required for Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Create the required directories if they don't exist
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www && chmod -R 755 /var/www \
    && chown -R www-data:www-data /var/www/storage && chmod -R 775 /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache && chmod -R 775 /var/www/bootstrap/cache

# Set permissions for Laravel storage and cache directories
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www \
    && chown -R www-data:www-data /var/www/storage && chmod -R 775 /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache && chmod -R 775 /var/www/bootstrap/cache

# Expose port 8080
EXPOSE 8080

# Start PHP's built-in server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]

