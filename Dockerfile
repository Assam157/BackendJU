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

# Install PHP extensions required for Laravel (pdo, pdo_mysql, etc.)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Install MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install the Laravel CORS package (if required in your project)
# RUN composer require fruitcake/laravel-cors  # Uncomment if needed

# Disable output buffering globally (important for header and response issues)
RUN echo "output_buffering = Off" >> /usr/local/etc/php/conf.d/docker-php.ini

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Set permissions for Laravel storage and cache directories
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www \
    && chown -R www-data:www-data /var/www/storage && chmod -R 775 /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache && chmod -R 775 /var/www/bootstrap/cache

# Expose port 8080 (or any port you want to run the app on)
EXPOSE 8080

# Start PHP's built-in server on port 8080 (or 8000 if preferred)
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]

 
