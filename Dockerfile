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
    openssl \
    git \
    vim \
    nano \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev

# Install PHP extensions required for Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Install MongoDB extension (if required for your app)
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install the Laravel CORS package
RUN composer require fruitcake/laravel-cors

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Expose port 8000 for the PHP built-in server
EXPOSE 8000

# Start PHP's built-in server (no Nginx needed)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]

 
